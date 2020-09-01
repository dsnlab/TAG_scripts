#!/bin/bash
#
# This script runs FreeSurfer 6.0 recon-all
# and extracts the data, which includes the
# all morphological measurements at vertex
# and parcellated scales. Run this script
# by running the batch_reconall.sh file
# and calling on subject_list.txt

echo -e "\nSetting Up Freesurfer6.0"

source /projects/dsnlab/shared/tag/TAG_scripts/sMRI/SetUpFreeSurfer.sh 

echo -e "\nFreesurfer Home is $FREESURFER_HOME"

SUBJECTS_DIR=/projects/dsnlab/shared/tag/bids_data/derivatives/freesurfer

echo -e "\nThe Subject Directory is $SUBJECTS_DIR"

echo -e "\Running recon-all on ${SUBID}"

echo -e "\nSetting Up FSL 5.0.9"

module load fsl/5.0.10

echo -e "\nSetting Up AFNI"

module load prl
module load afni

echo -r "\nSet DWI directory"

DWI_DIR=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc

echo -e "\nCreate structural constraints"

#move relevant files from FS to DWI folder
mkdir -p $DWI_DIR/$SUBJ/ses-wave1/anat
mri_convert $SUBJECTS_DIR/sub-$SUBJ/mri/rawavg.mgz $DWI_DIR/$SUBJ/ses-wave1/anat/str.nii.gz
mri_convert $SUBJECTS_DIR/sub-$SUBJ/mri/orig.mgz $DWI_DIR/$SUBJ/ses-wave1/anat/fs.nii.gz
mri_binarize --i $SUBJECTS_DIR/sub-$SUBJ/mri/aparc+aseg.mgz --ventricles --o $DWI_DIR/$SUBJ/ses-wave1/anat/ventricles.nii.gz
mri_binarize --i $SUBJECTS_DIR/sub-$SUBJ/mri/aparc+aseg.mgz --match 2 --o $DWI_DIR/$SUBJ/ses-wave1/anat/wm.lh.nii.gz
mri_binarize --i $SUBJECTS_DIR/sub-$SUBJ/mri/aparc+aseg.mgz --match 41 --o $DWI_DIR/$SUBJ/ses-wave1/anat/wm.rh.nii.gz
mri_binarize --i $SUBJECTS_DIR/sub-$SUBJ/mri/aparc+aseg.mgz --match 2 41 --o $DWI_DIR/$SUBJ/ses-wave1/anat/wm.nii.gz

#Put binarized wm filenames into txt file
ls -1 $DWI_DIR/$SUBJ/ses-wave1/anat/wm.?h* > $DWI_DIR/$SUBJ/ses-wave1/masks/waypoints.txt

#also copy over label files & white surfaces
#rsync $SUBJECTS_DIR/sub-$SUBJ/surf/{l,r}h.white $DWI_DIR/$SUBJ/ses-wave1/anat/surf/

echo -e "\nCreate registrations from FS<>STR<>FA"

#transform filenames
fs2str=$DWI_DIR/$SUBJ/ses-wave1/dwi.fit.bedpostX/xfms/fs2str.mat
str2fs=$DWI_DIR/$SUBJ/ses-wave1/dwi.fit.bedpostX/xfms/str2fs.mat
fa2fs=$DWI_DIR/$SUBJ/ses-wave1/dwi.fit.bedpostX/xfms/fa2fs.mat
fs2fa=$DWI_DIR/$SUBJ/ses-wave1/dwi.fit.bedpostX/xfms/fs2fa.mat
fa2str=$DWI_DIR/$SUBJ/ses-wave1/dwi.fit.bedpostX/xfms/fa2str.mat
str2fa=$DWI_DIR/$SUBJ/ses-wave1/dwi.fit.bedpostX/xfms/str2fa.mat

#specify some images
fa=$DWI_DIR/$SUBJ/ses-wave1/dwi/dti_FA.nii.gz
str=$DWI_DIR/$SUBJ/ses-wave1/anat/str.nii.gz

# register structurual to FS
tkregister2 --mov $DWI_DIR/$SUBJ/ses-wave1/anat/fs.nii.gz --targ $DWI_DIR/$SUBJ/ses-wave1/anat/str.nii.gz --regheader --reg junk --fslregout $fs2str --noedit

#invert to create str2fs
convert_xfm -omat $str2fs -inverse $fs2str
	
#now transforming FA to structural:
flirt -in $fa -ref $str -omat $fa2str -dof 6

#invert to create str2fa
convert_xfm -omat $str2fa -inverse $fa2str
	
#Concatenate and inverse
convert_xfm -omat $fa2fs -concat $str2fs $fa2str
convert_xfm -omat $fs2fa -inverse $fa2fs

echo -e "\nConvert parcellation from surface labels to volumetric masks"

#Convert each parcel to volume:

ROIs=${SUBJECTS_DIR}/sub-${SUBJ}/SUMA/aparc+aseg_REN_gm.nii.gz
outdir=${DWI_DIR}/${SUBJ}/ses-wave1/anat/labels

mkdir -p ${outdir}

# put the GM map into DWI space/coors
printf "\n\nTransfer the GM ROIs to DWI space.\n\n"
3dresample -master ${DWI_DIR}/${SUBJ}/ses-wave1/dwi/dti_FA.nii.gz        \
    -prefix ${outdir}/DWI_CONNrois.nii             \
    -inset $ROIs                  \
    -overwrite

# minor inflation, 1 vox 
printf "\n\nMinorly inflate GM ROIs which are not touching WM,\n"
printf "\tas defined by the FA mask the GM ROIs to DWI space.\n\n"
3dROIMaker                                                \
    -wm_skel ${DWI_DIR}/${SUBJ}/ses-wave1/dwi/dti_FA.nii.gz \
    -skel_thr 0.2   -skel_stop                            \
    -inflate 1                                            \
    -inset ${outdir}/DWI_CONNrois.nii                 \
    -refset ${outdir}/DWI_CONNrois.nii                \
    -prefix ${outdir}/DWI_CONNrois_ROI	            \
    -overwrite

3dAFNItoNIFTI -prefix ${outdir}/DWI_CONNrois_ROI_GM ${outdir}/DWI_CONNrois_ROI_GM+orig.
3dAFNItoNIFTI -prefix ${outdir}/DWI_CONNrois_ROI_GMI ${outdir}/DWI_CONNrois_ROI_GMI+orig.

ROILIST=`cat roi_list.txt`

for ROI in ${ROILIST[@]}

do

roi_num=`echo $ROI|awk '{print $1}' FS=","`
roi_name=`echo $ROI|awk '{print $2}' FS=","`

fslmaths ${outdir}/DWI_CONNrois_ROI_GMI.nii -thr $roi_num -uthr $roi_num -bin ${outdir}/${roi_name}.nii.gz	

done

echo -e "\nPreparation complete"

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

echo -e "\nThe Subject Directory is $SUBJECTS_DIR"

echo -e "\Running recon-all on ${SUBID}"

echo -e "\nSetting Up FSL 5.0.9"

module load fsl/5.0.9

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
fs2str=$DWI_DIR/$SUBJ/ses-wave1/dwi.bedpostX/xfms/fs2str.mat
str2fs=$DWI_DIR/$SUBJ/ses-wave1/dwi.bedpostX/xfms/str2fs.mat
fa2fs=$DWI_DIR/$SUBJ/ses-wave1/dwi.bedpostX/xfms/fa2fs.mat
fs2fa=$DWI_DIR/$SUBJ/ses-wave1/dwi.bedpostX/xfms/fs2fa.mat
fa2str=$DWI_DIR/$SUBJ/ses-wave1/dwi.bedpostX/xfms/fa2str.mat
str2fa=$DWI_DIR/$SUBJ/ses-wave1/dwi.bedpostX/xfms/str2fa.mat

#specify some images
fa=$DWI_DIR/$SUBJ/ses-wave1/dwi/dti_FA.nii.gz
str=$DWI_DIR/$SUBJ/ses-wave1/anat/str.nii.gz

# register structurual to FS
tkregister2 --mov $DWI_DIR/$SUBJ/ses-wave1/anat/fs.nii.gz --targ $DWI_DIR/$SUBJ/ses-wave1/anat/str.nii.gz --regheader --reg junk --fslregout $fs2str --noedit

#invert to create str2fs
convert_xfm -omat $str2fs -inverse $fs2str
	
#now transforming FA to structural:
flirt -in $fa -ref $str -omat $fa2str -dof 6

# invert to create str2fa
convert_xfm -omat $str2fa -inverse $fa2str
	
# Concatenate and inverse
convert_xfm -omat $fa2fs -concat $str2fs $fa2str
convert_xfm -omat $fs2fa -inverse $fa2fs

echo -e "\nConvert parcellation from surface labels to volumetric masks"

#Convert each parcel to volume:

aparc=`ls /projects/dsnlab/shared/tag/TAG_scripts/sMRI/templates/fsaveragelabels/*`

for parc in $aparc; do

	label=${parc##*/}
	vol=${label/%.label/.nii.gz}

	label=$SUBJECTS_DIR/sub-$SUBJ/label/fromannots/$label
	vol=$SUBJECTS_DIR/sub-$SUBJ/mri/fromannots/$lvol
	dil_vol=$DWI_DIR/$SUBJ/ses-wave1/anat/label/$label

	echo -e "\nConverting $label to $vol"

	mri_label2vol --subject $SUBJ --label $label --temp $DWI_DIR/$SUBJ/ses-wave1/anat/fs.nii.gz --o $vol --identity --fillthresh 0.5
	mri_binarize --i $vol --o $dil_vol --match 1 --dilate 1 
	fscalc $DWI_DIR/$SUBJ/ses-wave1/anat/wm.nii.gz and $_dil_vol --o $dil_vol  # parcel inside WM

done

echo -e "\nPreparation complete"


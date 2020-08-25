#!/bin/bash
#
# This scripts maps the annotation files to the subs
# then makes them into labels, and finally creates
# volume files for each of the labels.
#

echo "job_map_annots.sh ran on $(date) $line"

echo -e "\nSetting Up Freesurfer6.0"

source /projects/dsnlab/shared/tag/TAG_scripts/sMRI/SetUpFreeSurfer.sh

echo -e "\nSetting up AFNI"

module use /projects/tau/packages/Modules/modulefiles/
module load afni

templatedir="/projects/dsnlab/shared/tag/TAG_scripts/sMRI/templates/"
rsfMRIdir="/projects/dsnlab/shared/tag/bids_data/derivatives/rsfMRI_preproc_wave1"

echo -e "\nFreesurfer Home is $FREESURFER_HOME"
echo -e "\nThe Subject Directory is $SUBJECTS_DIR"
echo -e "\nThe Template Directory is $templatedir"
echo -e "\nThe Freesurfer output Directory is $freesurferdir"
echo -e "\nThe Resting state output Directory is $rsfMRIdir"

pushd $SUBJECTS_DIR/$SUBID/label/ && mkdir fromannots && popd
pushd $SUBJECTS_DIR/$SUBID/mri/ && mkdir fromannots && popd

mri_surf2surf --srcsubject fsaverage --trgsubject $SUBID --hemi lh --sval-annot $templatedir/lh.mentalizing.annot --tval $SUBJECTS_DIR/$SUBID/label/lh.mentalizing.annot
mri_annotation2label --subject ${SUBID} --hemi lh --annotation $SUBJECTS_DIR/$SUBID/label/lh.mentalizing.annot --outdir $SUBJECTS_DIR/$SUBID/label/fromannots/

mri_surf2surf --srcsubject fsaverage --trgsubject $SUBID --hemi rh --sval-annot $templatedir/rh.mentalizing.annot --tval $SUBJECTS_DIR/$SUBID/label/rh.mentalizing.annot
mri_annotation2label --subject ${SUBID} --hemi rh --annotation $SUBJECTS_DIR/$SUBID/label/rh.mentalizing.annot --outdir $SUBJECTS_DIR/$SUBID/label/fromannots/


mri_label2vol --label $SUBJECTS_DIR/$SUBID/label/fromannots/lh.Left-mentalizing.label --subject $SUBID --hemi lh --identity --temp $SUBJECTS_DIR/$SUBID/mri/orig --o $SUBJECTS_DIR/$SUBID/mri/fromannots/lh.mentalizing.nii.gz --proj frac 0 1 0.01
mri_binarize --dilate 1 --erode 1 --i $SUBJECTS_DIR/$SUBID/mri/fromannots/lh.mentalizing.nii.gz --o $SUBJECTS_DIR/$SUBID/mri/fromannots/lh.mentalizing_bi.nii.gz --min 1
mris_calc -o $SUBJECTS_DIR/$SUBID/mri/fromannots/lh.mentalizing_final.nii.gz $SUBJECTS_DIR/$SUBID/mri/fromannots/lh.mentalizing_bi.nii.gz mul $SUBJECTS_DIR/$SUBID/mri/lh.ribbon.mgz
mv $SUBJECTS_DIR/$SUBID/mri/fromannots/lh.mentalizing_final.nii.gz $SUBJECTS_DIR/$SUBID/mri/fromannots/lh.mentalizing.nii.gz

mri_label2vol --label $SUBJECTS_DIR/$SUBID/label/fromannots/rh.Right-mentalizing.label --subject $SUBID --hemi rh --identity --temp $SUBJECTS_DIR/$SUBID/mri/orig --o $SUBJECTS_DIR/$SUBID/mri/fromannots/rh.mentalizing.nii.gz --proj frac 0 1 0.01
mri_binarize --dilate 1 --erode 1 --i $SUBJECTS_DIR/$SUBID/mri/fromannots/rh.mentalizing.nii.gz --o $SUBJECTS_DIR/$SUBID/mri/fromannots/rh.mentalizing_bi.nii.gz --min 1 
mris_calc -o $SUBJECTS_DIR/$SUBID/mri/fromannots/rh.mentalizing_final.nii.gz $SUBJECTS_DIR/$SUBID/mri/fromannots/rh.mentalizing_bi.nii.gz mul $SUBJECTS_DIR/$SUBID/mri/rh.ribbon.mgz
mv $SUBJECTS_DIR/$SUBID/mri/fromannots/rh.mentalizing_final.nii.gz $SUBJECTS_DIR/$SUBID/mri/fromannots/rh.mentalizing.nii.gz

pushd $rsfMRIdir/$SUBID/"${SUBID}".results/ && mkdir alignedrois && popd
pushd $rsfMRIdir/$SUBID/"${SUBID}".results/ && mkdir timecourses && popd

3dcalc -a $SUBJECTS_DIR/$SUBID/mri/fromannots/lh.mentalizing.nii.gz -b $SUBJECTS_DIR/$SUBID/mri/fromannots/rh.mentalizing.nii.gz -expr 'a+b' -prefix $SUBJECTS_DIR/$SUBID/mri/fromannots/both.mentalizing.nii.gz

3dAllineate -source $SUBJECTS_DIR/$SUBID/mri/fromannots/both.mentalizing.nii.gz -master $rsfMRIdir/"${SUBID}"/"${SUBID}".results/*r01.volreg.nii.gz -final NN -1Dparam_apply '1D: 12@0'\' -overwrite -prefix $rsfMRIdir/"${SUBID}"/"${SUBID}".results/alignedrois/both.mentalizing_aligned.nii.gz 

3dmaskave -quiet -mask $rsfMRIdir/"${SUBID}"/"${SUBID}".results/alignedrois/both.mentalizing_aligned.nii.gz $rsfMRIdir/"${SUBID}"/"${SUBID}".results/errts."${SUBID}".fanaticor.nii.gz > $rsfMRIdir/"${SUBID}"/"${SUBID}".results/timecourses/"${SUBID}"_both.mentalizing.txt

pushd $templatedir/lists
asegrois=`cat asegrois.txt`
popd

3dAllineate -source $SUBJECTS_DIR/$SUBID/SUMA/aparc+aseg.nii.gz -master $rsfMRIdir/"${SUBID}"/"${SUBID}".results/*r01.volreg.nii.gz -final NN -1Dparam_apply '1D: 12@0'\' -overwrite -prefix $rsfMRIdir/"${SUBID}"/"${SUBID}".results/aparc+aseg_aligned.nii.gz 


for asegroi in $asegrois; do
	3dmaskave -quiet -mrange "${asegroi}" "${asegroi}" -mask $rsfMRIdir/"${SUBID}"/"${SUBID}".results/aparc+aseg_aligned.nii.gz $rsfMRIdir/"${SUBID}"/"${SUBID}".results/errts."${SUBID}".fanaticor.nii.gz > $rsfMRIdir/"${SUBID}"/"${SUBID}".results/timecourses/"${SUBID}"_aseg_"${asegroi}".txt
done

echo "job_vols2timecourses.sh finished on $(date) $line"


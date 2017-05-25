#!/bin/bash
#
# This scripts maps the annotation files to the subs
# then makes them into labels, and finally creates
# volume files for each of the labels.
#

echo "job_map_annots.sh ran on $(date) $line"

echo -e "\nSetting Up Freesurfer6.0"

source /projects/dsnlab/tag/TAG_scripts/sMRI/SetUpFreeSurfer.sh

echo -e "\nSetting up AFNI"

module use /projects/tau/packages/Modules/modulefiles/
module load afni

templatedir="/projects/dsnlab/tag/TAG_scripts/sMRI/templates/"

echo -e "\nFreesurfer Home is $FREESURFER_HOME"
echo -e "\nThe Subject Directory is $SUBJECTS_DIR"
echo -e "\nThe Template Directory is $templatedir"
echo -e "\nThe Freesurfer output Directory is $freesurferdir"
echo -e "\nThe Resting state output Directory is $rsfMRIdir"

pushd $templatedir/lists
lhannots=`cat lhannots.txt`
rhannots=`cat rhannots.txt`
lhlabels=`cat lhlabels.txt`
rhlabels=`cat rhlabels.txt`

pushd $SUBJECTS_DIR/$SUBID/label/ && mkdir fromannots && popd
pushd $SUBJECTS_DIR/$SUBID/mri/ && mkdir fromannots && popd

for annot in $lhannots; do
	mri_surf2surf --srcsubject fsaverage --trgsubject $SUBID --hemi lh --sval-annot $templatedir/"${annot}".annot --tval $SUBJECTS_DIR/$SUBID/label/"${annot}".annot
	mri_annotation2label --subject ${SUBID} --hemi lh --annotation $SUBJECTS_DIR/$SUBID/label/"${annot}".annot --outdir $SUBJECTS_DIR/$SUBID/label/fromannots/
done

for annot in $rhannots; do
	mri_surf2surf --srcsubject fsaverage --trgsubject $SUBID --hemi rh --sval-annot $templatedir/"${annot}".annot --tval $SUBJECTS_DIR/$SUBID/label/"${annot}".annot
	mri_annotation2label --subject ${SUBID} --hemi rh --annotation $SUBJECTS_DIR/$SUBID/label/"${annot}".annot --outdir $SUBJECTS_DIR/$SUBID/label/fromannots/
done

for label in $lhlabels; do
	mri_label2vol --label $SUBJECTS_DIR/$SUBID/label/fromannots/"${label}".label --subject $SUBID --hemi lh --identity --temp $SUBJECTS_DIR/$SUBID/mri/orig --o $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}".nii.gz --proj frac 0 1 0.01
	mri_binarize --dilate 1 --erode 1 --i $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}".nii.gz --o $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}"_bi.nii.gz --min 1
	mris_calc -o $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}"_final.nii.gz $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}"_bi.nii.gz mul $SUBJECTS_DIR/$SUBID/mri/lh.ribbon.mgz 
	rm $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}"_bi.nii.gz
	rm $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}".nii.gz
	mv $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}"_final.nii.gz $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}".nii.gz
 done

 for label in $rhlabels; do
	mri_label2vol --label $SUBJECTS_DIR/$SUBID/label/fromannots/"${label}".label --subject $SUBID --hemi rh --identity --temp $SUBJECTS_DIR/$SUBID/mri/orig --o $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}".nii.gz --proj frac 0 1 0.01
	mri_binarize --dilate 1 --erode 1 --i $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}".nii.gz --o $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}"_bi.nii.gz --min 1
	mris_calc -o $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}"_final.nii.gz $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}"_bi.nii.gz mul $SUBJECTS_DIR/$SUBID/mri/rh.ribbon.mgz 
	rm $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}"_bi.nii.gz
	rm $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}".nii.gz
	mv $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}"_final.nii.gz $SUBJECTS_DIR/$SUBID/mri/fromannots/"${label}".nii.gz
 done


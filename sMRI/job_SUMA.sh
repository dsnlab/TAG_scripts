#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the job_SUMA.sh file for 
# each subject. It saves the ouput
# and error files in their specified
# directories.
#

echo "job_SUMA.sh ran on $(date) $line"

echo -e "\nSetting Up Freesurfer6.0"

source /projects/dsnlab/shared/tag/TAG_scripts/sMRI/SetUpFreeSurfer.sh 

echo -e "\nSetting up AFNI"

module use /projects/tau/packages/Modules/modulefiles/
module load afni

echo -e "\nFreesurfer Home is $FREESURFER_HOME"

echo -e "\nThe Subject Directory is $SUBJECTS_DIR"

cd $SUBJECTS_DIR/$SUBID

echo -e "\nRunning SUMA Make Spec on ${SUBID}"

@SUMA_Make_Spec_FS -sid "${SUBID}" -NIFTI

cd SUMA

echo -e "\nCreating ventricle and white matter masks"

3dcalc -a aparc+aseg.nii -datum byte -prefix "${SUBID}"_vent.nii -expr 'amongst(a,4,43)'
3dcalc -a aparc+aseg.nii -datum byte -prefix "${SUBID}"_WM.nii -expr 'amongst(a,2,7,16,41,46,251,252,253,254,255)'



#!/bin/bash

# This script concatenates resting-state runs

module load afni

echo -------------------------------------------------------------------------------
echo "${SUB}" "${WAVE}" "run-1 to run-2"
echo "Running ${SCRIPT}"
date
echo -------------------------------------------------------------------------------


# Set paths and variables
# ------------------------------------------------------------------------------------------
# paths
fmriprep_subject_dir=/projects/dsnlab/shared/tag/fmriprep_20.2.1/fmriprep/sub-TAG"${SUB}"/ses-"${WAVE}"/func

# concatenate runs
cd $fmriprep_subject_dir

3dTcat -prefix tcat_sub-TAG"${SUB}"_ses-"${WAVE}"_task-rest_space-MNI152NLin2009cAsym.nii.gz sub-TAG"${SUB}"_ses-"${WAVE}"_task-rest_"${FIRST_RUN}"_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz sub-TAG"${SUB}"_ses-"${WAVE}"_task-rest_"${SECOND_RUN}"_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz

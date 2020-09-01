#!/bin/bash

# Load FSL
module load fsl/5.0.10
export FSLPARALLEL=slurm

# Set directory names
datadir="/projects/dsnlab/shared/tag/bids_data"
scriptsdir="/projects/dsnlab/shared/tag/TAG_scripts/dMRI"
outputdir="/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc"

# Set error log file
errorlog=""$scriptsdir"/errorlog_fslfirst.txt"

# Create error log file
touch "${errorlog}"

if [ -f $("$outputdir"/"${subid}"/ses-wave1/anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz) ]; then

cd "$outputdir"/"${subid}"/ses-wave1/anat
echo segmenting "${subid}" subcortical structures 
run_first_all -i sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz -o sub-"${subid}"_ses-wave1

fi

else
# Making a note of missing files in error log
echo "ERROR: no reoriented mprage; nothing to parcellate"
echo "$outputdir"/sub-"${subid}"/ses-wave1/dwi: MISSING REORIENTED MPRAGE >> $errorlog
fi

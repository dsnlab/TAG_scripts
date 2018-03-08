#!/bin/bash
#
# This script runs fmriprep on subjects located in the 
# BIDS directory and saves ppc-ed output and motion confounds
# in the derivatives folder.

# Set bids directories
bids_dir="${group_dir}""${study}"/bids_data
derivatives="${bids_dir}"/derivatives/mriqc
working_dir="${derivatives}"/working
image="${group_dir}""${container}"

echo -e "\nFmriprep on ${subid}_${sessid}"
echo -e "\nContainer: $image"
echo -e "\nSubject directory: $bids_dir"

# Load packages
module load singularity

# Create working directory
# mkdir -p $working_dir

# Run container using singularity
cd $bids_dir

singularity run --bind "${group_dir}":"${group_dir}" $image $bids_dir $derivatives participant --participant_label $subid --session-id $sessid -w $working_dir --n_procs 16 --mem_gb 64

# Restructure mriqc output to be more consistent with fmriprep/bids structure (waves nested within subjects)
cd $derivatives
mkdir -p sub-$subid/ses-$sessid
mv reports/sub-"${subid}"_ses-"${sessid}"* sub-$subid/ses-$sessid
mv derivatives/sub-"${subid}"_ses-"${sessid}"* sub-$subid/ses-$sessid

echo -e "\n"
echo -e "\n"
echo -e "\ndone"
echo -e "\n-----------------------"

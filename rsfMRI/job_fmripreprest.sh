#!/bin/bash
#
# This script runs fmriprep on subjects located in the 
# BIDS directory and saves ppc-ed output and motion confounds
# in the derivatives folder.

# Set bids directories
bids_dir="${group_dir}""${study}"/bids_data
derivatives="${bids_dir}"/derivatives
working_dir="${derivatives}"/working_bids_fmripreprest/
image="${group_dir}""${container}"

echo -e "\nFmriprep on $subid"
echo -e "\nContainer: $image"
echo -e "\nSubject directory: $bids_dir"

# Source task list 
task="rest"

# Load packages
module load singularity

# Create working directory
mkdir -p $working_dir

# Run container using singularity
cd $bids_dir

#for task in $tasks; do

echo -e "\nStarting on: $task"
echo -e "\n"

export FS_LICENSE=/projects/dsnlab/shared/tag/TAG_scripts/sMRI/license.txt

singularity run --bind "${group_dir}":"${group_dir}" $image $bids_dir $derivatives participant --participant_label $subid -w $working_dir -t $task --use-syn-sdc --output-space {'template','fsaverage5','fsnative'} --fs-license-file $FS_LICENSE

echo -e "\n"
echo -e "\ndone"
echo -e "\n-------------------------------"

#done

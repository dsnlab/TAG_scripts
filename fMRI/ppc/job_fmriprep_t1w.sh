#!/bin/bash
#
# This script runs fmriprep on subjects located in the 
# BIDS directory and saves ppc-ed output and motion confounds
# in the derivatives folder.

# Set bids directories
bids_dir="${group_dir}""${study}"/bids_data
derivatives="${bids_dir}"/derivatives
working_dir="${derivatives}"/working_svc_t1w/
image=/projects/dsnlab/shared/"${container}"

echo -e "\nFmriprep on $subid"
echo -e "\nContainer: $image"
echo -e "\nSubject directory: $bids_dir"

# Source task list
#tasks=`cat tasks.txt` 
task="SVC"

# Load packages
module load singularity

# Create working directory
mkdir -p $working_dir

# Run container using singularity
cd $bids_dir

#for task in $tasks; do

echo -e "\nStarting on: $task"
echo -e "\n"

export FS_LICENSE=/projects/dsnlab/barendse/license.txt

singularity run --bind "${group_dir}":"${group_dir}" $image $bids_dir $derivatives participant --participant_label $subid -w $working_dir -t $task --output-space 'T1w' --fs-license-file $FS_LICENSE

echo -e "\n"
echo -e "\ndone"
echo -e "\n-------------------------------"

/usr/bin/rm -rvf /tmp/fmriprep*${subid}*

#done

#!/bin/bash
#
# This script runs fmriprep on subjects located in the 
# BIDS directory and saves ppc-ed output and motion confounds
# in the derivatives folder.

# Set bids directories
bids_dir="${group_dir}""${study}"/bids_data
derivatives="${group_dir}""${study}"/fmriprep_20.2.1/wave2
working_dir="${derivatives}"/working_wave2/
image="${group_dir}""${container}"

echo -e "\nFmriprep on ${subid}_${sessid}"
echo -e "\nContainer: $image"
echo -e "\nSubject directory: $bids_dir"

# Source task list
tasks=`cat tasks.txt` 
#task="DSD"

# Load packages
module load singularity

# Create working directory
mkdir -p $working_dir

# Run container using singularity
cd $bids_dir

for task in $tasks; do

echo -e "\nStarting on: $task"
echo -e "\n"

export SINGULARITYENV_FS_LICENSE=/projects/dsnlab/shared/BIDS/freesurfer_license.txt

singularity run --cleanenv --bind "${group_dir}":"${group_dir}" $image $bids_dir $derivatives \
	participant --participant_label ${subid} -w $working_dir -t $task \
	--output-spaces T1w MNI152NLin2009cAsym MNIPediatricAsym:res-2:cohort-5 fsaverage5 fsnative \
	--use-syn-sdc --fs-license-file ${group_dir}BIDS/license.txt --ignore slicetiming fieldmaps

echo $FS_LICENSE
echo -e "\n"
echo -e "\ndone"
echo -e "\n-------------------------------"

/usr/bin/rm -rvf /tmp/fmriprep*${subid}*

done

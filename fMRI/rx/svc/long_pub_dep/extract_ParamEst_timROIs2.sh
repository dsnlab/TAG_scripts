#!/bin/bash
#SBATCH --job-name=extract_pes
#SBATCH --output=/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/output/extract_paramest6.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --account=dsnlab
#SBATCH --partition=ctn
#SBATCH --time=720

# This script extracts mean parameter estimates and SDs within an ROI or parcel
# from subject FX contrasts. Output is saved as a text file in the output directory.
# Marjolein August 2020

# Set subject list
SUBJLIST=`cat subjectlist.txt`

module load afni

# Set paths and variables
# ------------------------------------------------------------------------------------------
# variables
rois=(TempPole vlPFC)
waves=(wave1 wave2)
contrasts=(0008 0009)

for SUB in $SUBJLIST; do

# paths
contrast_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1and2/event/sub-"${SUB}" #contrast directory
roi_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/ResidTiming #roi directory 
output_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/ResidTiming #parameter estimate output directory

if [ ! -d ${output_dir} ]; then
	mkdir -p ${output_dir}
fi

echo -------------------------------------------------------------------------------
echo "Extracting parameter estimates for ${SUB}"
date
echo -------------------------------------------------------------------------------

# Extract mean parameter estimates and SDs for each subject, wave, and roi
# contrast 12: Self > Change 
# ------------------------------------------------------------------------------------------
for roi in ${rois[@]}; do 
	for wave in ${waves[@]}; do 
		for contrast in ${contrasts[@]}; do 
			echo "${SUB}" "${wave}" "${roi}" "${contrast}" `3dmaskave -sigma -quiet -mask "${roi_dir}"/"${roi}"_cluster+tlrc "${contrast_dir}"/"${wave}"/con_"${contrast}".nii` >> "${output_dir}"/"${roi}"_SandC_ParameterEstimates.txt
		done
	done
done

done 
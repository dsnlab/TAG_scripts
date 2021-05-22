#!/bin/bash
#SBATCH --job-name=extract_pe
#SBATCH --output=/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/output/extract_paramestTP.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --account=dsnlab
#SBATCH --partition=ctn
#SBATCH --time=720

# This script extracts mean parameter estimates and SDs within an ROI or parcel
# from subject FX contrasts. Output is saved as a text file in the output directory.
# Marjolein Oct 2020

# Set subject list
SUBJLIST=`cat subjectlist.txt`

module load afni

# Set paths and variables
# ------------------------------------------------------------------------------------------
# variables
rois=(TempPole vlPFC)
waves=(wave1 wave2)
betas=`echo $(printf "beta_%04d.nii\n" {1..50}) $(printf "beta_%04d.nii\n" {57..106})`

for SUB in $SUBJLIST; do
for wave in ${waves[@]}; do
# paths
beta_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1and2/betaseries/"${wave}"/sub-"${SUB}" #beta directory
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
# ------------------------------------------------------------------------------------------
	for roi in ${rois[@]}; do 
		for beta in ${betas[@]}; do 
		echo "${SUB}" "${wave}" "${beta}" "${roi}" `3dmaskave -quiet -mask "${roi_dir}"/"${roi}"_cluster+tlrc "${beta_dir}"/"${beta}"` >> "${output_dir}"/"${roi}"_ParameterEstimates.txt
		done
	done
done

done 
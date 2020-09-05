#!/bin/bash

# This script extracts mean parameter estimates and SDs within an ROI or parcel
# from subject FX betas. Output is saved as a text file in the output directory.

module load afni

echo -------------------------------------------------------------------------------
echo "${SUB}"
echo "Running ${SCRIPT}"
date
echo -------------------------------------------------------------------------------


# Set paths and variables
# ------------------------------------------------------------------------------------------
# variables
rois=(TPJ dlPFC dmPFC)
betas=`echo $(printf "beta_%04d.nii\n" {1..50}) $(printf "beta_%04d.nii\n" {57..106})`

# paths
beta_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/betaseries/sub-"${SUB}" #beta directory
roi_dir=/projects/dsnlab/shared/tag/bids_data/derivatives/freesurfer_w1/sub-"${SUB}"/mri/fromannots #roi directory 
output_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/betaseries/parameterEstimates #parameter estimate output directory

if [ ! -d ${output_dir} ]; then
	mkdir -p ${output_dir}
fi

# Extract mean parameter estimates and SDs for each subject, beta, and roi/parcel
# ------------------------------------------------------------------------------------------
for roi in ${rois[@]}; do 
	3dAllineate -source "${roi_dir}"/"${roi}".nii.gz -master "${beta_dir}"/mask.nii -final NN -1Dparam_apply '1D: 12@0'\' -prefix "${roi_dir}"/aligned_"${roi}"
	for beta in ${betas[@]}; do 
	echo "${SUB}" "${beta}" "${roi}" `3dmaskave -sigma -quiet -mask "${roi_dir}"/aligned_"${roi}"+tlrc "${beta_dir}"/"${beta}"` >> "${output_dir}"/"${SUB}"_parameterEstimates.txt
	done
done


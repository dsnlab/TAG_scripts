#!/bin/bash

# This script extracts mean parameter estimates and SDs within an ROI or parcel
# from subject FX betas. Output is saved as a text file in the output directory.

module load afni

echo -------------------------------------------------------------------------------
echo "${SUB}"
echo "Running ${SCRIPT}"
echo -------------------------------------------------------------------------------
date


# Set paths and variables
# ------------------------------------------------------------------------------------------
# variables
rois=(inflated_vmPFC NAcc primary_aud_sphere_rad4_n56_n16_0 primary_vis_sphere_rad4_n4_n88_4)
# waves=(wave1 wave2 wave3)
betas=`echo $(printf "beta_%04d.nii\n" {1..41})`

#for WAVE in ${waves[@]} ; do

# paths
beta_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/waves123/betaseries/sub-TAG"${SUB}" #beta directory
roi_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/roi/cheng_spf  #roi directory
output_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/waves123/betaseries/parameterEstimates #parameter e$

if [ ! -d ${output_dir} ]; then
        mkdir -p ${output_dir}
fi

# Extract mean parameter estimates and SDs for each subject, beta, and roi
# ------------------------------------------------------------------------------------------
for roi in ${rois[@]}; do
	3dAllineate -source "${roi_dir}"/"${roi}".nii.gz -master "${beta_dir}"/mask.nii -final NN -1Dparam_apply '1D: 12@0'\' -prefix "${roi_dir}"/aligned/"${SUB}"_aligned_"${roi}"
	for beta in ${betas[@]}; do 
		echo "${SUB}" "${beta}" "${roi}" `3dmaskave -sigma -quiet -mask "${roi_dir}"/aligned/"${SUB}"_aligned_"${roi}"+tlrc "${beta_dir}"/"${beta}"` >> "${output_dir}"/"${SUB}"_parameterEstimates.txt
done

done


#!/bin/bash

# This script extracts mean parameter estimates and SDs within an ROI or parcel
# from subject FX betas. Output is saved as a text file in the output directory.

module load afni

echo -------------------------------------------------------------------------------
echo "${SUB}" "${WAVE}" "${RUN}"
echo "Running ${SCRIPT}"
date
echo -------------------------------------------------------------------------------


# Set paths and variables
# ------------------------------------------------------------------------------------------
# variables
rois=(inflated_vmPFC NAcc primary_aud_sphere_rad4_n56_n16_0 primary_vis_sphere_rad4_n4_n88_4)

# paths
xcp_sub_dir=/projects/dsnlab/shared/tag/fmriprep_20.2.1/xcp_output/sub-TAG"${SUB}"/ses-"${WAVE}"/run-"${RUN}"  # /projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/waves123/betaseries/sub-TAG"${SUB}" #beta directory
roi_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/roi/cheng_spf  #roi directory 
output_dir=/projects/dsnlab/shared/tag/nonbids_data/rsMRI/cheng_spf/timecourses # timecourse output directory

if [ ! -d ${output_dir} ]; then
	mkdir -p ${output_dir}
fi

echo "starting 3dmaskave"

# Extract mean parameter estimates and SDs for each subject, beta, and roi
# ------------------------------------------------------------------------------------------
for roi in ${rois[@]}; do
	
	3dAllineate -source "${roi_dir}"/"${roi}".nii.gz -master "${xcp_sub_dir}"/norm/sub-TAG"${SUB}"_ses-"${WAVE}"_run-"${RUN}"_maskStd.nii.gz -final NN -1Dparam_apply '1D: 12@0'\' -prefix "${roi_dir}"/aligned/"${SUB}"_run-"${RUN}"_xcp_aligned_"${roi}"

	`3dmaskave -sigma -quiet -mask "${roi_dir}"/aligned/"${SUB}"_run-"${RUN}"_xcp_aligned_"${roi}"+orig "${xcp_sub_dir}"/norm/sub-TAG"${SUB}"_ses-"${WAVE}"_run-"${RUN}"_std.nii.gz` >> "${output_dir}"/"${SUB}"_run-"${RUN}"_"${roi}"_timecourse.txt

done

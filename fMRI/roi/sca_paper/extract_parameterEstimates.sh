#!/bin/bash

# This script extracts mean parameter estimates and SDs within an ROI or parcel
# from subject FX contrast files. Output is saved as a text file in the output directory.

module load afni

echo -------------------------------------------------------------------------------
echo "${SUB}"
echo "Running ${SCRIPT}"
date
echo -------------------------------------------------------------------------------


# Set paths and variables
# ------------------------------------------------------------------------------------------
# variables
hcp_rois=(HCP_PCC) #vmPFC pgACC sgACC)
schaefer_rois=(schaefer_PCC) #schaefer_vmPFC schaefer_pgACC schaefer_sgACC)
cons_files=`echo $(printf "con_%04d.nii\n" {1..32})`
models=(s4_mni_fd  s4_mni_regr  s4_ped_fd  s4_ped_regr  s6_mni_fd  s6_mni_regr  s6_ped_fd  s6_ped_regr)
waves=(wave1 wave2)
roi_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/roi #roi directory 
output_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1and2/event_alltheways_forsca/parameterEstimates #parameter estimate output directory

if [ ! -d ${output_dir} ]; then
	mkdir -p ${output_dir}
fi

for model in ${models[@]}; do 
for wave in ${waves[@]}; do 
con_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1and2/event_alltheways_forsca/"${model}"/"${wave}"/sub-"${SUB}" #con directory

# Extract mean parameter estimates and SDs for each subject, con, and roi/parcel
# ------------------------------------------------------------------------------------------
# HCP atlas
for roi in ${hcp_rois[@]}; do 
3dAllineate -overwrite -source "${roi_dir}"/"${roi}".nii.gz -master "${con_dir}"/mask.nii -final NN -1Dparam_apply '1D: 12@0'\' -prefix "${roi_dir}"/aligned_"${roi}"_"${SUB}"
for con in ${cons_files[@]}; do 
echo "${SUB}" "${wave}" "${model}" "${con}" HCP "${roi}" `3dmaskave -sigma -quiet -mask "${roi_dir}"/aligned_"${roi}"_"${SUB}"+tlrc "${con_dir}"/"${con}"` >> "${output_dir}"/"${SUB}"_parameterEstimates.txt
done
rm  "${roi_dir}"/aligned_"${roi}"_"${SUB}"*
done

# Schaefer atlas
for roi in ${schaefer_rois[@]}; do 
3dAllineate -overwrite -source "${roi_dir}"/"${roi}".nii.gz -master "${con_dir}"/mask.nii -final NN -1Dparam_apply '1D: 12@0'\' -prefix "${roi_dir}"/aligned_"${roi}"_"${SUB}"
for con in ${cons_files[@]}; do 
echo "${SUB}" "${wave}" "${model}" "${con}" schaefer "${roi}" `3dmaskave -sigma -quiet -mask "${roi_dir}"/aligned_"${roi}"_"${SUB}"+tlrc "${con_dir}"/"${con}"` >> "${output_dir}"/"${SUB}"_parameterEstimates.txt
done
rm  "${roi_dir}"/aligned_"${roi}"_"${SUB}"*
done

done
done

# remove aligned ROIs
# rm aligned*.BRIK
# rm aligned*.HEAD

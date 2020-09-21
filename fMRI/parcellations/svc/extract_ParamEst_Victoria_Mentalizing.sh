#!/bin/bash
#SBATCH --job-name=extract_pe
#SBATCH --output=/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/output/extract_paramest_mentaliz.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --account=dsnlab
#SBATCH --partition=ctn
#SBATCH --time=1440

# This script extracts mean parameter estimates and SDs within an ROI or parcel
# from subject FX contrasts. Output is saved as a text file in the output directory.
# Marjolein August 2020 

# Set subject list
SUBJLIST=`cat vic_subjectlist.txt`

module load afni

# Set paths and variables
# ------------------------------------------------------------------------------------------
# variables
rois=(vmpfc ltpj rtpj dmpfc)
waves=(wave1 wave2)

for SUB in $SUBJLIST; do

# paths
contrast_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1and2/event/sub-"${SUB}" #contrast directory
roi_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/roi/victoria_mentalizing #roi directory 
output_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/roi/victoria_mentalizing/ParameterEstimates #parameter estimate output directory

if [ ! -d ${output_dir} ]; then
	mkdir -p ${output_dir}
fi

echo -------------------------------------------------------------------------------
echo "Extracting parameter estimates for ${SUB}"
date
echo -------------------------------------------------------------------------------

# Extract mean parameter estimates and SDs for each subject, wave, and roi
# contrast 12: self > change
# ------------------------------------------------------------------------------------------
for roi in ${rois[@]}; do 
	for wave in ${waves[@]}; do 
	3dAllineate -source "${roi_dir}"/"${roi}"_roi_mentalizing.nii.gz -master "${contrast_dir}"/"${wave}"/mask.nii -final NN -1Dparam_apply '1D: 12@0'\' -prefix "${roi_dir}"/aligned_"${SUB}"_"${wave}"_"${roi}"
	echo "${SUB}" "${wave}" "${roi}" `3dmaskave -sigma -quiet -mask "${roi_dir}"/aligned_"${SUB}"_"${wave}"_"${roi}"+tlrc "${contrast_dir}"/"${wave}"/con_0012.nii` >> "${output_dir}"/"${roi}"_ParameterEstimates.txt
	done
done

done 
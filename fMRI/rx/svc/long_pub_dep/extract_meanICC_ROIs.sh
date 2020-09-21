#!/bin/bash
#SBATCH --job-name=extract_icc
#SBATCH --output=/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/output/extract_icc.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4G
#SBATCH --account=dsnlab
#SBATCH --partition=ctn
#SBATCH --time=60
#SBATCH --time=0-01:00:00

# This script extracts mean ICC within an ROI or parcel
# Output is saved as a text file in the output directory.
# Marjolein May 2020

module load afni

# Set paths and variables
# ------------------------------------------------------------------------------------------
# variables
rois=(vmPFCpgACC dmPFC PrecPCC vStriatum opcvisual motor_finger)

# paths
roi_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/roi/Brainnetome #roi directory 
output_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/ICC #parameter estimate output directory

if [ ! -d ${output_dir} ]; then
	mkdir -p ${output_dir}
fi

for roi in ${rois[@]}; do 

echo -------------------------------------------------------------------------------
echo "Extracting mean ICC values for ${roi}"
date
echo -------------------------------------------------------------------------------

echo "ROI mean sigma" >> "${output_dir}"/meanICC_ROIs.txt
echo "${roi}" `3dmaskave -sigma -quiet -mask "${roi_dir}"/aligned_"${roi}"+tlrc "${output_dir}"/ICC"${roi}"+tlrc[Subj]` >> "${output_dir}"/meanICC_ROIs.txt
echo "min" `3dmaskave -min -quiet -mask "${roi_dir}"/aligned_"${roi}"+tlrc "${output_dir}"/ICC"${roi}"+tlrc[Subj]` >> "${output_dir}"/meanICC_ROIs.txt
echo "max" `3dmaskave -max -quiet -mask "${roi_dir}"/aligned_"${roi}"+tlrc "${output_dir}"/ICC"${roi}"+tlrc[Subj]` >> "${output_dir}"/meanICC_ROIs.txt

done

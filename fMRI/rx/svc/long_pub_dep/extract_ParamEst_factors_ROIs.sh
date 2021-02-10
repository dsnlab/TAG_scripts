#!/bin/bash
#SBATCH --job-name=extract_pef
#SBATCH --output=/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/output/extract_paramest5.log
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
rois=(vmPFCpgACC dmPFC PrecPCC vStriatum)
waves=(wave1 wave2)
contrasts=(0013 0014 0015)

for SUB in $SUBJLIST; do

# paths
contrast_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1and2/event/sub-"${SUB}" #contrast directory
roi_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/roi/Brainnetome/aligned #roi directory 
output_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/ROI #parameter estimate output directory

if [ ! -d ${output_dir} ]; then
	mkdir -p ${output_dir}
fi

echo -------------------------------------------------------------------------------
echo "Extracting parameter estimates for ${SUB}"
date
echo -------------------------------------------------------------------------------

# Extract mean parameter estimates and SDs for each subject, wave, and roi
# contrasts: Self prosocial > Change prosocial, Self antisocial > Change antisocial, and Self sociability > Change sociability
# ------------------------------------------------------------------------------------------
for roi in ${rois[@]}; do 
	for wave in ${waves[@]}; do 
		for contrast in ${contrasts[@]}; do 
			echo "${SUB}" "${wave}" "${roi}" "${contrast}" `3dmaskave -quiet -mask "${roi_dir}"/"${SUB}"_"${wave}"_aligned_"${roi}"+tlrc "${contrast_dir}"/"${wave}"/con_"${contrast}".nii` >> "${output_dir}"/"${roi}"_3factors_ParameterEstimates.txt
		done
	done
done

done 
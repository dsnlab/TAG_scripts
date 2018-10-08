#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=extractParams
#SBATCH --output=output/extractParams_AR.log
#SBATCH --error=output/extractParams_AR_err.log
#SBATCH --cpus-per-task=25
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=fat,short

# This script extracts mean parameter estimates and SDs within an ROI or parcel
# from subject FX condition contrasts (condition > rest). Output is 
# saved as a text file in the output directory.

module load afni

# Set paths and variables
# ------------------------------------------------------------------------------------------
# paths
fx_dir='/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/pmod/MLmotion_FAST_RT' #FX input directory
output_dir='/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/dsd/wave1/rois' #ROI output directory

# variables
subjects=`cat /projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/dsd/wave1/3dMEMA/subject_list.txt`
fx_cons=(con_0001 con_0002 con_0003 con_0004 con_0005 con_0006 con_0007 con_0008 con_0009 con_0010 con_0011 con_0012 con_0013 con_0014 con_0015 con_0016 con_0017 con_0018 con_0019 con_0020 con_0021 con_0021 con_0022 con_0023 con_0024 con_0025 con_0026 con_0027) #fx con files to extract from
rois=(lNAcc_25 rNAcc_25 vmPFC_meta dmPFC_int precuneus_int SMA_int PMC_int)

for roi in ${rois[@]}; do 
	for sub in ${subjects[@]}; do 
		for con in ${fx_cons[@]}; do 
			if [ -a $fx_dir/$sub/${con}.nii ]; then
				echo ${sub} ${con} `3dmaskave -sigma -quiet -mrange 1 1 -mask $output_dir/masks/${roi}.nii.gz $fx_dir/$sub/${con}.nii` >> $output_dir/paramEstimates_${roi}.txt
			fi
		done
	done
done

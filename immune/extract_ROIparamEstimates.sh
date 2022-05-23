#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=extractParams
#SBATCH --output=output/extractParams.log
#SBATCH --error=output/extractParams_err.log
#SBATCH --cpus-per-task=25
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=short
#SBATCH -A dsnlab

# This script extracts mean parameter estimates and SDs within an ROI or parcel
# from subject FX condition contrasts (condition > rest). Output is 
# saved as a text file in the output directory.

module load afni

# Set paths and variables
# ------------------------------------------------------------------------------------------
# paths
fx_dir='/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event' #FX input directory
output_dir='/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/wave1/immune/rois' #ROI output directory

# variables
subjects=`cat /projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/wave1_immune/subject_list_immune.txt`
fx_cons=(con_0012) #fx con files to extract from
rois=(lHippo_50 rHippo_50 lAmyg_50 rAmyg_50 vmPFC dmPFC precuneus llOFC rlOFC lvlPFC rvlPFC lATC rATC lpSTS rpSTS lTPJ rTPJ lNAcc_25 rNAcc_25)

#lNAcc_25 rNAcc_25 dmPFC_int precuneus_int SMA_int PMC_int

for roi in ${rois[@]}; do
	echo $roi 
	for sub in ${subjects[@]}; do 
		for con in ${fx_cons[@]}; do 
			if [ -a $fx_dir/$sub/${con}.nii ]; then
				echo ${sub} ${con} `3dmaskave -sigma -quiet -mrange 1 1 -mask $output_dir/masks/${roi}.nii $fx_dir/$sub/${con}.nii` >> $output_dir/paramEstimates_${roi}.txt
			fi
		done
	done
done

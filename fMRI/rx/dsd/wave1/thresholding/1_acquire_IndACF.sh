#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=ind_ACF
#SBATCH --output=output/ind_ACF_out.log
#SBATCH --error=output/ind_ACF_err.log
#SBATCH --cpus-per-task=25
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=fat,short

# This script calculates the smoothness (acf parameters) of FX residual files
# using 3dFWHMx in AFNI.
module load prl
module load afni

# Set path to the residual files in the FX directories
fxDir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/pmod/MLmotion_FAST_RT/

# Set path to the mask used in analyses 
mask=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/masks/wave1/groupMask_thresh10_bin.nii

# Estimate acf parameters for each volume of each subject and save as text file
# ------------------------------------------------------------------------------------------
cd $fxDir
for $sub in sub-TAG*; do
	cd $sub
		touch ${sub}_acf.txt
		for res in Res_*; do
			echo $res `3dFWHMx -acf -mask $mask $res` >> ${sub}_acf.txt
		done
	cd ../
done

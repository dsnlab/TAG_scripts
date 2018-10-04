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

module load prl
module load afni

# Set path to the RX directory to save output
rx_path=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/dsd/wave1/pmod/MLmotion_FAST_RT/

# Set path to the mask used in analyses 
mask=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/masks/wave1/groupMask_thresh10_bin.nii

# Run 3dClustSim using the average acf outputs from the script "2_average_incACF.Rmd"
3dClustSim -mask mask.nii -acf 0.6324164 4.917155 10.79975 > ${rx_path}/threshold.txt
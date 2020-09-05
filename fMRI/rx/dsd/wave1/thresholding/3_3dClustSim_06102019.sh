#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dClustSim
#SBATCH --output=output/3dClustSim.log
#SBATCH --error=output/3dClustSim_err.log
#SBATCH --cpus-per-task=25
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=fat,short

module load prl
module load afni

# Set path to the RX directory to save output
rx_path=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/dsd/wave1/pmod/MLmotion_FAST_RT/

# Set path to the mask used in analyses 
mask=/projects/dsnlab/shared/tag/nonbids_data/fMRI/templates/masks/groupStruct_15perc_filled.nii.gz

# Run 3dClustSim using the average acf outputs from the script "2_average_incACF.Rmd"
3dClustSim -LOTS -mask $mask -acf 0.70619 4.5667 11.217 > ${rx_path}/threshold_06102019.txt


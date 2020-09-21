#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dClustSim
#SBATCH --output=../output/3dClustSim2.log
#SBATCH --error=../output/3dClustSim_err2.log
#SBATCH --cpus-per-task=25
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab

module load prl
module load afni

# Set path to the RX directory to save output
rx_path=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/wave1

# Set path to the mask used in analyses 
mask=/projects/dsnlab/shared/SPM12/canonical/MNI152lin_T1_2mm_brain_mask.nii

# Run 3dClustSim using the average acf outputs in ACFparameters_average.txt
3dClustSim -mask $mask -acf 0.62175 4.33115 9.64555 > ${rx_path}/threshold_143pp_valence.txt



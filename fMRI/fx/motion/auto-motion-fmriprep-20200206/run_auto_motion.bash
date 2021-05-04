#!/bin/bash
#
#SBATCH --job-name=auto-motion-fmriprep
#SBATCH --output=auto-motion-fmriprepfd.log
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4G
#SBATCH --account=dsnlab
#SBATCH --partition=ctn

module load R gcc

Rscript --verbose auto_motion_fmriprep_fd.R

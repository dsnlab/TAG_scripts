#!/bin/bash

# This script fits a probabilistic diffusion model to diffusion data that have already been motion-corrected & preprocessed using preproc_diff.sh

# Load FSL
module load fsl/5.0.9
export FSLPARALLEL=slurm

# Set directory names
datadir="/projects/dsnlab/shared/tag/testing"
scriptsdir="/projects/dsnlab/shared/tag/TAG_scripts/dMRI"

# Fitting a probabilistic diffusion model
# Note: This last command takes a couple days to run
echo running "${subid}" bedpostx
fsl_sub.1mod bedpostx "$datadir"/sub-"${subid}"/ses-wave1/dwi

echo "${subid}" preprocessing completed. Next step - tractography.
# Congratulations!  You are now ready to perform tractography.




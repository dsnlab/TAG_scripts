#!/bin/bash

# load fsl
module load fsl

fxDir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/pmod/MLmotion_FAST_RT/
mask=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/masks/wave1/groupMask_thresh10_bin_2mm.nii

# Estimate acf parameters for each subject and save as text file
# ------------------------------------------------------------------------------------------
cd ${fxDir}/${SUBID}

fslmerge -t ../testACF/${SUBID}_res.nii.gz Res_0*nii

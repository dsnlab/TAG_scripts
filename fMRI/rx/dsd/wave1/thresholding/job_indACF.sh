#!/bin/bash

# load afni
module load prl
module load afni

fxDir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/pmod/MLmotion_AR_RT/
mask=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/masks/wave1/groupMask_thresh10_bin_2mm.nii

# Estimate acf parameters for each subject and save as text file
# ------------------------------------------------------------------------------------------
cd ${fxDir}/${SUBID}

touch ${SUBID}_acf.txt

for res in Res_*; do

echo $res `3dFWHMx -acf -mask $mask $res` >> ${SUBID}_acf.txt

done

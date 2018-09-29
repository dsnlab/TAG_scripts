#!/bin/bash

# load afni
module load prl
module load afni

ar1='/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/pmod/MLmotion_AR_RT'
fast='/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/pmod/MLmotion_FAST_RT'

cd $fast 

touch $fast/correlations/${SUBID}.txt

cd ${SUBID}

for con in con_*; do

echo ${SUBID} $con `3ddot -docor $con $ar1/${SUBID}/$con` >> $fast/correlations/${SUBID}.txt

done

for res in Res_*; do

echo ${SUBID} $res `3ddot -docor $res $ar1/${SUBID}/$res` >> $fast/correlations/${SUBID}.txt

done

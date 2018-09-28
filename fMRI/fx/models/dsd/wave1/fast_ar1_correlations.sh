#!/bin/bash

# load afni
module load prl
module load afni

ar1='/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/pmod/MLmotion_AR_RT'
fast='/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/pmod/MLmotion_FAST_RT'

cd $fast 

for sub in sub-TAG*; do
	
	cd $sub

	for con in con*; do

		3ddot -docor $con $ar1/$sub/$con > ${fast}/correlations/${sub}_${con}.txt

	done

	for res in Res_*; do

		3ddot -docor $con $ar1/$sub/$res > ${fast}/correlations/${sub}_${res}.txt

	done

done
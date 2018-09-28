#!/bin/bash

# load afni
module load prl
module load afni

ar1='/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/pmod/MLmotion_AR_RT'
fast='/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/pmod/MLmotion_FAST_RT'

cd $fast 

for sub in sub-TAG*; do
	
	touch correlations/${sub}.txt

	cd $sub

	for con in con*; do

		echo $sub $con `3ddot -docor $con $ar1/$sub/$con` >> correlations/${sub}.txt

	done

	for res in Res_*; do

		echo $sub $res `3ddot -docor $res $ar1/$sub/$res` >> correlations/${sub}.txt

	done

done
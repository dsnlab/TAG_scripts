#!/bin/bash
#--------------------------------------------------------------
# This script:
#	* Merges residuals for each run separately
#	* Calculates ACF parameters for each run separately
#	* Averages ACF parameters and saves in ACFparameters_average.1D
#
# D.Cos 2018.11.06
#--------------------------------------------------------------

# merge residual files
echo -------------------------------------------------------------------------------
echo "${SUB}"
echo "Merging residuals"
echo -------------------------------------------------------------------------------

module load fsl
script_dir=$(pwd)
RUNS=$(ls residuals*.txt | wc -l)
res_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/pmod/MLmotion_FAST_RT/sub-TAG${SUB}
cd ${res_dir}

for i in $(seq 1 $RUNS)
	do echo "merging residuals for run${i}"
	residual_files=`cat ${script_dir}/residuals_run${i}.txt`
	fslmerge -t residuals_run${i} ${residual_files}
	rm ${residual_files}
done

# run 3dFWHMx
echo -------------------------------------------------------------------------------
echo "Calculating ACF parameters"
echo -------------------------------------------------------------------------------

module load afni
for i in $(seq 1 $RUNS)
	do echo "calculating ACF parameters for run${i}"
	3dFWHMx -acf -mask mask.nii residuals_run${i}.nii.gz >> ACFparameters.1D
done

# average ACF parameters
echo -------------------------------------------------------------------------------
echo "Averaging ACF parameters"
echo -------------------------------------------------------------------------------
3dTstat -mean -prefix - ACFparameters.1D'{1..$(2)}'\' >> ACFparameters_average.1D

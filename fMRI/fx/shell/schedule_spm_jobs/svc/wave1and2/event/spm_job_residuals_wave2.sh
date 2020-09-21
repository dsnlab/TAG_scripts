#!/bin/bash
#--------------------------------------------------------------
# This script:
#	* Creates a batch job for $SUB
#	* Batch jobs are saved to the path defined in MATLAB script
#	* Executes batch job
#	* Merges residuals for each run separately
#	* Calculates ACF parameters for each run separately
#	* Averages ACF parameters and saves in ACFparameters_average.1D
#
# D.Cos 2018.11.06
#--------------------------------------------------------------

# set options and load matlab
SINGLECOREMATLAB=true
ADDITIONALOPTIONS=""

if "$SINGLECOREMATLAB"; then
	ADDITIONALOPTIONS="-singleCompThread"
fi

# create and execute job
echo -------------------------------------------------------------------------------
echo "${SUB}"
echo "Running ${SCRIPT}"
echo -------------------------------------------------------------------------------

module load matlab
matlab -nosplash -nodisplay -nodesktop ${ADDITIONALOPTIONS} -r "clear; addpath('$SPM_PATH'); spm_jobman('initcfg'); sub='$SUB'; script_file='$SCRIPT'; replacesid='$REPLACESID'; run('make_sid_matlabbatch.m'); spm_jobman('run',matlabbatch); exit"

# merge residual files
echo -------------------------------------------------------------------------------
echo "Merging residuals"
echo -------------------------------------------------------------------------------

module load fsl
script_dir=$(pwd)
RUNS=$(ls residuals*.txt | wc -l)
res_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1and2/event/sub-TAG${SUB}/wave2
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

#!/bin/bash
#--------------------------------------------------------------
# Inputs:
#	* SUB = defined in subject_list.txt
#	* SCRIPT = MATLAB script to create and execute batch job
#	* Edit SPM path
#
# Outputs:
#	* Creates a batch job for $SUB
#	* Batch jobs are saved to the path defined in MATLAB script
#	* Executes batch job
#
# D.Cos 2017.3.7
#--------------------------------------------------------------

if [[ -z $1 || -z $2 || -z $3 ]]; then
	if [[ -z $REPLACESID || -z $SCRIPT || -z $SUB ]]; then
		echo "Aguments not supplied on command line or in environment"
		exit 1
	fi
else
	# define subject id to replace in script from input 1
	REPLACESID=$1

	# define matlab script to run from input 2
	SCRIPT=$2

	# define subject ID from input 3
	SUB=$3
fi

# MATLAB version
MATLABVER=R2015b
SINGLECOREMATLAB=true
ADDITIONALOPTIONS=""

if "$SINGLECOREMATLAB"; then
	ADDITIONALOPTIONS="-singleCompThread"
fi


if [ "${PROCESS}" == "slurm" ]; then
	module load matlab
	MATLABCOMMAND=matlab
else
	MATLABCOMMAND="/Applications/MATLAB_"${MATLABVER}".app/bin/matlab"
fi

# create and execute job
echo -------------------------------------------------------------------------------
echo "${SUB}"
echo "Running ${SCRIPT}"
echo -------------------------------------------------------------------------------

$MATLABCOMMAND -nosplash -nodisplay -nodesktop ${ADDITIONALOPTIONS} -r "clear; addpath('$SPM_PATH'); spm_jobman('initcfg'); sub='$SUB'; script_file='$SCRIPT'; replacesid='$REPLACESID'; run('make_sid_matlabbatch.m'); spm_jobman('run',matlabbatch); exit"

# merge residual files
echo -------------------------------------------------------------------------------
echo "Merging residuals"
echo -------------------------------------------------------------------------------

module load fsl
script_dir=$(pwd)
RUNS=$(ls residuals*.txt | wc -l)
res_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG${SUB}
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
3dTstat -mean -prefix - ACFparameters.1D'{1..$(2)}'\' >> ACFparameters_average.txt

#!/bin/bash
#--------------------------------------------------------------
# This script:
#	* Creates a batch job for $SUB
#	* Batch jobs are saved to the path defined in MATLAB script
#	* Executes batch job
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
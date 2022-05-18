#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB and matlab $SCRIPT
#	
# T Cheng | 05/2021
#--------------------------------------------------------------

SUBJLIST_FILE=$1
SCRIPT_FILE=$2

# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
SUBJLIST=`cat "$SUBJLIST_FILE"`

# Which SID should be replaced?
REPLACESID=001w03

# SPM Path
SPM_PATH=/projects/dsnlab/shared/SPM12

# Set MATLAB script path
SCRIPT=${STUDY}/fMRI/betaseries/dsd/waves123/"$SCRIPT_FILE"

# Set shell script to execute
SHELL_SCRIPT=spm_job.sh

# FP the results files
RESULTS_INFIX=fx_beta_ft_

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/betaseries/dsd/waves123/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# Set job parameters
cpuspertask=1
mempercpu=16G

# Create and execute batch job
for SUB in $SUBJLIST; do
	 	sbatch --export ALL,REPLACESID=$REPLACESID,SCRIPT=$SCRIPT,SUB=$SUB,SPM_PATH=$SPM_PATH,  \
		 	--job-name=${RESULTS_INFIX} \
		 	-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX}.log \
		 	--cpus-per-task=${cpuspertask} \
		 	--mem-per-cpu=${mempercpu} \
			--partition=ctn \
			--account=dsnlab \
			--time=0-01:00:00 \
		 	${SHELL_SCRIPT}
	 	sleep .25
done

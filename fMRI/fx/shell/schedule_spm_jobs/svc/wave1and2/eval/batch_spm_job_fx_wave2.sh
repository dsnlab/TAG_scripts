#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB and matlab $SCRIPT
#	
# MEAB 2020.09.24
#--------------------------------------------------------------

# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
SUBJLIST=`cat subject_list_errw2.txt`

# Which SID should be replaced?
REPLACESID=001

# SPM Path
SPM_PATH=/projects/dsnlab/shared/SPM12

# Set MATLAB script path
SCRIPT=${STUDY}/fMRI/fx/models/svc/wave1and2/fx_eval_wave2.m

# Set shell script to execute
SHELL_SCRIPT=spm_job.sh

# Tag the results files
RESULTS_INFIX=fx_eval

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/fx/shell/schedule_spm_jobs/svc/wave1and2/eval/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# Set job parameters
cpuspertask=1
mempercpu=8G

# Create and execute batch job
for SUB in $SUBJLIST; do
	 	sbatch --export ALL,REPLACESID=$REPLACESID,SCRIPT=$SCRIPT,SUB=$SUB,SPM_PATH=$SPM_PATH,  \
		 	--job-name=${RESULTS_INFIX} \
		 	-o ${OUTPUTDIR}/${SUB}_2_${RESULTS_INFIX}.log \
		 	--cpus-per-task=${cpuspertask} \
		 	--mem-per-cpu=${mempercpu} \
			--account=dsnlab --partition=ctn \
			--time=0-10:00:00 \
		 	${SHELL_SCRIPT}
	 	sleep .25
done

#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB and matlab $SCRIPT
#	
# D.Cos 2018.11.06
#--------------------------------------------------------------

# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
SUBJLIST=`cat subject_list_test.txt`

# Which SID should be replaced?
REPLACESID=001

# SPM Path
SPM_PATH=/projects/dsnlab/shared/SPM12

# Set MATLAB script path
SCRIPT=${STUDY}/fMRI/fx/models/svc/wave1/fx_event.m

# Set shell script to execute
SHELL_SCRIPT=spm_job.sh

# Tag the results files
RESULTS_INFIX=fx_event

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/fx/shell/schedule_spm_jobs/svc/wave1/event/output

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
		 	-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX}.log \
		 	--cpus-per-task=${cpuspertask} \
		 	--mem-per-cpu=${mempercpu} \
		 	${SHELL_SCRIPT}
	 	sleep .25
done
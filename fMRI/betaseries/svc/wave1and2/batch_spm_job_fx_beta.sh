#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB and matlab $SCRIPT
#	
# Marjolein Oct2020
#--------------------------------------------------------------

# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
#SUBJLIST=`cat subject_list_nums_w1.txt`
#SUBJLIST=`cat subject_list_1run_nums_w1.txt`
#SUBJLIST=`cat subject_list_nums_w2.txt`
SUBJLIST=`cat subject_list_1run_nums_w2.txt`

# Which SID should be replaced?
REPLACESID=001

# SPM Path
SPM_PATH=/projects/dsnlab/shared/SPM12

# Set MATLAB script path
#SCRIPT=${STUDY}/fMRI/betaseries/svc/wave1and2/fx_betaseries_wave1.m
#SCRIPT=${STUDY}/fMRI/betaseries/svc/wave1and2/fx_betaseries_wave2.m
SCRIPT=${STUDY}/fMRI/betaseries/svc/wave1and2/fx_betaseries_1run.m

# Set shell script to execute
SHELL_SCRIPT=spm_job.sh

# FP the results files
#RESULTS_INFIX=fx_beta_1
RESULTS_INFIX=fx_beta_2

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/betaseries/svc/wave1and2/output

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
			--partition=ctn \
			--account=dsnlab \
			--time=0-01:00:00 \
		 	${SHELL_SCRIPT}
	 	sleep .25
done

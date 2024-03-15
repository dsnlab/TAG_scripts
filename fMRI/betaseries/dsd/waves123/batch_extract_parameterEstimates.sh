#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB
#	
# Marjolein Oct 2020 | Adapted T Cheng June 2021
#--------------------------------------------------------------

SUBJLIST_FILENAME=$1
SHELL_SCRIPT=$2

# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
SUBJLIST=`cat ${SUBJLIST_FILENAME}`
#SUBJLIST=`echo "TAG001"`

# Set shell script to execute
#SHELL_SCRIPT=extract_parameterEstimates.sh

# FP the results files
RESULTS_INFIX=extract_pe_ft

# task
task="disc_dec"

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/betaseries/dsd/waves123/output/"${task}"

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# Set job parameters
cpuspertask=1
mempercpu=8G

# Create and execute batch job
for SUB in $SUBJLIST; do
	 	sbatch --export ALL,SUB=$SUB,  \
		 	--job-name=${RESULTS_INFIX} \
		 	-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX}.log \
		 	--cpus-per-task=${cpuspertask} \
		 	--mem-per-cpu=${mempercpu} \
			--account=dsnlab \
			--partition=talapas1-rhel7 \
			--time=0-00:30:00 \
		 	${SHELL_SCRIPT}
	 	sleep .25
done

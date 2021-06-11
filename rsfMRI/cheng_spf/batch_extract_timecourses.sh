#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB
#	
# Marjolein Oct 2020 | Adapted T Cheng June 2021
#--------------------------------------------------------------

SUBJLIST_FILENAME=$1

# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
SUBJLIST=`cat ${SUBJLIST_FILENAME}`
#SUBJLIST=`echo "TAG001"`

# Set shell script to execute
SHELL_SCRIPT=extract_timecourses.sh

# FP the results files
RESULTS_INFIX=extract_tc

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/rsfMRI/cheng_spf/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# Set job parameters
cpuspertask=1
mempercpu=8G

# Create and execute batch job
IFS=,

while read SUB WAVE RUN

do

# Create and execute batch job

	sbatch --export ALL,SUB=$SUB,WAVE=$WAVE,RUN=$RUN  \
		--job-name=${RESULTS_INFIX} \
		-o ${OUTPUTDIR}/${SUB}_run-${RUN}_${RESULTS_INFIX}.log \
		--cpus-per-task=${cpuspertask} \
		--mem-per-cpu=${mempercpu} \
		--account=dsnlab \
		--partition=ctn \
		--time=0-00:45:00 \
		${SHELL_SCRIPT}
	 	sleep .25

done < "${SUBJLIST_FILENAME}"

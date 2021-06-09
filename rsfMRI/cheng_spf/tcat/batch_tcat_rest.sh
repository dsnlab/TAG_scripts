#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB
#	
# Marjolein Oct 2020 | Adapted T Cheng June 2021
#--------------------------------------------------------------

SUBJLIST_FILENAME=$1

SHELL_SCRIPT='tcat_rest.sh'

# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
SUBJLIST=`cat ${SUBJLIST_FILENAME}`
#SUBJLIST=`echo "TAG001"`

# Set shell script to execute
#SHELL_SCRIPT=extract_parameterEstimates.sh

# FP the results files
RESULTS_INFIX=tcat 

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/rsfMRI/cheng_spf/tcat/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# Set job parameters
cpuspertask=1
mempercpu=8G

# Create and execute batch job
IFS=,

while read SUB WAVE FIRST_RUN SECOND_RUN 

do

	 	sbatch --export ALL,SUB=$SUB,WAVE=$WAVE,FIRST_RUN=$FIRST_RUN,SECOND_RUN=$SECOND_RUN  \
		 	--job-name=${RESULTS_INFIX} \
		 	-o ${OUTPUTDIR}/TAG${SUB}_${RESULTS_INFIX}.log \
		 	--cpus-per-task=${cpuspertask} \
		 	--mem-per-cpu=${mempercpu} \
			--account=dsnlab \
			--partition=ctn \
			--time=0-00:30:00 \
		 	${SHELL_SCRIPT}
	 	sleep .25

done < "${SUBJLIST_FILENAME}"

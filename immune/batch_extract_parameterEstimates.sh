#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB
#	
# Marjolein April2019
#--------------------------------------------------------------

# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
SUBJLIST=`cat /projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/wave1_immune/subject_list_immune.txt`
#SUBJLIST=`echo "TAG001"`

# Set shell script to execute
SHELL_SCRIPT=extract_ROIparamEstimates.sh

# FP the results files
RESULTS_INFIX=extract_immune

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/rx/svc/wave1/immune/output

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
		 	${SHELL_SCRIPT} \
			-A dsnlab \
			--partition=short 
	 	sleep .25
done

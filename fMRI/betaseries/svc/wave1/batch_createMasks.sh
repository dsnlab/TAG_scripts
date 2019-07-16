#!/bin/bash
#--------------------------------------------------------------

# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
SUBJLIST=`cat subject_list.txt`
#SUBJLIST=`echo "TAG013"`

# Set shell script to execute
SHELL_SCRIPT=job_createMasks_dPFC_TPJ.sh

# FP the results files
RESULTS_INFIX=masks2

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/betaseries/svc/wave1/output

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
		 	${SHELL_SCRIPT}
	 	sleep .25
done

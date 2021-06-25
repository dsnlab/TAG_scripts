#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB
#	
# D.Cos 2018.11.06
#--------------------------------------------------------------

# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
SUBJLIST=`cat subject_list.txt`
#SUBJLIST=`echo "TAG001"`

# Set shell script to execute
SHELL_SCRIPT=expression_maps.sh

# study the results files
RESULTS_INFIX=expression

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/roi/sca_paper/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# Set job parameters
cpuspertask=1
mempercpu=2G

# Create and execute batch job
for SUB in $SUBJLIST; do
	 	sbatch --export ALL,SUB=$SUB,  \
		 	--job-name=${RESULTS_INFIX} \
		 	-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX}.log \
		 	--cpus-per-task=${cpuspertask} \
		 	--mem-per-cpu=${mempercpu} \
		 	--account=dsnlab \
		 	--partition=ctn,short \
			--time 0-1:00:00 \
		 	${SHELL_SCRIPT}
	 	sleep .25
done

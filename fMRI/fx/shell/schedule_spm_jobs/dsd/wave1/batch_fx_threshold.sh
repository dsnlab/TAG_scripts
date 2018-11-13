#!/bin/bash
#--------------------------------------------------------------
# This script should be used to run FX con jobs and then 
# calculate ACF parameters. It executes spm_job_residuals.sh
# for $SUB and matlab FX $SCRIPT
#	
# D.Cos 2018.11.06
#--------------------------------------------------------------


# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
SUBJLIST=`cat subject_list_test.txt`

# Which SID should be replaced?
REPLACESID='001'

# Set shell script to execute
SHELL_SCRIPT=job_fx_threshold.sh

# Tag the results files
RESULTS_INFIX=fx_threshold

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/fx/shell/schedule_spm_jobs/dsd/wave1/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# N runs for residual calculation
RUNS=(1 2)

# Make text file with residual files for each run
echo $(printf "Res_%04d.nii\n" {1..225}) > residuals_run1.txt
echo $(printf "Res_%04d.nii\n" {226..450}) > residuals_run2.txt

# Set job parameters
cpuspertask=1
mempercpu=8G

# Create and execute batch job
for SUB in $SUBJLIST; do
		sbatch --export ALL,REPLACESID=$REPLACESID,SUB=$SUB  \
			--job-name=${RESULTS_INFIX} \
		 	-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX}.log \
		 	--cpus-per-task=${cpuspertask} \
		 	--mem-per-cpu=${mempercpu} \
		 	${SHELL_SCRIPT}
			sleep .25
done
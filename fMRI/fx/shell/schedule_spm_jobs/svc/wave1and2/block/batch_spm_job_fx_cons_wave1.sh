#!/bin/bash
#--------------------------------------------------------------
# This script should be used to run FX con jobs and then 
# calculate ACF parameters. It executes spm_job_residuals.sh
# for $SUB and matlab FX $SCRIPT
#	
# MEAB 2020.02.11
#--------------------------------------------------------------


# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
SUBJLIST=`cat subject_list_w1.txt`

# Which SID should be replaced?
REPLACESID='001'

# SPM Path
SPM_PATH=/projects/dsnlab/shared/SPM12

# Set MATLAB script path
SCRIPT=${STUDY}/fMRI/fx/models/svc/wave1and2/fx_block_cons_wave1.m

# Set shell script to execute
SHELL_SCRIPT=spm_job_residuals_wave1.sh

# Tag the results files
RESULTS_INFIX=fx_block_cons

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/fx/shell/schedule_spm_jobs/svc/wave1and2/block/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# N runs for residual calculation
RUNS=(1 2)

# Make text file with residual files for each run
echo $(printf "Res_%04d.nii\n" {1..180}) > residuals_run1.txt
echo $(printf "Res_%04d.nii\n" {181..360}) > residuals_run2.txt

# Set job parameters
cpuspertask=1
mempercpu=8G

# Create and execute batch job
for SUB in $SUBJLIST; do
		sbatch --export ALL,REPLACESID=$REPLACESID,SCRIPT=$SCRIPT,SUB=$SUB,SPM_PATH=$SPM_PATH  \
			--job-name=${RESULTS_INFIX} \
		 	-o ${OUTPUTDIR}/${SUB}_wave1_${RESULTS_INFIX}.log \
		 	--cpus-per-task=${cpuspertask} \
		 	--mem-per-cpu=${mempercpu} \
			--account=dsnlab --partition=ctn \
		 	${SHELL_SCRIPT}
			sleep .25
done

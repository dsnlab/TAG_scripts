#!/bin/bash
#--------------------------------------------------------------
# This script should be used to run FX con jobs and then 
# calculate ACF parameters. It executes spm_job_residuals.sh
# for $SUB and matlab FX $SCRIPT
#	
# MEAB 2020.05.11
#--------------------------------------------------------------


# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# Set subject list
SUBJLIST1=`cat subject_list_w1.txt`
SUBJLIST2=`cat subject_list_w2.txt`

# Which SID should be replaced?
REPLACESID='001'

# SPM Path
SPM_PATH=/projects/dsnlab/shared/SPM12

# Set MATLAB script path
SCRIPT1=${STUDY}/fMRI/fx/models/svc/wave1and2/fx_event_cons_alltheways_wave1.m
SCRIPT2=${STUDY}/fMRI/fx/models/svc/wave1and2/fx_event_cons_alltheways_wave2.m

# Set shell script to execute
SHELL_SCRIPT=spm_job.sh

# Tag the results files
RESULTS_INFIX1=fx1_cons_alltheways
RESULTS_INFIX2=fx2_cons_alltheways

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/fx/shell/schedule_spm_jobs/svc/wave1and2/event/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# Set job parameters
cpuspertask=1
mempercpu=8G

# Create and execute batch job
for SUB in $SUBJLIST1; do
		sbatch --export ALL,REPLACESID=$REPLACESID,SCRIPT=$SCRIPT1,SUB=$SUB,SPM_PATH=$SPM_PATH  \
			--job-name=${RESULTS_INFIX1} \
		 	-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX1}.log \
		 	--cpus-per-task=${cpuspertask} \
		 	--mem-per-cpu=${mempercpu} --time=480 \
			--account=dsnlab --partition=ctn \
		 	${SHELL_SCRIPT}
			sleep .25
done

for SUB in $SUBJLIST2; do
		sbatch --export ALL,REPLACESID=$REPLACESID,SCRIPT=$SCRIPT2,SUB=$SUB,SPM_PATH=$SPM_PATH  \
			--job-name=${RESULTS_INFIX2} \
		 	-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX2}.log \
		 	--cpus-per-task=${cpuspertask} \
		 	--mem-per-cpu=${mempercpu} --time=480 \
			--account=dsnlab --partition=ctn \
		 	${SHELL_SCRIPT}
			sleep .25
done
#!/bin/bash
#--------------------------------------------------------------
# This script is to run a 2nd level model (rx) in SPM12
# 
#	MEAB 2019.03.13
#--------------------------------------------------------------

# SPM Path
SPM_PATH=/projects/dsnlab/shared/SPM12
# Data Path 
DATA_PATH=/projects/dsnlab/shared/tag/
# Set MATLAB script path
SCRIPT=/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/clinical_groups/Wave1_SVC_anxiety_healthy_job.m

# Create and execute batch job
	sbatch  --export SCRIPT=$SCRIPT,SPM_PATH=$SPM_PATH,DATA_PATH=$DATA_PATH  \
			--job-name=SVC_anx_healthy \
		 	-o /projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc_clinical_groups/SVC_anx_healthy.log \
		 	--cpus-per-task=1 \
		 	--mem-per-cpu=8G \
		 	/projects/dsnlab/barendse/spm_job_rx.sh
			
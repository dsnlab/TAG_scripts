#!/bin/bash
#SBATCH --time=180
#SBATCH --partition=short
#SBATCH --account=dsnlab

# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# SPM Path
SPM_PATH=/projects/dsnlab/shared/SPM12

# Set MATLAB script path
SCRIPT=${STUDY}/fMRI/rx/svc/wave1_age_puberty/Wave1_SVC_pds_job.m

# PROP the results files
RESULTS_INFIX=rx_pds

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/rx/svc/wave1_age_puberty/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# run script
module load matlab
srun --job-name="${RESULTS_INFIX}" -o "${OUTPUTDIR}"/"${RESULTS_INFIX}".log \
	 matlab -nosplash -nodisplay -nodesktop -r "clear; addpath('$SPM_PATH'); spm_jobman('initcfg'); run('$SCRIPT'); exit"
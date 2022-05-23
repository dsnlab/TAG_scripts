#!/bin/bash
#SBATCH --time 0-0:20
#SBATCH -p short
#SBATCH -A dsnlab

# Set your study
STUDY=/projects/dsnlab/shared/tag/TAG_scripts

# SPM Path
SPM_PATH=/projects/dsnlab/shared/SPM12

# Set MATLAB script path
SCRIPT=${STUDY}/fMRI/rx/svc/wave1_immune/ln/Wave1_SVC_ln_il12_job.m

# PROP the results files
RESULTS_INFIX=rx_ln_il12

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/rx/svc/wave1_immune/ln/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# run script
module load matlab
srun --job-name="${RESULTS_INFIX}" -o "${OUTPUTDIR}"/"${RESULTS_INFIX}".log --partition=short -A dsnlab --time=0-0:20 \
	 matlab -nosplash -nodisplay -nodesktop -r "clear; addpath('$SPM_PATH'); spm_jobman('initcfg'); run('$SCRIPT'); exit"

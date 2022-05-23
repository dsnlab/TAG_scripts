#!/bin/bash
#SBATCH --array=1-2
#SBATCH --job-name=xcp_engine
#SBATCH --mem=8G
#SBATCH --partition=short
#SBATCH --time=0-12:00:00
#SBATCH --output=/projects/dsnlab/shared/tag/TAG_scripts/rsfMRI/xcpengine_tutorial/output/slurm-%A_%a.out
#SBATCH --account=dsnlab

LINE_NUM=$( expr $SLURM_ARRAY_TASK_ID + 1 )
LINE=$(awk "NR==$LINE_NUM" /projects/dsnlab/shared/tag/TAG_scripts/rsfMRI/xcpengine_tutorial/data/func_cohort.csv)
TEMP_COHORT=/projects/dsnlab/shared/tag/TAG_scripts/rsfMRI/xcpengine_tutorial/data/func_cohort.csv.${SLURM_ARRAY_TASK_ID}.csv
echo id0,img > $TEMP_COHORT
echo $LINE >> $TEMP_COHORT

module load singularity

singularity run \
	-B /projects/dsnlab/shared/xcpengine_tutorial:/projects/dsnlab/shared/tag/TAG_scripts/rsfMRI/xcpengine_tutorial/data \
	/projects/dsnlab/shared/containers/xcpEngine.simg \
	-d /projects/dsnlab/shared/tag/TAG_scripts/rsfMRI/xcpengine_tutorial/data/fc-36p_scrub_spf.dsn \
	-c ${TEMP_COHORT} \
	-o /projects/dsnlab/shared/tag/TAG_scripts/rsfMRI/xcpengine_tutorial/data/xcp_output \
	-r /projects/dsnlab/shared/tag/TAG_scripts/rsfMRI/xcpengine_tutorial/data/ \
	-t 2 \


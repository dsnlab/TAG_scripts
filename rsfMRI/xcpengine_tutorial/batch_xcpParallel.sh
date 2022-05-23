#!/bin/bash

# Adjust these so they work on your system
DATA_DIR='/projects/dsnlab/shared/xcpengine_tutorial'
SCRIPT_DIR='/projects/dsnlab/shared/tag/TAG_scripts/rsfMRI/xcpengine_tutorial'
FULL_COHORT=${SCRIPT_DIR}/data/func_cohort.csv
NJOBS=`wc -l < ${FULL_COHORT}`
HEADER="$(head -n 1 $FULL_COHORT)"
SIMG=/projects/dsnlab/shared/containers/xcpEngine.simg
TMPDIR=/tmp

# memory, CPU and time depend on the designfile and your dataset. Adjust values correspondingly
XCP_MEM=8G
XCP_C=1
XCP_TIME=0-12:00:00

if [[ ${NJOBS} == 0 ]]; then
    exit 0
fi

echo ${NJOBS}

cat << EOF > xcpParallel.sh
#!/bin/bash
#SBATCH --array=1-${NJOBS}
#SBATCH --job-name=xcp_engine
#SBATCH --mem=$XCP_MEM
#SBATCH --partition=short
#SBATCH --time=$XCP_TIME
#SBATCH --output=${SCRIPT_DIR}/output/slurm-%A_%a.out
#SBATCH --account=dsnlab

LINE_NUM=\$( expr \$SLURM_ARRAY_TASK_ID + 1 )
LINE=\$(awk "NR==\$LINE_NUM" $FULL_COHORT)
TEMP_COHORT=${FULL_COHORT}.\${SLURM_ARRAY_TASK_ID}.csv
echo $HEADER > \$TEMP_COHORT
echo \$LINE >> \$TEMP_COHORT

module load singularity

singularity run \\
	-B ${DATA_DIR}:${SCRIPT_DIR}/data \\
	$SIMG \\
	-d ${SCRIPT_DIR}/data/fc-36p_scrub_spf.dsn \\
	-c \${TEMP_COHORT} \\
	-o ${SCRIPT_DIR}/data/xcp_output \\
	-r ${SCRIPT_DIR}/data/ \\
	-t 2 \\

EOF

sbatch xcpParallel.sh

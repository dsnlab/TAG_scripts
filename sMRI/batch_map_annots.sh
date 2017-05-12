#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the job_SUMA.sh file for 
# each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your study
STUDY=/projects/dsnlab/tag

# Set subject list
SUBJLIST=`cat subject_list.txt`

# 
for SUBJ in $SUBJLIST
do
sbatch --export SUBID=${SUBJ} --job-name mapANNOTs --partition=defq --mem-per-cpu=8G --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/sMRI/output/"${SUBJ}"_mapANNOTs_output.txt -e "${STUDY}"/TAG_scripts/sMRI/output/"${SUBJ}"_mapANNOTs_error.txt job_map_annots.sh
done


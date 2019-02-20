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
STUDY=/projects/dsnlab/shared/tag

# Set subject list
#SUBJLIST=`cat sub_test.txt`
SUBJLIST=`cat sublist_restw2_n84.txt`
# 
for SUBJ in $SUBJLIST
do
 sbatch --export SUBID=${SUBJ} --job-name SUMAprep_w2 --partition=short,long,fat --mem-per-cpu=2G --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/sMRI/output_w2/"${SUBJ}"_SUMAprep_w2_output.txt -e "${STUDY}"/TAG_scripts/sMRI/output_w2/"${SUBJ}"_SUMAprep_w2_error.txt job_SUMA_w2.sh
done


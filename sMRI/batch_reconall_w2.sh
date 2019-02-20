#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the job_reconall.sh file for 
# each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
#SUBJLIST=`cat subject_list4.txt`
#SUBJLIST=`cat sub_test.txt`
SUBJLIST=`cat sublist_restw2_n84.txt`
# 
for SUBJ in $SUBJLIST
do
 sbatch --export SUBID=${SUBJ} --job-name reconall_w2 --partition=short --mem-per-cpu=8G --time=20:00:00 --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/sMRI/output/"${SUBJ}"_reconall_w2_output.txt -e "${STUDY}"/TAG_scripts/sMRI/output/"${SUBJ}"_reconall_w2_error.txt job_reconall_w2.sh
done

#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt) in the same
# folder and will run job_rsfMRIproc_w2.tcsh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
#SUBJLIST=`cat sublist_restw2_n84.txt`
SUBJLIST=`cat  sub_test.txt`

for SUBJ in $SUBJLIST
 do sbatch --export SUBID=${SUBJ} --job-name rsfMRIproc_w2 --partition=short --mem-per-cpu=8G --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/rsfMRI/output/"${SUBJ}"_rsfMRIproc_w2_output.txt -e "${STUDY}"/TAG_scripts/rsfMRI/output/"${SUBJ}"_rsfMRIproc_w2_error.txt job_rsfMRIproc_w2.tcsh
done



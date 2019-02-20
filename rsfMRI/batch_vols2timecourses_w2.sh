#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt) in the same
# folder and will run job_vols2timecourses_w2.sh
# for each subject in that list.
#

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat sublist_restw2_wo2_and_5.txt`


for SUBJ in $SUBJLIST
 do sbatch --export SUBID=${SUBJ} --job-name vols2timecourses_w2 --partition=short --mem-per-cpu=8G --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/rsfMRI/output/"${SUBJ}"_vols2timecourses_w2output.txt -e "${STUDY}"/TAG_scripts/rsfMRI/output/"${SUBJ}"_vols2timecourses__w2error.txt job_vols2timecourses_w2.sh
done

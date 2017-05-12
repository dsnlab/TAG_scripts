#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt) in the same
# folder and will run job_vols2timecourses.sh
# for each subject in that list.
#

# Set your study
STUDY=/projects/dsnlab/tag

# Set subject list
SUBJLIST=`cat subject_list.txt`
#SUBJLIST=`cat test.txt`


for SUBJ in $SUBJLIST
 do sbatch --export SUBID=${SUBJ} --job-name vols2timecourses --partition=defq --mem-per-cpu=8G --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/rsfMRI/output/"${SUBJ}"_vols2timecourses_output.txt -e "${STUDY}"/TAG_scripts/rsfMRI/output/"${SUBJ}"_vols2timecourses_error.txt job_vols2timecourses.sh
done

#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt) in the same
# folder and will run job_vols2timecourses.sh
# for each subject in that list.
#

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat sub224.txt`

for SUBJ in $SUBJLIST
 do sbatch --export SUBID=${SUBJ} --job-name mentalizing --partition=short,fat --account=dsnlab --mem-per-cpu=8G --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/rsfMRI/output/"${SUBJ}"_mentalizing_output.txt -e "${STUDY}"/TAG_scripts/rsfMRI/output/"${SUBJ}"_mentalizing_error.txt job_map_mentalizing.sh
done

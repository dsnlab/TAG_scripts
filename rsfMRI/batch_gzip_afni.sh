#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt) in the same
# folder and will run job_gzip_afni.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat sub_test.txt`

for SUBJ in $SUBJLIST
 do sbatch --export SUBID=${SUBJ} --job-name gzipit --partition=short --mem-per-cpu=3G --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/rsfMRI/output/"${SUBJ}"_gzipit_output.txt -e "${STUDY}"/TAG_scripts/rsfMRI/output/"${SUBJ}"_gzipit_error.txt job_gzip_afni.sh
done


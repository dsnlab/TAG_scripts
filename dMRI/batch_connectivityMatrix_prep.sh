#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_sam.txt) in the same
# folder and will run bedpostx_diff.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list.txt`

for SUBID in $SUBJLIST
do
sbatch --export SUBJ=${SUBID} --job-name=matrixPrep --partition=short --time=03:00:00 --nodes=1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_matrixPrep_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_matrixPrep_error.txt job_connectivityMatrix_prep.sh
done

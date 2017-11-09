#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt) in the 
# script directory. And runs the specified job 
# file for each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_prac.txt`

# Set output directory
OUTPUTDIR=TAG_scripts/org/output

# Set job script
JOB=TAG_scripts/org/bids-conversion/convert_bids_test.sh

for SUBJ in ${SUBJLIST[@]}
do
 sbatch --export subid=${SUBJ} --job-name dicomconvert_"${SUBJ}" --partition=short --time 00:60:00 --mem-per-cpu=2G --cpus-per-task=1 -o "${STUDY}"/"${OUTPUTDIR}"/"${SUBJ}"_dicomconvert_output.txt -e "${STUDY}"/"${OUTPUTDIR}"/"${SUBJ}"_dicomconvert_error.txt "${STUDY}"/"${JOB}"
done

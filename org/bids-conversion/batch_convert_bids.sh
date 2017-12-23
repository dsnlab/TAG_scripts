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
OUTPUTDIR=TAG_scripts/org/bids-conversion/output

# Set job script
JOB=TAG_scripts/org/bids-conversion/convert_bids.sh

for SUBJ in ${SUBJLIST[@]}

do

SUBID=`echo $SUBJ|awk '{print $1}' FS=","`
SESSID=`echo $SUBJ|awk '{print $2}' FS=","`

sbatch --export subid=${SUBID},sessid=${SESSID} --job-name convertBIDS_"${SUBJ}" --partition=short --time 00:60:00 --mem-per-cpu=2G --cpus-per-task=1 -o "${STUDY}"/"${OUTPUTDIR}"/"${SUBJ}"_convertBIDS_output.txt -e "${STUDY}"/"${OUTPUTDIR}"/"${SUBJ}"_convertBIDS_error.txt "${STUDY}"/"${JOB}"

done

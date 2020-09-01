#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_sam.txt) in the same
# folder and will run preproc_diff.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_sam.txt`
#SUBJLIST=`cat alignment.txt`

for SUBID in $SUBJLIST
# do sbatch --export subid=${SUBID} --job-name diffpreproc --mem-per-cpu=4G --nodes=1 --cpus-per-task=4 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_diffpreproc_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_diffpreproc_error.txt preproc_diff.sh
do sbatch --export subid=${SUBID} --job-name=diffpreproc --partition=gpu --time=5:00:00 --nodes=1 --ntasks-per-node=1 --gres=gpu:1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_diffpreproc_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_diffpreproc_error.txt preproc_diff.sh
done


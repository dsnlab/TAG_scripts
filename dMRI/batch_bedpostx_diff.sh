#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_sam.txt) in the same
# folder and will run bedpostx_diff.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_sam.txt`
#SUBJLIST=`cat alignment.txt`

for SUBID in $SUBJLIST
 do sbatch --export subid=${SUBID} --job-name=bedpostx --partition=long --time=03-08:00:00 --nodes=1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_bedpostx_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_bedpostx_error.txt bedpostx_diff.sh
done


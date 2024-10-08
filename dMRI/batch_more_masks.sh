#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_full_sam.txt) in the same
# folder and will run svc_seeds.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_full_sam.txt`

for SUBID in $SUBJLIST
 do sbatch --export subid=${SUBID} --job-name more_masks --time=5 --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_moremasks_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_moremasks_error.txt more_masks.sh
done

#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_full_sam.txt) in the same
# folder and will run preproc_diff.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_full_sam.txt`
#SUBJLIST=`cat alignment.txt`

for SUBID in $SUBJLIST
 do sbatch --export subid=${SUBID} --job-name subcortmasks --time=10 --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_subcortmasks_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_subcortmasks_error.txt subcort_masks.sh
done


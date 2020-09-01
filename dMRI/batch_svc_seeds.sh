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
 do sbatch --export subid=${SUBID} --job-name svc_masks --time=15 --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_svcmasks_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_svcmasks_error.txt svc_seeds.sh
done


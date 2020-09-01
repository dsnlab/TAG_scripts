#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_full_sam.txt) in the same
# folder and will run subcort_seeds.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_full_sam.txt`
#SUBJLIST=`cat alignment.txt`

for SUBID in $SUBJLIST
 do sbatch --export subid=${SUBID} --job-name fslfirst --time=60 --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_fslfirst_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_fslfirst_error.txt subcort_seeds.sh
done


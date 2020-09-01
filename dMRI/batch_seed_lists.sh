#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_full_sam.txt) in the same
# folder and will run svc_seeds.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_001_to_010.txt`

for SUBID in $SUBJLIST
 do sbatch --export subid=${SUBID} --job-name svc_seed_lists --partition=gpu --time=3 --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_svcseedlists_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_svcseedlists_error.txt seed_lists.sh
done


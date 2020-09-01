#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_full_sam.txt) in the same
# folder and will run svc_thal_tractography.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_full_sam.txt`

for SUBID in $SUBJLIST
do
sbatch --export subid=${SUBID} --job-name=SVCthalprobtrackX --partition=gpu --time=4:00:00 --nodes=1 --ntasks-per-node=1 --gres=gpu:1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_SVCthalprobtrackX_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_SVCthalprobtrackX_error.txt svc_thal_tractography.sh
done

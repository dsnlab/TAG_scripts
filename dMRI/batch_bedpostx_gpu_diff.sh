#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_sam.txt) in the same
# folder and will run bedpostx_gpu_diff.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list.txt`
#SUBJLIST=`cat alignment.txt`

for SUBID in $SUBJLIST
 do sbatch --export subid=${SUBID} --job-name=bedpostx_gpu --partition=gpu --time=00:30:00 --nodes=1 --gres=gpu:1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_bedpostx_gpu_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_bedpostx_gpu_error.txt bedpostx_gpu_diff.sh
done


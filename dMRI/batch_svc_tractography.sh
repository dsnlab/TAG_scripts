#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_full_sam.txt) in the same
# folder and will run svc_seeds_tractography.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_sam.txt`

# Set seeds list
#SEEDLIST=`cat svc_tractography_seeds.txt`

for SUBID in $SUBJLIST
do
#sbatch --export SUBJ=${SUBID} --job-name="SVCprobtrackX" --partition=short --time=00:08:00 --nodes=1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_SVCprobtrackX_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_SVCprobtrackX_error.txt svc_seeds_tractography.sh

sbatch --export subid=${SUBID} --job-name=SVCprobtrackX --partition=gpu --time=6:00:00 --nodes=1 --ntasks-per-node=1 --gres=gpu:1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_SVCprobtrackX_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_SVCprobtrackX_error.txt svc_seeds_tractography.sh
done

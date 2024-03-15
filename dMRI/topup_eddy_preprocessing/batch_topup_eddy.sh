#!/bin/bash
#
# This batch file calls on your subject
# list (NAME) in the same directory
# and will run topup_eddy.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list.txt`
WAVE='wave3'


for SUBJ in $SUBJLIST
do sbatch --export=ALL,subj=${SUBJ},wave=${WAVE} --job-name=topup_eddy --partition=gpu --time=6:00:00 --nodes=1 --ntasks-per-node=1 --gres=gpu:1 --account=dsnlab -o "${STUDY}"/TAG_scripts/dMRI/topup_eddy_preprocessing/output/"${SUBJ}"_${WAVE}_topup_eddy_output.txt -e "${STUDY}"/TAG_scripts/dMRI/topup_eddy_preprocessing/output/"${SUBJ}"_${WAVE}_topup_eddy_error.txt topup_eddy.sh
done

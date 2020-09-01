#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_sam.txt) in the same
# folder and will run bedpostx_diff.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_full_sam.txt`

# Set seeds list
SEEDLIST=`cat connect_seeds_gmwm.txt`

for SUBID in $SUBJLIST
do
for SEEDMASK in $SEEDLIST
do
sbatch --export SUBJ=${SUBID} --export SEED=${SEEDMASK} --job-name="probtrackXmat1" --partition=short --time=00:05:00 --nodes=1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_"${SEEDMASK}"_probtrackXmat1_otargetpaths_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_"${SEEDMASK}"_probtrackXmat1_otargetpaths_error.txt job_network_connect.sh
done
done


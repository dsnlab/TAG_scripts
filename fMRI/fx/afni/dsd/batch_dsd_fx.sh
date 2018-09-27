#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt) in the same
# folder and will run job_dsd_fx.tcsh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat test_list.txt`

for SUBJ in $SUBJLIST
do
SUBID=`echo $SUBJ|awk '{print $1}' FS=","`
MODEL=`echo $SUBJ|awk '{print $2}' FS=","`
sbatch --export SUBID=${SUBID},MODEL=${MODEL} --job-name dsd_fx --partition=short --mem-per-cpu=50G --cpus-per-task=1 -o "${STUDY}"/TAG_scripts/fMRI/fx/afni/dsd/output/"${SUBJ}"_dsd_fx_pmod_output.txt -e "${STUDY}"/TAG_scripts/fMRI/fx/afni/dsd/output/"${SUBJ}"_dsd_fx_pmod_error.txt job_dsd_fx_pmod.tcsh
done
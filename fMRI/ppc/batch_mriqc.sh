#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the job_fmriprep.sh file for 
# each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your directories

group_dir=/projects/dsnlab/shared/
container=BIDS/SingularityContainers/poldracklab_mriqc_latest-2017-10-19-8992ca9444b6.img
study="tag"

# Set subject list
SUBJLIST=`cat subject_list.txt`

# 
for SUBJ in $SUBJLIST; do

SUBID=`echo $SUBJ|awk '{print $1}' FS=","`
SESSID=`echo $SUBJ|awk '{print $2}' FS=","`
	
sbatch --export subid=${SUBID},sessid=${SESSID},group_dir=${group_dir},study=${study},container=${container} --job-name mriqc --partition=long -n16 --mem=75G --time=20:00:00 -o "${group_dir}"/"${study}"/TAG_scripts/fMRI/ppc/output/"${SUBID}"_"${SESSID}"_mriqc_output.txt -e "${group_dir}"/"${study}"/TAG_scripts/fMRI/ppc/output/"${SUBID}"_"${SESSID}"_mriqc_error.txt job_mriqc.sh
	
done

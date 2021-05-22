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
container=BIDS/SingularityContainers/fmriprep-20.2.1.simg
study="tag"

# Set subject list
SUBJLIST=`cat subject_list_test.txt`

# 
for SUBJ in $SUBJLIST; do

subid=`echo $SUBJ|awk '{print $1}' FS=","`
sessid=`echo $SUBJ|awk '{print $2}' FS=","` 
	
sbatch --export subid=${subid},sessid=${sessid},group_dir=${group_dir},study=${study},container=${container} \
--job-name ${subid}fmriprep_w3 --account=dsnlab --partition=ctn --time=0-23:50:00 --mem=25G --cpus-per-task=8 \
-o "${group_dir}"/"${study}"/TAG_scripts/fMRI/ppc/output/"${SUBJ}"_fmriprep_v20.2.1_w3_output.txt \
-e "${group_dir}"/"${study}"/TAG_scripts/fMRI/ppc/output/"${SUBJ}"_fmriprep_v20.2.1_w3_error.txt \
job_fmriprep_w3.sh
	
done

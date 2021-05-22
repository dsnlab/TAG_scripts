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
#SUBJLIST=`cat subject_list_wfmap_w2.txt`
SUBJLIST=`cat subject_list_fmapless_w2.txt`
#SUBJLIST=`cat subject_list_56.txt`

# 
for SUBJ in $SUBJLIST; do

subid=`echo $SUBJ|awk '{print $1}' FS=","`
sessid=`echo $SUBJ|awk '{print $2}' FS=","` 
	
sbatch --export subid=${subid},sessid=${sessid},group_dir=${group_dir},study=${study},container=${container} \
--job-name ${subid}fmriprepW2 --account=dsnlab --partition=ctn --time=0-23:00:00 --mem=25G --cpus-per-task=8 \
-o "${group_dir}"/"${study}"/TAG_scripts/fMRI/ppc/output/"${SUBJ}"_fmriprep_w2_output.txt \
-e "${group_dir}"/"${study}"/TAG_scripts/fMRI/ppc/output/"${SUBJ}"_fmriprep_w2_error.txt \
job_fmriprep_w2_fmapless.sh
	
done

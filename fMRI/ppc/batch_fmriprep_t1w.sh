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

group_dir=/projects/dsnlab/barendse/
#container=BIDS/SingularityContainers/poldracklab_fmriprep_latest-2017-07-20-dd77d76c5e14.img
container=BIDS/SingularityContainers/poldracklab_fmriprep_latest-2017-12-07-ba92e815fc4e.img
study="tag"

# Set subject list
#SUBJLIST=`cat subject_list_err.txt`
SUBJLIST="TAG218,wave1 TAG253,wave1"
# 
for SUBJ in $SUBJLIST; do

SUBID=`echo $SUBJ|awk '{print $1}' FS=","`
SESSID=`echo $SUBJ|awk '{print $2}' FS=","`
	
sbatch --export subid=${SUBID},group_dir=${group_dir},study=${study},container=${container} \
		--job-name fmriprep --partition=short --time=0-20:00:00 --mem=100G \
		-o /projects/dsnlab/shared/"${study}"/TAG_scripts/fMRI/ppc/output/"${SUBJ}"_fmriprep_t1w_output.txt \
		-e /projects/dsnlab/shared/"${study}"/TAG_scripts/fMRI/ppc/output/"${SUBJ}"_fmriprep_t1w_error.txt \
		job_fmriprep_t1w.sh
		
done

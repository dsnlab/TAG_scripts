#!/bin/bash
#
# This batch file takes subject list filename (subject_list, sans the .txt extension) as an argument. 
# It looks for both subject_list.txt (sub_id,wave) and subject_list_fmapless.txt (just sub_id).
# If a participant is in the fmapless list, it runs the job_fmriprep_20.2.1_fmapless.sh file.
# Otherwise, it runs job_fmriprep_20.2.1.sh for each subject. 
# It saves the ouput and error files in their specified directories.

SUBJLIST_FILENAME=$1

# Set your directories

group_dir=/projects/dsnlab/shared/
container=BIDS/SingularityContainers/fmriprep-20.2.1.simg
study="tag"

# Set subject list
SUBJLIST=`cat "$SUBJLIST_FILENAME".txt`

# 
for SUBJ in $SUBJLIST; do

subid=`echo $SUBJ|awk '{print $1}' FS=","`
sessid=`echo $SUBJ|awk '{print $2}' FS=","` 

if [[ "$subid" =~ $(echo ^\($(paste -sd'|' "$SUBJLIST_FILENAME"_fmapless.txt)\)$) ]]; then
	echo "run $subid fmapless" 

	sbatch --export subid=${subid},sessid=${sessid},group_dir=${group_dir},study=${study},container=${container} \
--job-name ${subid}fmriprep_20.2.1 --account=dsnlab --partition=ctn --time=0-23:50:00 --mem=25G --cpus-per-task=8 \
-o "${group_dir}"/"${study}"/TAG_scripts/fMRI/ppc/output/"${SUBJ}"_fmriprep_v20.2.1_fmapless_output.txt \
-e "${group_dir}"/"${study}"/TAG_scripts/fMRI/ppc/output/"${SUBJ}"_fmriprep_v20.2.1_fmapless_error.txt \
job_fmriprep_20.2.1_fmapless.sh

else 
	echo "run $subid with fieldmap"  

	sbatch --export subid=${subid},sessid=${sessid},group_dir=${group_dir},study=${study},container=${container} \
--job-name ${subid}fmriprep_20.2.1 --account=dsnlab --partition=ctn --time=0-23:50:00 --mem=25G --cpus-per-task=8 \
-o "${group_dir}"/"${study}"/TAG_scripts/fMRI/ppc/output/"${SUBJ}"_fmriprep_v20.2.1_output.txt \
-e "${group_dir}"/"${study}"/TAG_scripts/fMRI/ppc/output/"${SUBJ}"_fmriprep_v20.2.1_error.txt \
job_fmriprep_20.2.1.sh

fi 

done

#!/bin/bash
#

#SBATCH --account=dsnlab   
#SBATCH --partition=long       ### queue to submit to
#SBATCH --job-name=batch_job_MEAB_VGW    ### job name
#SBATCH --output=output/wave3/batch_w3_output.out   ### file in which to store job stdout
#SBATCH --error=output/wave3/error_w3.err    ### file in which to store job stderr
#SBATCH --time=5                ### wall-clock time limit, in minutes
#SBATCH --mem=100M              ### memory limit per node, in MB
#SBATCH --nodes=1               ### number of nodes to use
#SBATCH --ntasks-per-node=1     ### number of tasks to launch per node
#SBATCH --cpus-per-task=1       ### number of cores for each task


# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the job_fmriprep.sh file for 
# each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your directories

group_dir=/projects/dsnlab/shared/
container=BIDS/SingularityContainers/fmriprep-21.0.2.simg
study="tag"

# Set subject list
SUBJLIST=`cat subject_list_fmap_w3.txt`

# 
for SUBJ in $SUBJLIST; do

#subid=`echo $SUBJ|awk '{print $1}' FS=","`
#sessid=`echo $SUBJ|awk '{print $2}' FS=","` 
	
sbatch --export SUBJ=${SUBJ},group_dir=${group_dir},study=${study},container=${container} \
--job-name ${SUBJ}fmriprep --account=dsnlab --partition=long,longfat --time=4-23:00:00 --mem=64G --cpus-per-task=8 \
-o "${group_dir}"/"${study}"/TAG_scripts/fMRI/ppc/output/fmriprep21.0.2/"${SUBJ}"_output.txt \
-e "${group_dir}"/"${study}"/TAG_scripts/fMRI/ppc/output/fmriprep21.0.2/"${SUBJ}"_error.txt \
job_fmriprep21.0.2_VGW_MEAB.sh
	
done

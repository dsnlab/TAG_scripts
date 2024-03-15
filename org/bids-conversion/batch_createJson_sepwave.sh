#!/bin/bash

#SBATCH --account=dsnlab   
#SBATCH --partition=ctn       ### queue to submit to
#SBATCH --job-name=batch_jsons    ### job name
#SBATCH --output=output/sepwave/batch_3w_output.out   ### file in which to store job stdout
#SBATCH --error=output/sepwave/error_3w.err    ### file in which to store job stderr
#SBATCH --time=5                ### wall-clock time limit, in minutes
#SBATCH --mem=100M              ### memory limit per node, in MB
#SBATCH --nodes=1               ### number of nodes to use
#SBATCH --ntasks-per-node=1     ### number of tasks to launch per node
#SBATCH --cpus-per-task=1       ### number of cores for each task

#
# This batch file calls on your subject
# list in the # script directory. And runs the specified job 
# file for each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_3w_jsons_vgw.txt`
 
# Set output directory
OUTPUTDIR=TAG_scripts/org/bids-conversion/output/sepwave

# Set job script
JOB=TAG_scripts/org/bids-conversion/createJson_3w.sh

for SUBJ in ${SUBJLIST[@]}

do

SUBID=`echo $SUBJ|awk '{print $1}' FS=","`
SESSID=`echo $SUBJ|awk '{print $2}' FS=","`
SHORTID=`echo $SUBJ|awk '{print $3}' FS=","`

sbatch --export subid=${SUBID},sessid=${SESSID},shortid=${SHORTID} --job-name createJson_"${SUBJ}" --mem-per-cpu=2G --cpus-per-task=1 --partition=ctn --account=dsnlab --time 00:10:00 -o "${STUDY}"/"${OUTPUTDIR}"/"${SUBID}"_"${SESSID}"_createJson_output.txt -e "${STUDY}"/"${OUTPUTDIR}"/"${SUBID}"_"${SESSID}"_createJson_error.txt "${STUDY}"/"${JOB}"

done

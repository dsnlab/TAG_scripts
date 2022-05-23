#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt) in the 
# script directory. And runs the specified job 
# file for each subject. It saves the ouput
# and error files in their specified
# directories.
#
#VGW ran this code from her own folder; 
#if you are trying to run this on the DSN lab shared folder,
#you will likely need to adjust the paths to pull the correct data

# Set your study


BASEDIR='gpfs/projects/dsnlab/vgw/preprocessing_vic_marjolein/bids-conversion/'
DATADIR="$BASEDIR"'/data'

# Set subject list
SUBJLIST=tagdata2 #Change name to subject_list_w3.txt if running from DSN lab shared folder!

# Set output directory
OUTPUTDIR=/output/convert_w3

# Set job script
JOB=/convert_bids.sh

while read SUBJ
do
SUBID=`echo $SUBJ|awk '{print $1}' FS=","`
DIRNUM=`echo $SUBJ|awk '{print $2}' FS=","`
SESSID='wave3'

sbatch --export subid=${SUBID},sessid=$SESSID,dirnum=${DIRNUM} --job-name convertBIDS_"${SUBJ}" --account=dsnlab --partition=ctn --time 00:60:00 --mem-per-cpu=2G --cpus-per-task=1 -o "${DATADIR}"/"${OUTPUTDIR}"/"${SUBID}"_"${SESSID}"_convertBIDS_output.txt -e "${DATADIR}"/"${OUTPUTDIR}"/"${SUBID}"_"${SESSID}"_convertBIDS_error.txt "${BASEDIR}"/"${JOB}"
done < "${BASEDIR}/${SUBJLIST}"

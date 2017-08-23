# This script allows for the removal of unnecessary files within directories recursively from HPC.
#
# By Nandi Vijayakumar 7/24/2017
###########################################
# Set directory
SOURCE_DIR=/projects/dsnlab/tag/bids_data

# Set lists
SUBJECT_LIST=`cat subject_list.txt`
#TASK_LIST="SVC DSD"

# Remove files from HPC
for SUB in $SUBJECT_LIST
do
	echo "Removing files for $SUB"
#	for TASK in $TASK_LIST
#	do
#		echo "Removing files from $TASK"
		rm $SOURCE_DIR/sub-$SUB/ses-wave1/fmap/*
#	done
	echo "Files removed for $SUB"
	echo "----------------------"
done

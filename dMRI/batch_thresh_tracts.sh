#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_sam.txt) in the same
# folder and will run thresh_tracts.sh
# for each subject in that list.

# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_full_sam.txt`

# Set seeds list
TRACTLIST=`cat svc_tracts.txt`

# Beginning of subject loop
for SUBID in $SUBJLIST
do for TRACT in $TRACTLIST
	do

sbatch --export subid=${SUBID},tract=${TRACT} --job-name="thresh_tract" --partition=gpu --time=00:02:00 --nodes=1 -o "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_"${TRACT}"_threshtract_output.txt -e "${STUDY}"/TAG_scripts/dMRI/output/"${SUBID}"_"${TRACT}"_threshtract_error.txt threshold_tracts.sh

	done
done


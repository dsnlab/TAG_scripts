#!/bin/bash

# This script creates a subject list for the topup_eddy preprocessing pipeline
# It copies the output of bids_data to a .txt file, then extracts
# each unique TAG ID  to subject_list.txt.  

OUTPUTDIR=/projects/dsnlab/shared/tag/TAG_scripts/dMRI/topup_eddy_preprocessing

# move to bids_data
cd /projects/dsnlab/shared/tag/bids_data
# copy directopy list of bids data to everything.txt
ls > ${OUTPUTDIR}/everything.txt
# move back to OUTPUTDIR
cd ${OUTPUTDIR}
# extract TAG IDs, write .txt file
grep  -o "TAG...$" everything.txt > ${OUTPUTDIR}/subject_list.txt
rm everything.txt


#!/bin/bash

# This script backs up the fmriprep and xcp output folders from Talapas to CAS
# T Cheng | 6/5/2021

# Create log file with today's date:
log_name=$(date +%Y-%m-%d-%H-%M-%S)_rsync_fmriprep_20.2.1.log
touch $log_name

## COPY TALAPAS DSNLAB ARCHIVE TO CAS
rsync -aiv --log-file=$log_name --exclude".html" -e ssh jpfeifer@talapas-ln1.uoregon.edu:/projects/dsnlab/shared/tag/fmriprep_20.2.1/fmriprep/* /Volumes/psych-cog/dsnlab/TAG/bids_data/derivatives/fmriprep_20.2.1/fmriprep # fmriprep processed output files from bids_data_sep_wave

# rsync -aiv -e ssh jpfeifer@talapas-ln1.uoregon.edu:/projects/dsnlab/shared/tag/fmriprep_20.2.1/xcp_output/* /Volumes/psych-cog/dsnlab/TAG/bids_data/derivatives/fmriprep_20.2.1/xcp_output # outputs from xcp engine 

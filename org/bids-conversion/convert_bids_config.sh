#!/bin/bash

# This script is the configuration file for convert_bids_template.sh
# It should be in the same directory as convert_bids_template.sh
# 
# Sequence variables are based on the sequence protocol names

# Set directory names
archivedir="/projects/dsnlab/shared/tag/archive"
dicomdir=$(echo "/projects/dsnlab/shared/tag/archive/DICOMS/${subid}"*)
niidir="/projects/dsnlab/shared/tag/archive/clean_nii"
bidsdir="/projects/dsnlab/shared/tag/bids_data"

# Set study info
sessid="wave1"
cpflags="-n -v"
fieldmapEPI="FALSE"
declare -a anat="mprage_p2"
declare -a fmap="fieldmap_2mm"
declare -a dti="diff"
declare -a resting=("Resting_1" "Resting_2")
declare -a tasks=("SVC_1" "SVC_2" "DSD_1" "DSD_2")

# Set which sequences to convert
convertanat="FALSE"
convertfmap="FALSE"
convertdti="FALSE"
convertrest="TRUE"
converttask="FALSE"

# Set error log file
errorlog="/projects/dsnlab/shared/tag/TAG_scripts/org/bids-conversion/errorlog.txt"

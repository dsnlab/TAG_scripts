#!/bin/bash

# This script is the configuration file for createJson.sh
# It should be in the same directory as createJson.sh
# 
# Sequence variables are based on the sequence protocol names

# Set directory names
niidir="/projects/dsnlab/shared/tag/archive/clean_nii"
bidsdir="/projects/dsnlab/shared/tag/bids_data"

# Set study info
declare -a anat="mprage_p2"
declare -a fmap="fieldmap_2mm"
declare -a dti="diff"
declare -a resting=("Resting_1" "Resting_2")
#declare -a tasks=("SVC_1" "SVC_2" "DSD_1" "DSD_2")
tasks=("SVC_1" "SVC_2" "DSD_1" "DSD_2")

#Set phase encoding direction for fmap and task
#1a = A-P
#1b = P-A
#2a = I-S 
#2b = S-I
#3a = R-L 
#3b = L-R

PhaseEncoding_task=1a

# Set which sequences to create Json
convertanat="TRUE"
convertfmap="TRUE"
convertdti="FALSE"
convertrest="TRUE"
converttask="TRUE"

# Set log files of new Json files and errors
newlog="/projects/dsnlab/shared/tag/TAG_scripts/org/bids-conversion/new_Json.txt" #lists subject-specific functional and anatomical json files that are created.
errorlog="/projects/dsnlab/shared/tag/TAG_scripts/org/bids-conversion/errorlog_Json.txt" #lists when subjects were not checked by scan (i.e., missing files or wrong number of files)

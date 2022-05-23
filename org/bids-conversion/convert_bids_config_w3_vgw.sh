#!/bin/bash

# This script is the configuration file for convert_bids_template.sh
# It should be in the same directory as convert_bids_template.sh
# 
# Sequence variables are based on the sequence protocol names

#VGW ran this code from her own directory; 
#if you are trying to run this on the DSN lab shared folder/directory,
#you will likely need to adjust the paths to pull the correct data

# DATA TO:
archivedir='archive'
niidir='archive/clean_nii'
bidsdir='bids_data'

# Set study info
cpflags='-n -v'
fieldmapEPI='FALSE'
declare -a anat='mprage_p2'
declare -a fmap='fieldmap_2mm'
declare -a dti='diff'
declare -a resting=('Resting_1' 'Resting_2')
declare -a tasks=('SVC_1' 'SVC_2' 'DSD_1' 'DSD_2') #Make sure that DSD is specified as a task here

# Set which sequences to convert
convertanat='TRUE'
convertfmap='TRUE'
convertdti='TRUE'
convertrest='TRUE'
converttask='TRUE'

# Set error log file
errorlog='errorlog/errorlog_convertBIDS.txt'

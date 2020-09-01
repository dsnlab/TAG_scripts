#!/bin/bash

# Load FSL
module load fsl/5.0.9
module load freesurfer/6.0.0

# Set directory names
datadir="/projects/dsnlab/shared/tag/bids_data"
freesurferdir="/projects/dsnlab/shared/tag/bids_data/derivatives/freesurfer/"
scriptsdir="/projects/dsnlab/shared/tag/TAG_scripts/dMRI"
outputdir="/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc"

# Set error log file
errorlog=""$scriptsdir"/errorlog_fslfirst.txt"

# Create error log file
touch "${errorlog}"

if [ -f $("$outputdir"/"${subid}"/ses-wave1/anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz) ]; then

cd "$outputdir"/"${subid}"/ses-wave1/anat/reg

# struct<->freesurfer registration
tkregister2 --mov "$freesurferdir"/sub-"${subid}"/mri/orig.mgz --targ "$freesurferdir"/sub-"${subid}"/mri/rawavg.mgz --regheader --reg junk --fslregout freesurfer2struct.mat --noedit

convert_xfm -omat struct2freesurfer.mat -inverse freesurfer2struct.mat

# concatenate transformations
convert_xfm -omat fa2freesurfer.mat -concat struct2freesurfer.mat fa2struct.mat
convert_xfm -omat freesurfer2fa.mat -inverse fa2freesurfer.mat



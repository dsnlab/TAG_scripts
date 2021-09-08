#!/bin/bash

# Arguments:
roi_list_name=$1 # list of roi names that point to .nii files
min_thresh=$2 

# Outputs:
# binarized ROIs in .nii format

roi_list=$(cat $roi_list_name)

for roi in $roi_list
do
    echo "${roi}"
    mri_binarize --i /projects/dsnlab/shared/tag/fmriprep_20.2.1/rois/VmPFC_symmetric_20141024/${roi}.nii --o /projects/dsnlab/shared/tag/fmriprep_20.2.1/rois/VmPFC_symmetric_20141024/${roi}_bi.nii --min $min_thresh

done

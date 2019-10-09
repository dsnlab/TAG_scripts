#!/bin/bash

# freesurfer parcellations
# NAcc: 26 / 58
# Putamen: 12 / 51

# HCP parcellations
# pgACC	61	L_a24_ROI
# sgACC	164	L_25_ROI
# sgACC	165	L_s32_ROI
# vmPFC	64	L_p32_ROI
# vmPFC	65	L_10r_ROI
# mOFC	88	L_10v_ROI

## define paths
fromannotsDir=/projects/dsnlab/shared/tag/bids_data/derivatives/freesurferW1/sub-$SUB/mri/fromannots/

## load FSL
module load fsl

# cd into directory with the default mask files
cd ${fromannotsDir}

echo -e "\nFromAnnots folder is in $fromannotsDir"

echo -------------------------------------------------------------------------------
echo "$SUB"
echo -------------------------------------------------------------------------------


## create masks
echo "Creating masks"

# echo "pg/sgACC mask"
fslmaths lh.L_a24_ROI.nii.gz -add rh.R_a24_ROI.nii.gz -add lh.L_25_ROI.nii.gz -add rh.R_25_ROI.nii.gz -add lh.L_s32_ROI.nii.gz -add rh.R_s32_ROI.nii.gz pgACC.nii.gz

# echo "vmPFC mask"
fslmaths lh.L_p32_ROI.nii.gz -add rh.R_p32_ROI.nii.gz -add lh.L_10r_ROI.nii.gz -add rh.R_10r_ROI.nii.gz -add lh.L_10v_ROI.nii.gz -add rh.R_10v_ROI.nii.gz vmPFC.nii.gz

# echo "VS mask"
fslmaths segment26_freesurfer_rawavg -add segment58_freesurfer_rawavg -add segment12_freesurfer_rawavg -add segment51_freesurfer_rawavg VS.nii.gz

# echo "pgACC_61 mask"
fslmaths lh.L_a24_ROI.nii.gz -add rh.R_a24_ROI.nii.gz pgACC_61.nii.gz

# echo "sgACC_164 mask"
fslmaths lh.L_25_ROI.nii.gz -add rh.R_25_ROI.nii.gz sgACC_164.nii.gz

# echo "sgACC_165 mask"
fslmaths lh.L_s32_ROI.nii.gz -add rh.R_s32_ROI.nii.gz sgACC_165.nii.gz

# echo "vmPFC_64 mask"
fslmaths lh.L_p32_ROI.nii.gz -add rh.R_p32_ROI.nii.gz vmPFC_64.nii.gz

# echo "vmPFC_65 mask"
fslmaths lh.L_10r_ROI.nii.gz -add rh.R_10r_ROI.nii.gz vmPFC_65.nii.gz

# echo "mOFC mask"
fslmaths lh.L_10v_ROI.nii.gz -add rh.R_10v_ROI.nii.gz mOFC.nii.gz

# echo "NAcc mask"
fslmaths segment26_freesurfer_rawavg -add segment58_freesurfer_rawavg NAcc.nii.gz

# echo "putamen mask"
fslmaths segment12_freesurfer_rawavg -add segment51_freesurfer_rawavg putamen.nii.gz

## binarize masks
fslmaths pgACC.nii.gz -bin pgACC.nii.gz
fslmaths vmPFC.nii.gz -bin vmPFC.nii.gz
fslmaths VS.nii.gz -bin VS.nii.gz
fslmaths pgACC_61.nii.gz -bin pgACC_61.nii.gz
fslmaths sgACC_164.nii.gz -bin sgACC_164.nii.gz
fslmaths sgACC_165.nii.gz -bin sgACC_165.nii.gz
fslmaths vmPFC_64.nii.gz -bin vmPFC_64.nii.gz
fslmaths vmPFC_65.nii.gz -bin vmPFC_65.nii.gz
fslmaths mOFC.nii.gz -bin mOFC.nii.gz

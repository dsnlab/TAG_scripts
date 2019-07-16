#!/bin/bash

# HCP parcellations
# dmPFC 72	10d_ROI
# dmPFC 69	9m_ROI
# dmPFC 62	d32_ROI
# TPJ 28	TPOJ1_ROI
# TPJ 25	TPOJ2_ROI
# dlPFC 46_ROI p9-46v_ROI 9-46d_ROI 8C_ROI 8Av_ROI 8Ad_ROI

## define paths
fromannotsDir=/projects/dsnlab/shared/tag/bids_data/derivatives/freesurfer_w1/sub-$SUB/mri/fromannots/

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

# echo "dmPFC mask"
fslmaths lh.L_10d_ROI.nii.gz -add rh.R_10d_ROI.nii.gz -add lh.L_9m_ROI.nii.gz -add rh.R_9m_ROI.nii.gz -add lh.L_d32_ROI.nii.gz -add rh.R_d32_ROI.nii.gz dmPFC.nii.gz

# echo "TPJ mask"
fslmaths lh.L_TPOJ1_ROI.nii.gz -add rh.R_TPOJ1_ROI.nii.gz -add lh.L_TPOJ2_ROI.nii.gz -add rh.R_TPOJ2_ROI.nii.gz TPJ.nii.gz

# echo "dlPFC mask"
fslmaths lh.L_46_ROI.nii.gz -add rh.R_46_ROI.nii.gz -add lh.L_p9-46v_ROI.nii.gz -add rh.R_p9-46v_ROI.nii.gz -add lh.L_9-46d_ROI.nii.gz -add rh.R_9-46d_ROI.nii.gz -add lh.L_8C_ROI.nii.gz -add rh.R_8C_ROI.nii.gz -add lh.L_8Av_ROI.nii.gz -add rh.R_8Av_ROI.nii.gz -add lh.L_8Ad_ROI.nii.gz -add rh.R_8Ad_ROI.nii.gz dlPFC.nii.gz

## binarize masks
fslmaths dmPFC.nii.gz -bin dmPFC.nii.gz
fslmaths TPJ.nii.gz -bin TPJ.nii.gz
fslmaths dlPFC.nii.gz -bin dlPFC.nii.gz

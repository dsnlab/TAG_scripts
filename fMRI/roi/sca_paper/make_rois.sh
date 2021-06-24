#!/bin/bash
#SBATCH --job-name=rois
#SBATCH --output=rois.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --account=dsnlab
#SBATCH --partition=ctn,short

# This script creates binarized ROIs from parcellations

# freesurfer parcellations
# NAcc: 26 / 58
# Putamen: 12 / 51

# HCP parcellations
# pgACC	174
# pgACC	381
# sgACC	169
# sgACC	379
# vmPFC	168
# vmPFC	324

## define paths
atlas_schaefer=/projects/dsnlab/shared/parcellation_atlas_schaeferes/Schaefer/MNI/Schaefer2018_400Parcels_7Networks_order_FSLMNI152_2mm.nii.gz
atlas_hcp=/projects/dsnlab/shared/tag/nonbids_data/fMRI/roi/HCPMMP1_on_MNI152_ICBM2009a_nlin_hd.nii.gz
roiDir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/roi

## load FSL
module load fsl

# cd into directory with the default mask files
cd ${roiDir}

echo -e "\nroi folder is in $roiDir"

## create masks
echo "Creating masks"

## Schaefer
# echo "pgACC_174"
# fslmaths $atlas_schaefer -thr 174 -uthr 174 -bin schaefer_pgACC_174.nii.gz

# echo "pgACC_381"
# fslmaths $atlas_schaefer -thr 381 -uthr 381 -bin schaefer_pgACC_381.nii.gz

# echo "sgACC_169"
# fslmaths $atlas_schaefer -thr 169 -uthr 169 -bin schaefer_sgACC_169.nii.gz

# echo "sgACC_379"
# fslmaths $atlas_schaefer -thr 379 -uthr 379 -bin schaefer_sgACC_379.nii.gz

# echo "vmPFC_168"
# fslmaths $atlas_schaefer -thr 168 -uthr 168 -bin schaefer_vmPFC_168.nii.gz

# echo "vmPFC_324"
# fslmaths $atlas_schaefer -thr 324 -uthr 324 -bin schaefer_vmPFC_324.nii.gz

# echo "pgACC"
# fslmaths schaefer_pgACC_174.nii.gz -add schaefer_pgACC_381.nii.gz -bin schaefer_pgACC.nii.gz

# echo "sgACC"
# fslmaths schaefer_sgACC_169.nii.gz -add schaefer_sgACC_379.nii.gz -bin schaefer_sgACC.nii.gz

# echo "vmPFC"
# fslmaths schaefer_vmPFC_168 -add schaefer_vmPFC_324.nii.gz -bin schaefer_vmPFC.nii.gz

echo "PCC_192"
fslmaths $atlas_schaefer -thr 192 -uthr 192 -bin schaefer_PCC_192.nii.gz

echo "PCC_195"
fslmaths $atlas_schaefer -thr 195 -uthr 195 -bin schaefer_PCC_195.nii.gz

echo "PCC_395"
fslmaths $atlas_schaefer -thr 395 -uthr 395 -bin schaefer_PCC_395.nii.gz

echo "PCC"
fslmaths schaefer_PCC_192.nii.gz -add schaefer_PCC_195.nii.gz -add schaefer_PCC_395.nii.gz -bin schaefer_PCC.nii.gz

## HCP
# echo "sgACC"
# fslmaths sgACC_164.nii.gz -add sgACC_165.nii.gz -bin sgACC.nii.gz

echo "PCC_30"
fslmaths $atlas_hcp -thr 30 -uthr 30 -bin HCP_PCC_30.nii.gz

echo "PCC_33"
fslmaths $atlas_hcp -thr 33 -uthr 33 -bin HCP_PCC_33.nii.gz

echo "PCC"
fslmaths HCP_PCC_30.nii.gz -add HCP_PCC_33.nii.gz -bin HCP_PCC.nii.gz

#!/bin/bash
#SBATCH --job-name=rois
#SBATCH --output=rois.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G

# This script creates binarized ROIs from parcellations

# freesurfer parcellations
# NAcc: 26 / 58
# Putamen: 12 / 51

# HCP parcellations
# pgACC	61
# sgACC	164
# sgACC	165
# vmPFC	64
# vmPFC	65
# mOFC	88
# TPJ 28
# TPJ 25
# dmPFC 69
# dmPFC 72
# dmPFC 62

## define paths
roiDir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/roi

## load FSL
module load fsl

# cd into directory with the default mask files
cd ${roiDir}

echo -e "\nroi folder is in $roiDir"

## create masks
echo "Creating masks"

echo "pgACC_61"
fslmaths HCPMMP1_on_MNI152_ICBM2009a_nlin_hd.nii.gz -thr 61 -uthr 61 -bin pgACC_61.nii.gz

echo "sgACC_164"
fslmaths HCPMMP1_on_MNI152_ICBM2009a_nlin_hd.nii.gz -thr 164 -uthr 164 -bin sgACC_164.nii.gz

echo "sgACC_165"
fslmaths HCPMMP1_on_MNI152_ICBM2009a_nlin_hd.nii.gz -thr 165 -uthr 165 -bin sgACC_165.nii.gz

echo "vmPFC_64"
fslmaths HCPMMP1_on_MNI152_ICBM2009a_nlin_hd.nii.gz -thr 64 -uthr 64 -bin vmPFC_64.nii.gz

echo "vmPFC_65"
fslmaths HCPMMP1_on_MNI152_ICBM2009a_nlin_hd.nii.gz -thr 65 -uthr 65 -bin vmPFC_65.nii.gz

echo "mOFC"
fslmaths HCPMMP1_on_MNI152_ICBM2009a_nlin_hd.nii.gz -thr 88 -uthr 88 -bin mOFC.nii.gz

echo "TPJ_28"
fslmaths HCPMMP1_on_MNI152_ICBM2009a_nlin_hd.nii.gz -thr 28 -uthr 28 -bin TPJ_28.nii.gz

echo "TPJ_25"
fslmaths HCPMMP1_on_MNI152_ICBM2009a_nlin_hd.nii.gz -thr 25 -uthr 25 -bin TPJ_25.nii.gz

echo "dmPFC_69"
fslmaths HCPMMP1_on_MNI152_ICBM2009a_nlin_hd.nii.gz -thr 69 -uthr 69 -bin dmPFC_69.nii.gz

echo "dmPFC_72"
fslmaths HCPMMP1_on_MNI152_ICBM2009a_nlin_hd.nii.gz -thr 72 -uthr 72 -bin dmPFC_72.nii.gz

echo "dmPFC_62"
fslmaths HCPMMP1_on_MNI152_ICBM2009a_nlin_hd.nii.gz -thr 62 -uthr 62 -bin dmPFC_62.nii.gz

echo "NAcc"
fslmaths aseg.nii -thr 26 -uthr 26 r_NAcc.nii.gz
fslmaths aseg.nii -thr 58 -uthr 58 l_NAcc.nii.gz
fslmaths r_NAcc.nii.gz -add l_NAcc.nii.gz -bin NAcc.nii.gz

echo "putamen"
fslmaths aseg.nii -thr 12 -uthr 12 r_putamen.nii.gz
fslmaths aseg.nii -thr 51 -uthr 51 l_putamen.nii.gz
fslmaths r_putamen.nii.gz -add l_putamen.nii.gz -bin putamen.nii.gz

echo "pg/sgACC"
fslmaths pgACC_61.nii.gz -add sgACC_164.nii.gz -add sgACC_165.nii.gz -bin pgACC.nii.gz

echo "vmPFC"
fslmaths vmPFC_64.nii.gz -add vmPFC_65.nii.gz -add mOFC.nii.gz -bin vmPFC.nii.gz

echo "VS"
fslmaths NAcc.nii.gz -add putamen.nii.gz -bin VS.nii.gz

echo "TPJ"
fslmaths TPJ_28.nii.gz -add TPJ_25.nii.gz -bin TPJ.nii.gz

echo "dmPFC"
fslmaths dmPFC_69.nii.gz -add dmPFC_72.nii.gz -add dmPFC_62 -bin dmPFC.nii.gz

## remove intermediate hemisphere rois
echo "removing intermediate rois"
rm r_*.nii.gz
rm l_*.nii.gz
rm pgACC_*.nii.gz
rm *mPFC_*.nii.gz
rm TPJ_*.nii.gz

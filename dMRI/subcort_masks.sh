#!/bin/bash

# Note: Run this after subcort_seeds.sh

# Load FSL
module load fsl/5.0.9

# This script will parcellate subcortical structures using FSL's first.  It will create masks for these structures and warp them into subjects' diffusion space, so they can be used as seed masks for tractography analyses.

# Set directory names
datadir="/projects/dsnlab/shared/tag/bids_data"
scriptsdir="/projects/dsnlab/shared/tag/TAG_scripts/dMRI"
outputdir="/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc"

# Set error log file
errorlog=""$scriptsdir"/errorlog_subcortmasks.txt"

# Create error log file
touch "${errorlog}"

if [ -f $("$outputdir"/"${subid}"/ses-wave1/anat/sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz) ]; then

# Extracting subject-specific masks for subcortical structures.
cd "$outputdir"/"${subid}"/ses-wave1/anat

# Thalamus masks
echo generating "${subid}" left and right thalamus masks
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 9.5 -uthr 10.5 -bin ../masks/l_thal_mask
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 48.5 -uthr 49.5 -bin ../masks/r_thal_mask

# Caudate masks
echo generating "${subid}" left and right caudate masks
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 10.5 -uthr 11.5 -bin ../masks/l_caud_mask
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 49.5 -uthr 50.5 -bin ../masks/r_caud_mask

# Putamen masks
echo generating "${subid}" left and right putamen masks
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 11.5 -uthr 12.5 -bin ../masks/l_puta_mask
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 50.5 -uthr 51.5 -bin ../masks/r_puta_mask

# Pallidum masks
echo generating "${subid}" left and right pallidum masks
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 12.5 -uthr 13.5 -bin ../masks/l_pall_mask
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 51.5 -uthr 52.5 -bin ../masks/r_pall_mask

# Brain-Stem/4th Ventricle mask
echo generating "${subid}" brain stem/4th ventricle mask
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 15.5 -uthr 16.5 -bin ../masks/stem_mask

# Hippocampus masks
echo generating "${subid}" left and right hippocampus masks
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 16.5 -uthr 17.5 -bin ../masks/l_hipp_mask
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 52.5 -uthr 53.5 -bin ../masks/r_hipp_mask

# Amygdala masks
echo generating "${subid}" left and right amygdala masks
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 17.5 -uthr 18.5 -bin ../masks/l_amyg_mask
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 53.5 -uthr 54.5 -bin ../masks/r_amyg_mask

# Accumbens masks
echo generating "${subid}" left and right accumbens masks
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 25.5 -uthr 26.5 -bin ../masks/l_nacc_mask
fslmaths sub-"${subid}"_ses-wave1_all_fast_firstseg.nii.gz -thr 57.5 -uthr 58.5 -bin ../masks/r_nacc_mask

fi

else
# Making a note of missing files in error log
echo "ERROR: no fsl first files"
echo "$outputdir"/"${subid}"/ses-wave1/anat: MISSING AUTOMATED SUBCORTICAL SEGMENTATION FILES >> $errorlog
fi



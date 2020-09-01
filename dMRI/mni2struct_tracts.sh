#!/bin/bash

# Load FSL
module load fsl/5.0.10
module load cuda/8.0

# This script readies individual-level tractography files for group concatenation.

# Set directory names
datadir="/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc"
scriptsdir="/projects/dsnlab/shared/tag/TAG_scripts/dMRI"
outputdir="/projects/dsnlab/shared/tag/nonbids_data/dMRI"

# Set error log file
errorlog=""$scriptsdir"/errorlog_mni2struct_tracts.txt"

# Create error log file
touch "${errorlog}"

# Warping group tracts back into subjects' native space
echo warping group "${tract}" tract into "${subid}" native space
cd "$outputdir"/"${subid}"/ses-wave1/masks

applywarp --ref=../anat/mprage_brain.nii.gz --in="$outputdir"/"${tract}"_group/all_"${tract}"_mask_bin.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out="${tract}"_groupmask_bin

applywarp --ref=../anat/mprage_brain.nii.gz --in="$outputdir"/group_masks_final/mpfcSVC_to_laccSVC.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=mpfcSVC_to_laccSVC_groupmask_thr84

applywarp --ref=../anat/mprage_brain.nii.gz --in="$outputdir"/group_masks_final/mpfcSVC_to_pccSVC.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=mpfcSVC_to_pccSVC_groupmask_thr74

applywarp --ref=../anat/mprage_brain.nii.gz --in="$outputdir"/group_masks_final/pccSVC_to_rtpjSVC.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=pccSVC_to_rtpjSVC_groupmask_thr56

fslmaths "${tract}"_groupmask_bin.nii.gz -thr 0.01 -bin "${tract}"_groupmask_bin.nii.gz
fslmaths mpfcSVC_to_laccSVC_groupmask_thr84.nii.gz -thr 0.01 -bin mpfcSVC_to_laccSVC_groupmask_bin84.nii.gz
fslmaths mpfcSVC_to_pccSVC_groupmask_thr74.nii.gz -thr 0.01 -bin mpfcSVC_to_pccSVC_groupmask_bin74.nii.gz
fslmaths pccSVC_to_rtpjSVC_groupmask_thr56.nii.gz -thr 0.01 -bin pccSVC_to_rtpjSVC_groupmask_bin56.nii.gz

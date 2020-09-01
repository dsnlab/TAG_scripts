#!/bin/bash

#Usage: call this script when you use sh batch_tpj_seeds.sh

# Load FSL & Cuda
module load fsl/5.0.10
module load cuda/8.0

# Set directory names
datadir="/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc"
scriptsdir="/projects/dsnlab/shared/tag/TAG_scripts/dMRI"
outputdir="/projects/dsnlab/shared/tag/nonbids_data/dMRI"

# Set error log file
errorlog=""$scriptsdir"/errorlog_tpjseeds.txt"

# Create error log file
touch "${errorlog}"

if [[ -f "$datadir"/"${subid}"/ses-wave1/anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz ]]; then

# Generating MNI to mprage additional seed masks
cd "$outputdir"/"${subid}"/ses-wave1/masks
echo generating "${subid}" svc_lthal mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/svc_rx/svc_lthal.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=lthal_seed_svc
echo generating "${subid}" left TPJ neurovault mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/chang_neurovault/lTPJ_Mask_mni.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=ltpj_neurovault_mask
echo generating "${subid}" right TPJ neurovault mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/chang_neurovault/rTPJ_Mask_mni.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=rtpj_neurovault_mask
echo generating "${subid}" vmPFC neurovault mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/chang_neurovault/VMPFC_Mask_mni.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=vmpfc_neurovault_mask
mv tpj_neurovault_mask bilat_tpj_neurovault_mask

# Rebinarizing masks
echo rebinarizing "${subid}" masks
fslmaths lthal_seed_svc.nii.gz -thr 0.5 -bin lthal_mask_svc.nii.gz
fslmaths ltpj_neurovault_mask.nii.gz -thr 0.5 -bin ltpj_neurovault_mask.nii.gz
fslmaths rtpj_neurovault_mask.nii.gz -thr 0.5 -bin rtpj_neurovault_mask.nii.gz
fslmaths vmpfc_neurovault_mask.nii.gz -thr 0.5 -bin vmpfc_neurovault_mask.nii.gz

else
# Making a note of missing files in error log
echo "ERROR: no reoriented anatomy file; unable to perform warps"
echo "$datadir"/"${subid}"/ses-wave1/anat: MISSING REORIENTED MPRAGE >> $errorlog
fi



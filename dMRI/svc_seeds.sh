#!/bin/bash

#Usage: call this script when you use sh batch_svc_seeds.sh

# Load FSL & Cuda
module load fsl/5.0.10
module load cuda/8.0

# This script will warp task-derived SVC masks into each subject's native space for later use with tractography.

# Set directory names
datadir="/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc"
scriptsdir="/projects/dsnlab/shared/tag/TAG_scripts/dMRI"
outputdir="/projects/dsnlab/shared/tag/nonbids_data/dMRI"

# Set error log file
errorlog=""$scriptsdir"/errorlog_svcseeds.txt"

# Create error log file
touch "${errorlog}"

if [[ -f "$datadir"/"${subid}"/ses-wave1/anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz ]]; then

# Setting up file structure
mkdir -p "$outputdir"/"${subid}"/ses-wave1/
cd "$outputdir"/"${subid}"/ses-wave1/
cp -R "$datadir"/"${subid}"/ses-wave1/dwi .
cp -R "$datadir"/"${subid}"/ses-wave1/anat .
mkdir -p "$outputdir"/"${subid}"/ses-wave1/masks

# Generating MNI to mprage task-based SVC masks
cd "$outputdir"/"${subid}"/ses-wave1/masks
echo generating "${subid}" svc_mpfc mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/svc_rx/svc_mpfc.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=mpfc_seed_svc
echo generating "${subid}" svc_pcc mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/svc_rx/svc_pcc.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=pcc_seed_svc
echo generating "${subid}" svc_rtpj mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/svc_rx/svc_rtpj.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=rtpj_seed_svc
echo generating "${subid}" svc_lacc mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/svc_rx/svc_lacc.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=lacc_seed_svc
echo generating "${subid}" svc_lthal mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/svc_rx/svc_lthal.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=lthal_seed_svc

# Note: Appropriate masks depend on your project.  Here are some generally useful masks, including an mPFC & PCC mask (based on Neurosynth's metanalysis for "self"), a vmPFC & TPJ mask (based on masks uploaded by Luke Chang on NeuroVault), and a midline mask (e.g., to be used as an exclusion mask to avoid uncovering contralateral tracts).

# Generating MNI to mprage Neurosynth & Neurovault masks
echo generating "${subid}" mPFC neurosynth mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/self_neurosynth/mpfc_mask.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=mpfc_neurosynth_mask
echo generating "${subid}" PCC neurosynth mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/self_neurosynth/pcc_mask.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=pcc_neurosynth_mask
echo generating "${subid}" vmPFC neurovault mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/chang_neurovault/VMPFC_Mask_mni.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=vmpfc_neurovault_mask
echo generating "${subid}" bilateral TPJ neurovault mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/chang_neurovault/TPJ_Mask.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=bilat_tpj_neurovault_mask
echo generating "${subid}" left TPJ neurovault mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/chang_neurovault/lTPJ_Mask_mni.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=ltpj_neurovault_mask
echo generating "${subid}" right TPJ neurovault mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/chang_neurovault/rTPJ_Mask_mni.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=rtpj_neurovault_mask
echo generating  "${subid}" midline mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$outputdir"/masks/exclusion_masks/midline_mask.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=midline_mask

# Rebinarizing masks
echo rebinarizing "${subid}" masks
fslmaths mpfc_seed_svc.nii.gz -thr 0.5 -bin mpfc_mask_svc.nii.gz
fslmaths pcc_seed_svc.nii.gz -thr 0.5 -bin pcc_mask_svc.nii.gz
fslmaths rtpj_seed_svc.nii.gz -thr 0.5 -bin rtpj_mask_svc.nii.gz
fslmaths lacc_seed_svc.nii.gz -thr 0.5 -bin lacc_mask_svc.nii.gz

fslmaths mpfc_neurosynth_mask.nii.gz -thr 0.5 -bin mpfc_neurosynth_mask.nii.gz
fslmaths pcc_neurosynth_mask.nii.gz -thr 0.5 -bin pcc_neurosynth_mask.nii.gz
fslmaths vmpfc_neurovault_mask.nii.gz -thr 0.5 -bin vmpfc_neurovault_mask.nii.gz
fslmaths tpj_neurovault_mask.nii.gz -thr 0.5 -bin tpj_neurovault_mask.nii.gz
fslmaths midline_mask.nii.gz -thr 0.5 midline_exclusion_mask.nii.gz

else
# Making a note of missing files in error log
echo "ERROR: no reoriented anatomy file; unable to perform warps"
echo "$datadir"/"${subid}"/ses-wave1/anat: MISSING REORIENTED MPRAGE >> $errorlog
fi



#!/bin/bash

#This scripts assumes you have already run fMRIPrep

#Usage: call this script when you use sbatch batch_feat_svc.sh

# Load FSL & Cuda
module load fsl/5.0.10
module load cuda/8.0

# Set directory names
datadir="/projects/dsnlab/shared/tag/bids_data"
scriptsdir="/projects/dsnlab/shared/tag/TAG_scripts/fMRI"
outputdir="/projects/dsnlab/shared/tag/nonbids_data/fMRI/svc_block"

# Select options
masks="TRUE"

# Set error log file
errorlog=""$scriptsdir"/errorlog_feat_svc.txt"

# Create error log file
touch "${errorlog}"

if [ $(ls "$datadir"/derivatives/fmriprep_wave1/sub-"${subid}"/ses-wave1/func/*-SVC*preproc.nii.gz | wc -l) -eq 2 ]; then

# Getting things organized
mkdir -p "$outputdir"/"${subid}"/ses-wave1/
cd "$outputdir"/"${subid}"/ses-wave1/
cp -R "$datadir"/derivatives/fmriprep_wave1/sub-"${subid}"/ses-wave1/* .
cp -R "$datadir"/sub-"${subid}"/ses-wave1/fmap .

# Create onset/duration files
# need to insert code here

# Prep for fieldmap

# Merge two magnitude images
cd "$outputdir"/"${subid}"/ses-wave1/fmap/
fslmerge -a sub-"${subid}"_ses-wave1_magnitudes_merged.nii.gz sub-"${subid}"_ses-wave1_magnitude1.nii.gz sub-"${subid}"_ses-wave1_magnitude2.nii.gz

# Create brain-extracted magnitude image for fieldmap
bet2 sub-"${subid}"_ses-wave1_magnitudes_merged sub-"${subid}"_ses-wave1_magnitudes_merged_brain

# Calculating the fieldmap
fsl_prepare_fieldmap SIEMENS sub-"${subid}"_ses-wave1_phasediff.nii.gz sub-"${subid}"_magnitudes_merged_brain.nii.gz sub-"${subid}"_ses-wave1_fmap_rads 2.46

# Combining both diffusion sequences
echo merging "${subid}" diffusion sequences
fslmerge -a diffusion_data sub-"${subid}"_ses-wave1_acq-rl_dwi.nii.gz sub-"${subid}"_ses-wave1_acq-lr_dwi.nii.gz

# Combining bvecs, bvals, and slice aquisition orders from both diffusion sequences
echo merging "${subid}" bvecs
paste -d"\0" sub-"${subid}"_ses-wave1_acq-rl_dwi_bvecs sub-"${subid}"_ses-wave1_acq-lr_dwi_bvecs >> bvecs

echo merging "${subid}" bvals
paste -d"\0" sub-"${subid}"_ses-wave1_acq-rl_dwi_bvals sub-"${subid}"_ses-wave1_acq-lr_dwi_bvals >> bvals

# Running eddy with outlier replacement & slice-to-volume motion correction
# Note: This step identifies slices with excessive motion and replaces them with Gaussian process predictions.  For motion correction without outlier replacement, simply remove --repol option.
echo running "${subid}" eddy
#eddy_cuda8.0-5.0.11 --imain=diffusion_data.nii.gz --mask=b0_unwarped_reoriented_brain_mask.nii.gz --acqp="$scriptsdir"/acqparams.txt --index="$scriptsdir"/index.txt --bvecs=bvecs --bvals=bvals --topup=topup_results --repol --ol_type=both --mporder=9 --s2v_niter=10 --slspec="$scriptsdir"/slspec.txt --resamp=lsr --fep=false --cnr_maps --out=eddy_corrected_data_repol

eddy_cuda8.0-5.0.11 --imain=diffusion_data.nii.gz --mask=b0_unwarped_brain_mask.nii.gz --acqp=/projects/dsnlab/shared/tag/TAG_scripts/dMRI/acqparams.txt --index=/projects/dsnlab/shared/tag/TAG_scripts/dMRI/index.txt --bvecs=bvecs --bvals=bvals --topup=topup_results --repol --ol_type=both --mporder=9 --s2v_niter=10 --slspec=/projects/dsnlab/shared/tag/TAG_scripts/dMRI/tag_slspec.txt --resamp=lsr --fep=false --cnr_maps --residuals -v --out=eddy_corrected_data_repol

# Reorienting & renaming files
fslreorient2std eddy_corrected_data_repol.nii.gz data.nii.gz
fslreorient2std b0_unwarped_brain_mask.nii.gz nodif_brain_mask.nii.gz

# Prepping for registration
cd "$outputdir"/"${subid}"/ses-wave1/
cp -R "$datadir"/sub-"${subid}"/ses-wave1/anat .
cd "$outputdir"/"${subid}"/ses-wave1/anat
fslreorient2std sub-"${subid}"_ses-wave1_T1w.nii.gz sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz

# Skull stripping & brain extraction
echo "${subid}" skull stripping and brain extraction
standard_space_roi sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz mprage_ssroi -b
bet mprage_ssroi.nii.gz mprage_brain -f .2 -m

# Linear registration of mprage to standard space
mkdir reg
cd reg
echo "${subid}" linear registration mprage to MNI
/packages/fsl/5.0.9/fsl/bin/flirt -in "$outputdir"/"${subid}"/ses-wave1/anat/mprage_brain.nii.gz -ref /packages/fsl/5.0.9/fsl/data/standard/MNI152_T1_2mm_brain -out "$outputdir"/"${subid}"/ses-wave1/anat/reg/struct2mni -omat "$outputdir"/"${subid}"/ses-wave1/anat/reg/struct2mni.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

# Non-linear warp of linear registration
echo warping "${subid}" registration nonlinearly
fnirt --in=../sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --aff=struct2mni.mat --cout=struct2mni_warp --ref=//packages/fsl/5.0.9/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz

# Inverting non-linear warp
echo inverting "${subid}" non-linear warp
invwarp --ref=../mprage_brain.nii.gz --warp=struct2mni_warp.nii.gz --out=mni2struct_warp

# Fitting diffusion tensors at each voxel.  This step outputs eigenvectors, mean diffusivity, & fractional anisotropy
echo fitting "${subid}" tensors at each voxel
cd "$outputdir"/"${subid}"/ses-wave1/dwi

dtifit -k data.nii.gz -o dti -m nodif_brain_mask.nii.gz -r "$scriptsdir"/bvecs -b "$scriptsdir"/bvals

# Linear registration of FA map to mprage
cd "$outputdir"/"${subid}"/ses-wave1/anat/reg
echo "${subid}" linear registration FA map to mprage
/packages/fsl/5.0.9/fsl/bin/flirt -in "$outputdir"/"${subid}"/ses-wave1/dwi/dti_FA.nii.gz -ref "$outputdir"/"${subid}"/ses-wave1/anat/mprage_brain.nii.gz -out FA2struct -omat FA2struct.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -interp trilinear

# Inverse of transformation above (i.e., creating image to transform standard-space masks into diffusion space)
echo inverting "${subid}" FA-to-structural transformation
/packages/fsl/5.0.9/fsl/bin/convert_xfm -omat struct2FA.mat -inverse "$outputdir"/"${subid}"/ses-wave1/anat/reg/FA2struct.mat


if [ "${masks}" == "TRUE" ]; then
# Applying warps to make masks
# Note: Appropriate masks depend on your project.  This script generates some masks that may be useful, including an mPFC & PCC mask (based on Neurosynth's metanalysis for "self"), a vmPFC & TPJ mask (based on masks uploaded by Luke Chang on NeuroVault), and a midline mask (e.g., to be used as an exclusion mask to avoid uncovering contralateral tracts).
mkdir -p "$outputdir"/"${subid}"/ses-wave1/masks
cd "$outputdir"/"${subid}"/ses-wave1/masks

# Generating MNI to mprage masks
echo generating "${subid}" mPFC mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$scriptsdir"/masks/mpfc_mask.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=mpfc_mask
echo generating "${subid}" PCC mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$scriptsdir"/masks/pcc_mask.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=pcc_mask
echo generating "${subid}" vmPFC mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$scriptsdir"/masks/VMPFC.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=vmpfc_mask
echo generating "${subid}" TPJ mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$scriptsdir"/masks/TPJ_Mask.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=tpj_mask
echo generating  "${subid}"midline mask
applywarp --ref=../anat/sub-"${subid}"_ses-wave1_T1w_reoriented.nii.gz --in="$scriptsdir"/masks/midline_mask.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=midline_mask

# Rebinarizing masks
echo rebinarizing "${subid}" masks
fslmaths mpfc_mask.nii.gz -thr 0.5 -bin mpfc_mask.nii.gz
fslmaths pcc_mask.nii.gz -thr 0.5 -bin pcc_mask.nii.gz
fslmaths vmpfc_mask.nii.gz -thr 0.5 -bin vmpfc_mask.nii.gz
fslmaths tpj_mask.nii.gz -thr 0.5 -bin tpj_mask.nii.gz
fslmaths midline_mask.nii.gz -thr 0.5 midline_mask.nii.gz

fi

else
# Making a note of missing files in error log
echo "ERROR: no files; nothing to preprocess"
echo "$datadir"/sub-"${subid}"/ses-wave1/dwi: MISSING DIFFUSION SEQUENCES >> $errorlog
fi



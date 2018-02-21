#!/bin/bash

# This script will preprocess two diffusion imaging series with left-right & right-left phase encoding directions.

# It extracts b0 volumes from each sequence, estimates the susceptibility induced off-resonance field, corrects for eddy current-induced distortion & movement, and estimates diffusion parameters & models crossing fibers at each voxel.

# This script uses FSL tools topup, eddy, dtifit, and bedpostx.

# This script calls "acqparams.txt" and "index.txt".  The former specifies the phase encoding directions and total readout time; the latter tells the motion correction software which line in acqparams.txt applies to a given volume.  These are the same for each TAG subject and don't need to be respecified.

# Load FSL
module load fsl/5.0.9

# For now, let's use TAG016 as an example...
cd //projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/dwi

# Extract B0 images from nifti files & combine in single volume.
echo making b0 image
fslroi sub-TAG016_ses-wave1_acq-rl_dwi.nii.gz b0_rl 0 -1 0 -1 0 -1 0 1
fslroi sub-TAG016_ses-wave1_acq-lr_dwi.nii.gz b0_lr 0 -1 0 -1 0 -1 0 1
fslmerge -a b0_rl_lr b0_rl.nii.gz b0_lr.nii.gz

# Running topup
echo running topup
topup --imain=b0_rl_lr.nii.gz --datain=//projects/dsnlab/shared/tag/TAG_scripts/dMRI/acqparams.txt --config=b02b0.cnf --out=topup_results --iout=b0_unwarped --fout=fieldmap_Hz

# Preparing for eddy
# Extract brain & create brain mask
echo creating nodif brain mask
fslmaths b0_unwarped.nii.gz -Tmean b0_unwarped_mean
bet b0_unwarped_mean.nii.gz b0_unwarped_brain -m
fslreorient2std b0_unwarped_brain_mask.nii.gz b0_unwarped_reoriented_brain_mask.nii.gz

# Combining both diffusion sequences
echo merging diffusion sequences
fslmerge -a diffusion_data sub-TAG016_ses-wave1_acq-rl_dwi.nii.gz sub-TAG016_ses-wave1_acq-lr_dwi.nii.gz

# Combining bvecs & bvals from both diffusion sequences
echo merging bvecs
paste -d"\0" sub-TAG016_ses-wave1_acq-rl_dwi_bvecs sub-TAG016_ses-wave1_acq-lr_dwi_bvecs >> bvecs

echo merging bvals
paste -d"\0" sub-TAG016_ses-wave1_acq-rl_dwi_bvals sub-TAG016_ses-wave1_acq-lr_dwi_bvals >> bvals

# Running eddy with outlier replacement
# Note: This step identifies slices with excessive motion and replaces them with Gaussian process predictions.  For motion correction without outlier replacement, simply remove --repol option.
echo running eddy
eddy_openmp-5.0.11 --imain=diffusion_data.nii.gz --mask=b0_unwarped_reoriented_brain_mask.nii.gz --acqp=//projects/dsnlab/shared/tag/TAG_scripts/dMRI/acqparams.txt --index=//projects/dsnlab/shared/tag/TAG_scripts/dMRI/index.txt --bvecs=bvecs --bvals=bvals --topup=topup_results --repol --out=eddy_corrected_data_repol

# Reorienting & renaming files
fslreorient2std eddy_corrected_data_repol.nii.gz data.nii.gz
cp b0_unwarped_reoriented_brain_mask.nii.gz nodif_brain_mask.nii.gz

# Prepping for registration
cd //projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/anat
fslreorient2std sub-TAG016_ses-wave1_T1w.nii.gz sub-TAG016_ses-wave1_T1w_reoriented.nii.gz

# Skull stripping & brain extraction
echo skull stripping and brain extraction
standard_space_roi sub-TAG016_ses-wave1_T1w_reoriented.nii.gz mprage_ssroi -b
bet mprage_ssroi.nii.gz mprage_brain -f .2 -m

# Linear registration of mprage to standard space
mkdir reg
cd reg
echo linear registration mprage to MNI
/packages/fsl/5.0.9/fsl/bin/flirt -in /gpfs/projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/anat/mprage_brain.nii.gz -ref /packages/fsl/5.0.9/fsl/data/standard/MNI152_T1_2mm_brain -out /gpfs/projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/anat/reg/struct2mni -omat /gpfs/projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/anat/reg/struct2mni.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

# Non-linear warp of linear registration
echo warping registration nonlinearly
fnirt --in=../sub-TAG016_ses-wave1_T1w_reoriented.nii.gz --aff=struct2mni.mat --cout=struct2mni_warp --ref=//packages/fsl/5.0.9/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz

# Inverting non-linear warp
echo inverting warp
invwarp --ref=../mprage_brain.nii.gz --warp=struct2mni_warp.nii.gz --out=mni2struct_warp

# Fitting diffusion tensors at each voxel.  This step outputs eigenvectors, mean diffusivity, & fractional anisotropy
echo fitting tensors at each voxel
cd //projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/dwi
dtifit -k data.nii.gz -o dti -m nodif_brain_mask.nii.gz -r bvecs -b bvals

# Linear registration of FA map to mprage
cd //projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/anat/reg
echo linear registration FA map to mprage
/packages/fsl/5.0.9/fsl/bin/flirt -in /gpfs/projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/dwi/dti_FA.nii.gz -ref /gpfs/projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/anat/mprage_brain.nii.gz -out FA2struct -omat FA2struct.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -interp trilinear

# Inverse of transformation above (i.e., creating image to transform standard-space masks into diffusion space)
echo inverting transformation
/packages/fsl/5.0.9/fsl/bin/convert_xfm -omat struct2FA.mat -inverse /gpfs/projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/anat/reg/FA2struct.mat

# Applying warps to make masks
# Note: Appropriate masks depend on your project.  This script generates some masks that may be useful, including an mPFC & PCC mask (based on Neurosynth's metanalysis for "self"), a vmPFC & TPJ mask (based on masks uploaded by Luke Chang on NeuroVault), and a midline mask (e.g., to be used as an exclusion mask to avoid uncovering contralateral tracts).  In addition to these masks initially defined in standard-space and then warped into subject-space, this script also generates subject-specific masks for subcortical structures.
mkdir /gpfs/projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/masks
cd /gpfs/projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/masks

# Generating MNI to mprage masks
echo generating mPFC mask
applywarp --ref=../anat/sub-TAG016_ses-wave1_T1w_reoriented.nii.gz --in=/gpfs/projects/dsnlab/shared/tag/TAG_scripts/dMRI/masks/mpfc_mask.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=mpfc_mask
echo generating PCC mask
applywarp --ref=../anat/sub-TAG016_ses-wave1_T1w_reoriented.nii.gz --in=/gpfs/projects/dsnlab/shared/tag/TAG_scripts/dMRI/masks/pcc_mask.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=pcc_mask
echo generating vmPFC mask
applywarp --ref=../anat/sub-TAG016_ses-wave1_T1w_reoriented.nii.gz --in=/gpfs/projects/dsnlab/shared/tag/TAG_scripts/dMRI/masks/VMPFC.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=vmpfc_mask
echo generating TPJ mask
applywarp --ref=../anat/sub-TAG016_ses-wave1_T1w_reoriented.nii.gz --in=/gpfs/projects/dsnlab/shared/tag/TAG_scripts/dMRI/masks/TPJ_Mask.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=tpj_mask
echo generating midline mask
applywarp --ref=../anat/sub-TAG016_ses-wave1_T1w_reoriented.nii.gz --in=/gpfs/projects/dsnlab/shared/tag/TAG_scripts/dMRI/masks/midline_mask.nii.gz --warp=../anat/reg/mni2struct_warp.nii.gz --out=midline_mask

# Rebinarizing masks
echo rebinarizing masks
fslmaths mpfc_mask.nii.gz -thr 0.5 -bin mpfc_mask.nii.gz
fslmaths pcc_mask.nii.gz -thr 0.5 -bin pcc_mask.nii.gz
fslmaths vmpfc_mask.nii.gz -thr 0.5 -bin vmpfc_mask.nii.gz
fslmaths tpj_mask.nii.gz -thr 0.5 -bin tpj_mask.nii.gz
fslmaths midline_mask.nii.gz -thr 0.5 midline_mask.nii.gz

# Generating subject-specific masks of selected (amygdala & nucleus accumbens) subcortical structures
cd /gpfs/projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/anat
echo segmenting subcortical structures
run_first_all -i sub-TAG016_ses-wave1_T1w_reoriented.nii.gz -o sub-TAG016_ses-wave1
echo generating left and right amygdala masks
fslmaths sub-TAG016_ses-wave1_all_fast_firstseg.nii.gz -thr 17.5 -uthr 18.5 -bin l_amyg_mask
fslmaths sub-TAG016_ses-wave1_all_fast_firstseg.nii.gz -thr 53.5 -uthr 54.5 -bin r_amyg_mask
echo generating left and right accumbens masks
fslmaths sub-TAG016_ses-wave1_all_fast_firstseg.nii.gz -thr 25.5 -uthr 26.5 -bin l_nacc_mask
fslmaths sub-TAG016_ses-wave1_all_fast_firstseg.nii.gz -thr 57.5 -uthr 58.5 -bin r_nacc_mask

# Fitting a probabilistic diffusion model on motion-corrected data
# Note: This last command takes ~15hrs to run
echo running bedpostx
bedpostx /gpfs/projects/dsnlab/shared/tag/bids_data/sub-TAG016/ses-wave1/dwi --nf=2 --fudge=1 --bi=1000

echo Preprocessing completed. Next step - tractography.
# Congratulations!  You are now ready to perform tractography.

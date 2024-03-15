#!/bin/bash

# topup and eddy diffusion preprocessing pipeline for TAG W1-3

# This script uses topup and eddy to estimate the suceptibility induced field, correct for eddy-current induced distortions, and correct for movement
# (volume-to-volume and slice-to-volume) for a given subject at a given wave.
# Use this script in conjunciton with batch_topup_eddy.sh, which will iteratively provide subjects ($subj) and  waves ($wave).

# This script is largely adapted from Sam's script TAG_scripts/dMRI/preproc_diff_051118.sh. There key difference is that this script only returns 
# topup and eddy outputs instead of diffusion parameters so that it can be used as part of the TRACULA pipeline and Marjolein's processing pipeline

# load FSL and cuda
module load fsl/6.0.1
module load cuda/9.1

# set variables
datadir="/projects/dsnlab/shared/tag/bids_data"
scriptsdir="/projects/dsnlab/shared/tag/TAG_scripts/dMRI"
outputdir="/projects/dsnlab/shared/tag/nonbids_data/dMRI/topup_eddy"

# Select options
masks="TRUE"

# Set error log file
errorlog=""${scriptsdir}"/topup_eddy_preprocessing/errorlog_topup_eddy.txt"

# Create error log file
touch "${errorlog}"


# First copy files from bids_data
mkdir -p "${outputdir}/${subj}/${wave}"
cd "${outputdir}/${subj}/${wave}"
cp -R "${datadir}/sub-${subj}/ses-${wave}/dwi" .
# Move files into $wave directory, remove unnecessary dwi directory
mv dwi/* .
rm -R dwi/

# Extract B0 images from nifti files & combine in single file.
echo making ${subj} b0 image

fslroi sub-${subj}_ses-${wave}_acq-rl_dwi.nii.gz b0_rl 0 -1 0 -1 0 -1 0 1
fslroi sub-${subj}_ses-${wave}_acq-lr_dwi.nii.gz b0_lr 0 -1 0 -1 0 -1 0 1
fslmerge -a b0_rl_lr b0_rl.nii.gz b0_lr.nii.gz

# Running topup
echo running ${subj} topup
topup --imain=b0_rl_lr.nii.gz --datain="${scriptsdir}"/acqparams.txt --config=b02b0.cnf --out=topup_results --iout=b0_unwarped --fout=fieldmap_Hz

# Preparing for eddy
# Extract brain & create brain mask
echo creating ${subj} nodif brain mask
fslmaths b0_unwarped.nii.gz -Tmean b0_unwarped_mean
bet b0_unwarped_mean.nii.gz b0_unwarped_brain -m

# Combine both diffusion sequences
echo merging ${subj} diffusion sequences
fslmerge -a diffusion_data sub-${subj}_ses-${wave}_acq-rl_dwi.nii.gz sub-${subj}_ses-${wave}_acq-lr_dwi.nii.gz

# Combine bvecs & bvals from both diffusion sequences
echo merging ${subj} bvecs
paste sub-${subj}_ses-${wave}_acq-rl_dwi_bvecs sub-${subj}_ses-${wave}_acq-lr_dwi_bvecs >> bvecs

echo merging ${subj} bvals
paste sub-${subj}_ses-${wave}_acq-rl_dwi_bvals sub-${subj}_ses-${wave}_acq-lr_dwi_bvals >> bvals

# Run eddy with outlier replacement and slice by volume motion correction. 
echo running ${subj} eddy
eddy_cuda9.1 --imain=diffusion_data.nii.gz --mask=b0_unwarped_brain_mask.nii.gz --acqp=/projects/dsnlab/shared/tag/TAG_scripts/dMRI/acqparams.txt --index=/projects/dsnlab/shared/tag/TAG_scripts/dMRI/index.txt --bvecs=bvecs --bvals=bvals --topup=topup_results --repol --ol_type=both --mporder=9 --s2v_niter=10 --slspec=/projects/dsnlab/shared/tag/TAG_scripts/dMRI/tag_slspec.txt --resamp=lsr --fep=false --cnr_maps --residuals -v --out=${subj}_${wave}_eddy_corrected_data_repol

# Remove copied files 
echo removing copied files
rm *_dwi* *bvals *bvecs

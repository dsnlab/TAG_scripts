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
errorlog=""$scriptsdir"/errorlog_threshtracts.txt"

# Create error log file
touch "${errorlog}"

# Making group-level tractography directories
echo making group-level tractography directories
cd "$outputdir"
mkdir -p mpfcSVC_to_laccSVC_group
mkdir -p mpfcSVC_to_pccSVC_group
mkdir -p mpfcSVC_to_rtpjSVC_group
mkdir -p pccSVC_to_laccSVC_group
mkdir -p pccSVC_to_rtpjSVC_group
mkdir -p laccSVC_to_rtpjSVC_group
mkdir -p mpfcSVC_to_lthalSVC_group
mkdir -p pccSVC_to_lthalSVC_group
mkdir -p laccSVC_to_lthalSVC_group
mkdir -p rtpjSVC_to_lthalSVC_group

mkdir -p mpfcSVC_to_laccSVC_group/nothr
mkdir -p mpfcSVC_to_pccSVC_group/nothr
mkdir -p mpfcSVC_to_rtpjSVC_group/nothr
mkdir -p pccSVC_to_laccSVC_group/nothr
mkdir -p pccSVC_to_rtpjSVC_group/nothr
mkdir -p laccSVC_to_rtpjSVC_group/nothr
mkdir -p mpfcSVC_to_lthalSVC_group/nothr
mkdir -p pccSVC_to_lthalSVC_group/nothr
mkdir -p laccSVC_to_lthalSVC_group/nothr
mkdir -p rtpjSVC_to_lthalSVC_group/nothr

mkdir -p mpfcSVC_to_laccSVC_group/lowthr
mkdir -p mpfcSVC_to_pccSVC_group/lowthr
mkdir -p mpfcSVC_to_rtpjSVC_group/lowthr
mkdir -p pccSVC_to_laccSVC_group/lowthr
mkdir -p pccSVC_to_rtpjSVC_group/lowthr
mkdir -p laccSVC_to_rtpjSVC_group/lowthr
mkdir -p mpfcSVC_to_lthalSVC_group/lowthr
mkdir -p pccSVC_to_lthalSVC_group/lowthr
mkdir -p laccSVC_to_lthalSVC_group/lowthr
mkdir -p rtpjSVC_to_lthalSVC_group/lowthr

# Thresholding & Binarizing fdt paths
echo thresholding and binarizing "${tract}" tract from "${subid}" 
cd "$outputdir"/"${subid}"/ses-wave1/dwi.fit.bedpostX/"${tract}"

max_streams=`fslval fdt_paths.nii.gz cal_max`
tract_thresh=`echo "scale=2; $max_streams/100" | bc`
tract_thresh_low=`echo "scale=2; $max_streams/1000" | bc`
fslmaths fdt_paths.nii.gz -thr $tract_thresh -bin fdt_paths_thr_bin.nii.gz
fslmaths fdt_paths.nii.gz -thr $tract_thresh_low -bin fdt_paths_lowthr_bin.nii.gz
fslmaths fdt_paths.nii.gz -bin fdt_paths_nothr_bin.nii.gz

# Warping tracts into MNI space
echo warping "${tract}" tract from "${subid}" into MNI space
applywarp --ref=/packages/fsl/5.0.9/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz --in=fdt_paths_thr_bin.nii.gz --warp="$outputdir"/"${subid}"/ses-wave1/anat/reg/struct2mni_warp.nii.gz --out="${subid}"_"${tract}"_mask.nii.gz
applywarp --ref=/packages/fsl/5.0.9/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz --in=fdt_paths_lowthr_bin.nii.gz --warp="$outputdir"/"${subid}"/ses-wave1/anat/reg/struct2mni_warp.nii.gz --out="${subid}"_"${tract}"_lowthr_mask.nii.gz
applywarp --ref=/packages/fsl/5.0.9/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz --in=fdt_paths_nothr_bin.nii.gz --warp="$outputdir"/"${subid}"/ses-wave1/anat/reg/struct2mni_warp.nii.gz --out="${subid}"_"${tract}"_nothr_mask.nii.gz

# Copying tracts to group-level directories
echo copying "${tract}" tract from "${subid}" into group-level directory
cp "${subid}"_"${tract}"_mask.nii.gz "$outputdir"/"${tract}"_group/.
cp "${subid}"_"${tract}"_lowthr_mask.nii.gz "$outputdir"/"${tract}"_group/lowthr/.
cp "${subid}"_"${tract}"_nothr_mask.nii.gz "$outputdir"/"${tract}"_group/nothr/.

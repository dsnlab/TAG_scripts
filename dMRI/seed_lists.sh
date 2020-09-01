#!/bin/bash

# Load FSL
module load fsl/5.0.10
module load cuda/8.0

# Set directory names
datadir="/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc"
scriptsdir="/projects/dsnlab/shared/tag/TAG_scripts/dMRI"
outputdir="/projects/dsnlab/shared/tag/nonbids_data/dMRI"

# Set error log file
errorlog=""$scriptsdir"/errorlog_svc_seed_lists.txt"

# Create error log file
touch "${errorlog}"

# Creating SVC Mask Lists
cd "$outputdir"/"${subid}"/ses-wave1/masks/

echo ""$outputdir"/"${subid}"/ses-wave1/masks/mpfc_mask_svc.nii.gz" >> mpfc.txt
echo ""$outputdir"/"${subid}"/ses-wave1/masks/pcc_mask_svc.nii.gz" >> pcc.txt
echo ""$outputdir"/"${subid}"/ses-wave1/masks/lacc_mask_svc.nii.gz" >> lacc.txt
echo ""$outputdir"/"${subid}"/ses-wave1/masks/rtpj_mask_svc.nii.gz" >> rtpj.txt
echo ""$outputdir"/"${subid}"/ses-wave1/masks/lthal_mask_svc.nii.gz" >> lthal.txt

cat mpfc.txt lacc.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_mpfc_lacc.txt
cat mpfc.txt pcc.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_mpfc_pcc.txt
cat mpfc.txt rtpj.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_mpfc_rtpj.txt
cat mpfc.txt lthal.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_mpfc_lthal.txt

cat pcc.txt lacc.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_pcc_lacc.txt
cat pcc.txt rtpj.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_pcc_rtpj.txt
cat pcc.txt lthal.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_pcc_lthal.txt

cat lacc.txt rtpj.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_lacc_rtpj.txt
cat lacc.txt lthal.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_lacc_lthal.txt

cat rtpj.txt lthal.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_rtpj_lthal.txt

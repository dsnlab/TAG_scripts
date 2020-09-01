#!/bin/bash

# Load FSL
module load fsl/5.0.10
module load cuda/8.0

# Set directory names
datadir="/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc"
scriptsdir="/projects/dsnlab/shared/tag/TAG_scripts/dMRI"
outputdir="/projects/dsnlab/shared/tag/nonbids_data/dMRI"

# Set error log file
errorlog=""$scriptsdir"/errorlog_probtrackXsvc_thal.txt"

# Create error log file
touch "${errorlog}"

# Creating SVC Mask Lists
cd "$outputdir"/"${subid}"/ses-wave1/masks/
echo ""$outputdir"/"${subid}"/ses-wave1/masks/lthal_mask_svc.nii.gz" >> lthal.txt
cat mpfc.txt lthal.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_mpfc_lthal.txt
cat pcc.txt lthal.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_pcc_lthal.txt
cat lacc.txt lthal.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_lacc_lthal.txt
cat rtpj.txt lthal.txt > "$outputdir"/"${subid}"/ses-wave1/masks/svc_rtpj_lthal.txt

# Making tractography directories
echo making "${subid}" thalamus tractography directories
cd "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX

mkdir -p mpfcSVC_to_lthalSVC
cp ../masks/svc_mpfc_lthal.txt mpfcSVC_to_lthalSVC/masks.txt

mkdir -p pccSVC_to_lthalSVC
cp ../masks/svc_pcc_lthal.txt pccSVC_to_lthalSVC/masks.txt

mkdir -p laccSVC_to_lthalSVC
cp ../masks/svc_lacc_lthal.txt laccSVC_to_lthalSVC/masks.txt

mkdir -p rtpjSVC_to_lthalSVC
cp ../masks/svc_rtpj_lthal.txt rtpjSVC_to_lthalSVC/masks.txt

# Performing mPFC to lThal tractography
echo performing mPFC-to-lThal tractography on "${subid}"
cd mpfcSVC_to_lthalSVC
/packages/fsl/5.0.10/install/bin/probtrackx2 --network -x "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/mpfcSVC_to_lthalSVC/masks.txt  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --xfm="${outputdir}"/"${subid}"/ses-wave1/anat/reg/struct2FA.mat --forcedir --opd -s "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/./merged -m "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/./nodif_brain_mask  --dir="${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/mpfcSVC_to_lthalSVC

# Performing PCC to lThal tractography
echo performing PCC-to-lThal tractography on "${subid}"
cd ../pccSVC_to_lthalSVC
/packages/fsl/5.0.10/install/bin/probtrackx2 --network -x "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/pccSVC_to_lthalSVC/masks.txt  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --xfm="${outputdir}"/"${subid}"/ses-wave1/anat/reg/struct2FA.mat --forcedir --opd -s "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/./merged -m "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/./nodif_brain_mask  --dir="${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/pccSVC_to_lthalSVC

# Performing lAcc to lThal tractography
echo performing lAcc-to-lThal tractography on "${subid}"
cd ../laccSVC_to_lthalSVC
/packages/fsl/5.0.10/install/bin/probtrackx2 --network -x "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/laccSVC_to_lthalSVC/masks.txt  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --xfm="${outputdir}"/"${subid}"/ses-wave1/anat/reg/struct2FA.mat --forcedir --opd -s "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/./merged -m "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/./nodif_brain_mask  --dir="${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/laccSVC_to_lthalSVC

# Performing rTPJ to lThal tractography
echo performing rTPJ-to-lThal tractography on "${subid}"
cd ../rtpjSVC_to_lthalSVC
/packages/fsl/5.0.10/install/bin/probtrackx2 --network -x "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/rtpjSVC_to_lthalSVC/masks.txt  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --xfm="${outputdir}"/"${subid}"/ses-wave1/anat/reg/struct2FA.mat --forcedir --opd -s "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/./merged -m "${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/./nodif_brain_mask  --dir="${outputdir}"/"${subid}"/ses-wave1/dwi.fit.bedpostX/rtpjSVC_to_lthalSVC

#!/bin/bash

# Load FSL
module load fsl/5.0.10
module load cuda/8.0

# Set directory names
datadir="/projects/dsnlab/shared/tag/bids_data"
scriptsdir="/projects/dsnlab/shared/tag/TAG_scripts/dMRI"
outputdir="/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc"

# Set error log file
errorlog=""$scriptsdir"/errorlog_probtrackXnetwork.txt"

# Create error log file
touch "${errorlog}"

# Create target mask list in subject's directory
cp "$scriptsdir"/connect_seeds_gmwm.txt "$outputdir"/"${subid}"/ses-wave1/anat/label/connect_seeds_gmwm.txt

# Performing tractography once per seed region
probtrackx2 --samples="$outputdir"/"${subid}"/ses-wave1/dwi.fit.bedpostX/merged --mask="$outputdir"/"${subid}"/ses-wave1/dwi.fit.bedpostX/nodif_brain_mask.nii.gz --seed="$scriptsdir"/connect_seeds_gmwm.txt --loopcheck --os2t --s2tastext --omatrix1 --distthresh=0.0 --xfm="$outputdir"/"${subid}"/ses-wave1/dwi.fit.bedpostX/xfms/fs2fa.mat --invxfm="$outputdir"/"${subid}"/ses-wave1/dwi.fit.bedpostX/xfms/fa2fs.mat --avoid="$outputdir"/"${subid}"/ses-wave1/anat/ventricles.nii.gz --seedref="$outputdir"/"${subid}"/ses-wave1/anat/fs.nii.gz --opd --network --targetmasks="$scriptsdir"/connect_seeds_gmwm.txt --otargetpaths --dir="$outputdir"/"${subid}"/ses-wave1/dwi.fit.bedpostX/matrix1plustarget_otargetpaths2"${seedmask}"

#output for this command is labelled matrix1
#probtrackx2 --samples=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/merged --mask=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/nodif_brain_mask.nii.gz --seed=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/anat/label/connectseeds.txt --loopcheck --omatrix1 --distthresh=0.0 --xfm=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/xfms/fs2fa.mat --invxfm=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/xfms/fa2fs.mat --avoid=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/anat/ventricles.nii.gz --seedref=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/anat/fs.nii.gz --opd --network --dir=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/matrix1

#output for this command is labelled matrix1plustarget (includes seed-to-target)
#probtrackx2 --samples=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/merged --mask=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/nodif_brain_mask.nii.gz --seed=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/anat/label/connectseeds.txt --loopcheck --os2t --s2tastext --omatrix1 --distthresh=0.0 --xfm=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/xfms/fs2fa.mat --invxfm=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/xfms/fa2fs.mat --avoid=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/anat/ventricles.nii.gz --seedref=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/anat/fs.nii.gz --opd --network --targetmasks=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/anat/label/connectseeds.txt --dir=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/matrix1plustarget

#output for this command is labelled matrix1plustarget_otargetpaths (includes seed-to-target)
##probtrackx2 --samples=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/dwi.bedpostX/merged --mask=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/dwi.bedpostX/nodif_brain_mask.nii.gz --seed=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/anat/label/connectseeds.txt --loopcheck --os2t --s2tastext --omatrix1 --distthresh=0.0 --xfm=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/dwi.bedpostX/xfms/fs2fa.mat --invxfm=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/dwi.bedpostX/xfms/fa2fs.mat --avoid=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/anat/ventricles.nii.gz --seedref=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/anat/fs.nii.gz --opd --network --targetmasks=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/anat/label/connectseeds.txt --otargetpaths --dir=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/dwi.bedpostX/matrix1plustarget_otargetpaths

#output for this command is labelled matrix1plustarget_savepaths (includes seed-to-target)
#probtrackx2 --samples=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/dwi.bedpostX/merged --mask=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/dwi.bedpostX/nodif_brain_mask.nii.gz --seed=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/anat/label/connectseeds.txt --loopcheck --os2t --s2tastext --omatrix1 --distthresh=0.0 --xfm=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/dwi.bedpostX/xfms/fs2fa.mat --invxfm=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/dwi.bedpostX/xfms/fa2fs.mat --avoid=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/anat/ventricles.nii.gz --seedref=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/anat/fs.nii.gz --opd --network --targetmasks=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/anat/label/connectseeds.txt --savepaths --dir=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc_noSlice2Vol/TAG001/ses-wave1/dwi.bedpostX/matrix1plustarget_savepaths


#output for this command is labelled networktest

#probtrackx2 --samples=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/merged --mask=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/nodif_brain_mask.nii.gz --seed=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/anat/label/connectseeds.txt --target4=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/nodif_brain_mask.nii.gz --dir=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/networktest --network --opd --omatrix1 --omatrix4 --xfm=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/xfms/fs2fa.mat --invxfm=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/dwi.bedpostX/xfms/fa2fs.mat --seedref=/projects/dsnlab/shared/tag/bids_data/derivatives/dMRI_preproc/TAG001/ses-wave1/anat/fs.nii.gz --loopcheck




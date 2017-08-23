#!/bin/bash
#
# This script will convert your directory structure
# with already dicom mcverted images (gzipped niftis)
# to BIDS specification - TC
#
# Usage: parallel --verbose --results output/{}_convertBIDS_output -j4 ./convert_bids_TAG.sh :::: sublist.txt

# Set folder names
dicomsubid=$1
dicomdir=$(echo "/Volumes/psych-cog/dsnlab/TAG/DICOMS/${dicomsubid}"*)
inputdir="/Volumes/psych-cog/dsnlab/TAG/clean_nii"
outputdir="/Volumes/psych-cog/dsnlab/TAG/clean_nii/BIDS"

# Set study info
studyid="TAG"
sessid="wave1"
subid="$(echo $1 | head -c 6)"
cpflags="-n -v"
declare -a rest_numruns=("01" "02") 

echo -e "\nConverting anatomical mprage into nifti"
cd "$inputdir"
mkdir "${subid}"
cd "$inputdir"/"${subid}"
mkdir anat
anatomicaloutput="$inputdir/${subid}/anat"
mcverter -o "$anatomicaloutput"/ --format=nifti --nii --match=mprage -F -PatientName-PatientId-SeriesDate-SeriesTime-StudyId-StudyDescription-SeriesNumber-SequenceName-ProtocolName+SeriesDescription $dicomdir
cd "$inputdir"/"${subid}"/anat
gzip -f *.nii


echo -e "\nConverting resting state into 4D nifti"
cd "$inputdir"/"${subid}"
mkdir resting
restingoutput="$inputdir/${subid}/resting"
mcverter -o "$restingoutput"/ --format=nifti --nii --fourd --match=Resting -F -PatientName-PatientId-SeriesDate-SeriesTime-StudyId-StudyDescription-SeriesNumber-SequenceName-ProtocolName+SeriesDescription $dicomdir
cd "$inputdir"/"${subid}"/resting
gzip -f *.nii
cd "$inputdir"

# create directory structure for one subject
mkdir -pv "$outputdir"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"
cd "$outputdir"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"
mkdir -v anat
mkdir -v func

# move files and generate corresponding jsons

# structural (mprage)
cp ${cpflags} "$inputdir"/"${subid}"/anat/*p2.nii.gz "$outputdir"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/anat/sub-"${subid}"_ses-"${sessid}"_T1w.nii.gz
cp ${cpflags} "$inputdir"/TAGanat.json "$outputdir"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/anat/sub-"${subid}"_ses-"${sessid}"_T1w.json

# resting state 
for i in ${rest_numruns[@]}
	do 
	echo $i
	j="$(echo $i | tail -c 2)"
		cp ${cpflags} "$inputdir"/"${subid}"/resting/*_"$j".nii.gz  "$outputdir"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_task-rest_run-"$i"_bold.nii.gz
		cp -v "$inputdir"/TAGrest.json "$outputdir"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_task-rest_run-"$i"_bold.json
done
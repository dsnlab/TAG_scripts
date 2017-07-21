#!/bin/bash

# This script will convert dicoms, create the BIDS files structure,
# and move and rename converted files to BIDS specification
#
# It will also check the number of files and print errors to the error log
#
# Dependencies:
# * edited convert_bids_config.sh
# * $subid from batch_convert_bids.sh


# Load mcverter
module load MRIConvert 

# Load variables
source convert_bids_config.sh
echo "${subid}"

# Create error log file
touch "${errorlog}"

# Check directory dependencies
if [ ! -d "${archivedir}" ]; then
	mkdir -v "${archivedir}"
fi

if [ ! -d "${niidir}" ]; then
	mkdir -v "${niidir}"
fi

if [ ! -d "${bidsdir}" ]; then
	mkdir -v "${bidsdir}"
fi

if [ ! -d "${bidsdir}"/derivatives ]; then
	mkdir -v "${bidsdir}"/derivatives
fi

# Convert dicoms to niftis
cd "$niidir"
mkdir "${subid}"
cd "$niidir"/"${subid}"

if [ "${convertanat}" == "TRUE" ]; then
	echo -e "\nConverting anatomical mprage into nifti"
	mkdir anat
	anatomicaloutput="$niidir/${subid}/anat"
	mcverter -o "$anatomicaloutput"/ --format=nifti --nii --match="${anat}" -F -PatientName-PatientId-SeriesDate-SeriesTime-StudyId-StudyDescription+SeriesNumber-SequenceName-ProtocolName+SeriesDescription $dicomdir
	cd "$anatomicaloutput"
	du -sh *.nii
	gzip -f *.nii
fi

if [ "${convertfmap}" == "TRUE" ]; then
	echo -e "\nConverting fieldmaps into niftis"
	cd "$niidir"/"${subid}"
	mkdir fmap
	fmapoutput="$niidir/${subid}/fmap"
	mcverter -o "$fmapoutput"/ --format=nifti --nii --match="${fmap}" -F -PatientName-PatientId-SeriesDate-SeriesTime-StudyId-StudyDescription+SeriesNumber-SequenceName-ProtocolName+SeriesDescription $dicomdir
	cd "$fmapoutput"
	du -sh *.nii
	gzip -f *.nii
fi

if [ "${convertdti}" == "TRUE" ]; then
	echo -e "\nConverting DTI into 4D nifti"
	cd "$niidir"/"${subid}"
	mkdir dti
	dtioutput="$niidir/${subid}/dti"
	mcverter -o "$dtioutput"/ --format=nifti --nii --fourd --match="${dti}" -F -PatientName-PatientId-SeriesDate-SeriesTime-StudyId-StudyDescription+SeriesNumber-SequenceName-ProtocolName+SeriesDescription $dicomdir
	cd "$dtioutput"
	du -sh *.nii
	gzip -f *.nii
fi

if [ "${convertrest}" == "TRUE" ]; then
	echo -e "\nConverting resting state into 4D niftis"
	cd "$niidir"/"${subid}"
	mkdir resting
	restingoutput="$niidir/${subid}/resting"
	for rest in ${resting[@]}; do 
		mcverter -o "$restingoutput"/ --format=nifti --nii --fourd --match="${rest}" -F -PatientName-PatientId-SeriesDate-SeriesTime-StudyId-StudyDescription+SeriesNumber-SequenceName-ProtocolName+SeriesDescription $dicomdir
	done
	cd "$restingoutput"
	du -sh *.nii
	gzip -f *.nii
fi

if [ "${converttask}" == "TRUE" ]; then
	echo -e "\nConverting fMRI task data into 4D niftis"
	cd "$niidir"/"${subid}"
	mkdir task
	taskoutput="$niidir/${subid}/task"
	for task in ${tasks[@]}; do
		mcverter -o "$taskoutput"/ --format=nifti --nii --fourd --match=${task} -F -PatientName-PatientId-SeriesDate-SeriesTime-StudyId-StudyDescription+SeriesNumber-SequenceName-ProtocolName+SeriesDescription $dicomdir
	done
	cd "$taskoutput"
	du -sh *.nii
	gzip -f *.nii
fi

# Create bids directory structure for one subject
echo -e "\nCreating directory stucture"
mkdir -pv "$bidsdir"/sub-"${subid}"/ses-"${sessid}"
cd "$bidsdir"/sub-"${subid}"/ses-"${sessid}"
if [ "${convertanat}" == "TRUE" ]; then mkdir -v anat; fi
if [ "${convertfmap}" == "TRUE" ]; then mkdir -v fmap; fi
if [ "${convertdti}" == "TRUE" ]; then mkdir -v dwi; fi
if [ "${converttask}" == "TRUE" ]; then mkdir -v func; fi

# Copy and rename files to BIDS structure
# structural (mprage)
if [ "${convertanat}" == "TRUE" ]; then
	echo -e "\nCopying structural"
	if [ $(ls "$anatomicaloutput"/*"${anat}".nii.gz | wc -l) -eq 1 ]; then
		cp ${cpflags} "$anatomicaloutput"/*"${anat}".nii.gz "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/anat/sub-"${subid}"_ses-"${sessid}"_T1w.nii.gz
	else 
		# print file paths in errorlog.txt if =~ 1 file; copy both files
		echo "ERROR: wrong number of files; all files copied"
		ls "$anatomicaloutput"/*"${anat}".nii.gz >> $errorlog
		t1w1=$(ls "$anatomicaloutput"/*"${anat}".nii.gz | head -1)
		t1w2=$(ls "$anatomicaloutput"/*"${anat}".nii.gz | tail -1)
		cp ${cpflags} "${tw1}" "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/anat/sub-"${subid}"_ses-"${sessid}"_run-01_T1w.nii.gz
		cp ${cpflags} "${tw2}" "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/anat/sub-"${subid}"_ses-"${sessid}"_run-02_T1w.nii.gz
	fi
fi

# fieldmaps
if [ "${convertfmap}" == "TRUE" ]; then
	echo -e "\nCopying fieldmaps"
	if [ "${fieldmapEPI}" == "TRUE" ]; then
		ap=$(ls -f "$fmapoutput"/*_ap.nii.gz | head -1)
		pa=$(ls -f "$fmapoutput"/*_pa.nii.gz | head -1)
		cp ${cpflags} "${ap}"  "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/fmap/sub-"${subid}"_ses-"${sessid}"_dir-ap_epi.nii.gz
		cp ${cpflags} "${pa}"  "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/fmap/sub-"${subid}"_ses-"${sessid}"_dir-pa_epi.nii.gz
		
		# print file paths in errorlog.txt if > 2 files
		if [ $(ls "$fmapoutput"/*_ap.nii.gz | wc -l) -gt 2 ]; then
			echo "ERROR: wrong number of files"
			ls "$fmapoutput"/*_ap.nii.gz >> $errorlog
		fi
	else
		phase=$(ls -f "$fmapoutput"/*"${fmap}".nii.gz)
		mag1=$(ls -f "$fmapoutput"/*"${fmap}"_01.nii.gz)
		mag2=$(ls -f "$fmapoutput"/*"${fmap}"_02.nii.gz)
		cp ${cpflags} "${phase}"  "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/fmap/sub-"${subid}"_ses-"${sessid}"_phasediff.nii.gz
		cp ${cpflags} "${mag1}"  "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/fmap/sub-"${subid}"_ses-"${sessid}"_magnitude1.nii.gz
		cp ${cpflags} "${mag2}"  "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/fmap/sub-"${subid}"_ses-"${sessid}"_magnitude2.nii.gz

		# print file paths in errorlog.txt if > 3 files
		if [ $(ls "$fmapoutput"/*"${fmap}"*.gz | wc -l) -gt 3 ]; then
			echo "ERROR: wrong number of files"
			ls "$fmapoutput"/*"${fmap}"*.gz >> $errorlog
		fi
	fi
fi

# DTI 
if [ "${convertdti}" == "TRUE" ]; then
	echo -e "\nCopying DTI"
	if [ $(ls "$dtioutput"/*"${dti}"*.nii.gz | wc -l) -eq 2 ]; then
		cp ${cpflags} "$dtioutput"/*"${dti}"*rl.nii.gz "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/dwi/sub-"${subid}"_ses-"${sessid}"_dir-rl_dwi.nii.gz
		cp ${cpflags} "$dtioutput"/*"${dti}"*lr.nii.gz "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/dwi/sub-"${subid}"_ses-"${sessid}"_dir-lr_dwi.nii.gz
	else
		# print file paths in errorlog.txt if =~ 2 files; do not copy file
		echo "ERROR: wrong number of files; files not copied"
		ls "$dtioutput"/*"${dti}"*.nii.gz >> $errorlog
	fi
fi

# resting state 
if [ "${convertrest}" == "TRUE" ]; then
	echo -e "\nCopying resting state"
	for rest in ${resting[@]}; do 
		if [ $(ls "$restingoutput"/*"${rest}".nii.gz | wc -l) -eq 1 ]; then
			runnum="$(echo "${rest}" | tail -c 2)"
			cp ${cpflags} "$restingoutput"/*"${rest}".nii.gz  "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_task-rest_run-0"${runnum}"_bold.nii.gz
		else
			# print file paths in errorlog.txt if =~ 1 files; do not copy file
			echo "ERROR: wrong number of files; files not copied"
			ls "$restingoutput"/*"${rest}".nii.gz >> $errorlog
		fi
	done
fi

# fMRI task data
if [ "${converttask}" == "TRUE" ]; then
	echo -e "\nCopying task fMRI"
	for task in ${tasks[@]}; do 
		runnum="$(echo "${task}" | tail -c 2)"
		if [ $(ls "$taskoutput"/*"${task}"*.nii.gz | wc -l) -eq 1 ]; then
			if [[ $runnum =~ ^[0-9]+$ ]]; then 
				cp ${cpflags} "$taskoutput"/*"${task}"*.nii.gz "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_task-"${task}"_run-0"${runnum}"_bold.nii.gz
			else
				cp ${cpflags} "$taskoutput"/*"${task}"*.nii.gz "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_task-"${task}"_run-01_bold.nii.gz
			fi
		else
			# print file paths in errorlog.txt if =~ 1 files; copy the largest file
			echo "ERROR: wrong number of files; largest file copied"
			ls "$taskoutput"/*"${task}"*.nii.gz >> $errorlog
			largestfile=$(du -sh "$taskoutput"/*"${task}"*.nii.gz | sort -n | tail -1 | cut -f2)
			if [[ $runnum =~ ^[0-9]+$ ]]; then 
				cp ${cpflags} "${largestfile}" "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_task-"${task}"_run-0"${runnum}"_bold.nii.gz
			else
				cp ${cpflags} "${largestfile}" "$bidsdir"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_task-"${task}"_run-01_bold.nii.gz
			fi
		fi
	done
fi
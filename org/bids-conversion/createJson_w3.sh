#!/bin/bash

# This script will compare the group-level Json parameters (from the scan protocol) to those of each subject. 
# It will create subject-specific Json file if parameters differ from that of the group.
#
# Dependencies:
# * edited createJson_config.sh
# * $subid from batch_createJson.sh

# Load variables
source /projects/dsnlab/shared/tag/TAG_scripts/org/bids-conversion/createJson_config.sh
echo "${subid}"
echo "${sessid}"

#Load packages
module load prl afni

# Create error log file
touch "${errorlog}"
touch "${newlog}"




# fieldmap
if [ "${convertfmap}" == "TRUE" ]; then
	echo -e "\nChecking fieldmap"

	# Set group Json info
	cd $bidsdir
	groupfile=phasediff.json
	EchoTime1=$(ls | grep 'EchoTime1' $groupfile | sed 's/^.*: //' | sed 's/,$//')
	EchoTime2=$(ls | grep 'EchoTime2' $groupfile | sed 's/^.*: //' | sed 's/,$//')

	#Check subject Json info and create seperate file if different
	cd $niidir/$subid/${sessid}/fmap

	if [ $(ls *"${fmap}"*info.txt | wc -l) -eq 2 ]; then
		file=$(find *info.txt -type f | xargs ls -1S | head -n 1)               
		EchoTime1_x=$(echo "scale=5; ($(ls | grep 'Echo time\[[1]*\]' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.5f", $0}')
        	EchoTime2_x=$(echo "scale=5; ($(ls | grep 'Echo time\[[2]*\]' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.5f", $0}')
		
		if [ "$EchoTime1" == "$EchoTime1_x" ] && [ "$EchoTime2" == "$EchoTime2_x" ]; then
                	echo "OK"
			cd $bidsdir/sub-$subid/ses-$sessid/fmap
			filename="sub-"$subid"_ses-"$sessid"_phasediff.json"
			rm "$filename"
			touch "$filename"
			echo -e "{\n\t\"EchoTime1\": $EchoTime1_x,\n\t\"EchoTime2\": $EchoTime2_x,\n\t\"IntendedFor\": [ " >> "$filename"
			for task in ${tasks[@]}; do
				runnum="$(echo "${task}" | sed 's/[^0-9]//g')"
		                taskalpha="$(echo "${task}" | sed 's/[^a-zA-Z]//g')"
				echo  -e "\t\t\"ses-"$sessid"/func/sub-"$subid"_ses-"$sessid"_task-"$taskalpha"_run-0"$runnum"_bold.nii.gz\"," >> "$filename"
			done
			sed '$ s/.$/ ] }/' $filename >> tempfile
			mv tempfile $filename	
		else 
            		echo "not OK"
			ls "$filename" >> $newlog
			cd $bidsdir/sub-$subid/ses-$sessid/fmap/
            		filename="sub-"$subid"_ses-"$sessid"_phasediff.json"
            		rm "$filename"
            		touch "$filename"
			echo -e "{\n\t\"EchoTime1\": $EchoTime1_x,\n\t\"EchoTime2\": $EchoTime2_x,\n\t\"IntendedFor\": [ " >> "$filename"
			for task in ${tasks[@]}; do
				runnum="$(echo "${task}" | sed 's/[^0-9]//g')"
                		taskalpha="$(echo "${task}" | sed 's/[^a-zA-Z]//g')"
				echo  -e "\t\t\"ses-"$sessid"/func/sub-"$subid"_ses-"$sessid"_task-"$taskalpha"_run-0"$runnum"_bold.nii.gz\"," >> "$filename"
			done
			sed -i '' '$ s/.$/ ] }/' $filename >> tempfile        
                        mv tempfile $filename	
        	fi
	elif [ $(ls *"${fmap}"*info.txt | wc -l) -gt 2 ]; then
		echo "ERROR: wrong number of files"
                echo "${subid} ${sessid}: Wrong number of ${fmap}" >> $errorlog
	else
		echo "ERROR: no files; nothing to use"
		echo "${subid} ${sessid}: MISSING ${fmap}" >> $errorlog
	fi
fi

echo -e "\nCOMPLETED"

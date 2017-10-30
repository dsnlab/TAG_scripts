#!/bin/bash

# This script will compare the group-level Json parameters (from the scan protocol) to those of each subject. 
# It will create subject-specific Json file if parameters differ from that of the group.
#
# Dependencies:
# * edited createJson_config.sh
# * $subid from batch_createJson.sh

# Load variables
source createJson_config.sh
echo "${subid}"

# Create error log file
touch "${errorlog}"

# Check subject parameters match group parameters and create seperate Json file within each subject directory if different
# anat
if [ "${convertanat}" == "TRUE" ]; then
	echo -e "\nChecking anat"

	# Set group Json info
	cd $bidsdir
	groupfile=T1w.json
	RepetitionTime=$(ls -l| grep 'RepetitionTime' $groupfile | sed 's/^.*: //' | sed 's/,$//') 
	EchoTime=$(ls | grep 'EchoTime' $groupfile | sed 's/^.*: //' | sed 's/,$//')
	FlipAngle=$(ls | grep 'FlipAngle' $groupfile | sed 's/^.*: //' | sed 's/,$//')
	InversionTime=$(ls | grep 'InversionTime' $groupfile | sed 's/^.*: //' | sed 's/,$//')

	#Check subject Json info and create seperate file if different
	cd $niidir/$subid/task
	file=*_info.txt
	RepetitionTime_x=$(echo "($(ls -l| grep 'Repetition time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.1f", $0}')
    EchoTime_x=$(echo "($(ls -l| grep 'Echo time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.5f", $0}')
    FlipAngle_x=$(ls | grep 'Flip angle' $file | sed 's/^.*: //' | awk '{printf "%.0f", $0}')
    InversionTime_x=$(echo "($(ls -l| grep 'Inversion time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.5f", $0}')

	if [ "$RepetitionTime" == "$RepetitionTime_x" ] && [ "$EchoTime" == "$EchoTime_x" ] && [ "$FlipAngle" == "$FlipAngle_x" ] && [ "$InversionTime" == "$InversionTime_x" ]
	then
	    echo "$subid OK"
	else 
	    cd $bidsdir/sub-$subid/ses-$sessid/anat/
	    filename="sub-"$subid"_ses-"$sessid"_T1w.json"
	    echo -e "{\n\t\"RepetitionTime\": $RepetitionTime_x,\n\t\"EchoTime\": $EchoTime_x,\n\t\"FlipAngle\": $FlipAngle_x,\n\t\"InversionTime\": $InversionTime_x,\n}" >> "$filename" 
	    ls "$filename" >> $errorlog
	fi
fi

# rest fMRI 
if [ "${convertrest}" == "TRUE" ]; then
	echo -e "\nChecking rest"

	for rest in ${resting[@]}; do 
		runnum="$(echo "${rest}" | sed 's/[^0-9]//g')"
		taskalpha="rest"

		# Set group Json info
		cd $bidsdir
		groupfile=*"$taskalpha"_bold.json
		TaskName=$(ls -l| grep 'TaskName' $groupfile | sed 's/^.*: //' | sed 's/,$//') 
		RepetitionTime=$(ls -l| grep 'RepetitionTime' $groupfile | sed 's/^.*: //' | sed 's/,$//') 
		EchoTime=$(ls | grep 'EchoTime' $groupfile | sed 's/^.*: //' | sed 's/,$//')
		FlipAngle=$(ls | grep 'FlipAngle' $groupfile | sed 's/^.*: //' | sed 's/,$//')
		MultibandAccelerationFactor=$(ls | grep 'MultibandAccelerationFactor' $groupfile | sed 's/^.*: //' | sed 's/,$//')
		PhaseEncodingDirection=$(ls | grep 'PhaseEncodingDirection' $groupfile | sed 's/^.*: //' | sed 's/,$//' | tr -d '"')
		EffectiveEchoSpacing=$(ls | grep 'EffectiveEchoSpacing' $groupfile | sed 's/^.*: //' | sed 's/,$//')

		#Check subject Json info and create seperate file if different
		cd $niidir/$subid/task
		file=$(echo "$(ls | grep $rest | grep 'info')")
		RepetitionTime_x=$(echo "($(ls -l| grep 'Repetition time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.0f", $0}')
    	EchoTime_x=$(echo "($(ls -l| grep 'Echo time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.3f", $0}')
    	FlipAngle_x=$(ls | grep 'Flip angle' $file | sed 's/^.*: //' | awk '{printf "%.0f", $0}')
    	MultibandAccelerationFactor_x=$(ls | grep 'Acceleration factor' $file | sed 's/^.*: //')
    	EffectiveEchoSpacing_x=$(echo "($(ls -l| grep 'Effective echo spacing' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.5f", $0}')

		cd $bidsdir 
    	file=test_out.csv
    	fileSTRING="sub-"$subid"_ses-"$sessid"_task-rest_run-0"$runnum"_bold.nii.gz"
    	PED=$(ls | grep "$fileSTRING" $file | sed -n 's/^.*nii.gz,[[:space:]]*//p')

    			if [[ "$PhaseEncoding_task" == 1a ]]; then 
					x="A" 
					y="P"
				elif [[ "$PhaseEncoding_task" == 1b ]]; then 
					x="P" 
					y="A"
				elif [[ "$PhaseEncoding_task" == 2a ]]; then 
					x="I" 
					y="S"
				elif [[ "$PhaseEncoding_task" == 2b ]]; then 
					x="S" 
					y="I"
				elif [[ "$PhaseEncoding_task" == 3a ]]; then 
					x="R" 
					y="L"
				elif [[ "$PhaseEncoding_task" == 3b ]]; then 
					x="L" 
					y="R"
				fi

    			if [[ $PED == ?$x? ]]; then
    				PhaseEncodingDirection_x="j"
    			else if [[ $PED == ?$y? ]]; then
    				PhaseEncodingDirection_x="-j"
    			else if [[ $PED == $x?? ]]; then
    				PhaseEncodingDirection_x="i"
				else if [[ $PED == $y?? ]]; then
    				PhaseEncodingDirection_x="-i"
    			else if [[ $PED == ??$x ]]; then
    				PhaseEncodingDirection_x="k"
				else if [[ $PED == ??$y ]]; then
    				PhaseEncodingDirection_x="-k"
    			fi

		if [ "$RepetitionTime" == "$RepetitionTime_x" ] && [ "$EchoTime" == "$EchoTime_x" ] && [ "$FlipAngle" == "$FlipAngle_x" ] && 
			[ "$EffectiveEchoSpacing" == "$EffectiveEchoSpacing_x" ] && [ "$PhaseEncodingDirection" == "$PhaseEncodingDirection_x"] && [ "MultibandAccelerationFactor" == "MultibandAccelerationFactor_x" ];
		then
	   		echo "$subid OK"
		else 
	    	cd $bidsdir/sub-$subid/ses-$sessid/func/
	    	filename="sub-"$subid"_ses-"$sessid"_task-rest_run-0"$runnum"_bold.json"
	    	echo -e "{\n\t\"TaskName\": \"rest\",\n\t\"RepetitionTime\": $RepetitionTime_x,\n\t\"EchoTime\": $EchoTime_x,\n\t\"FlipAngle\": $FlipAngle_x,\n\t\"MultibandAccelerationFactor\": $MultibandAccelerationFactor_x,\n\t\"PhaseEncodingDirection\": \"$PhaseEncodingDirection_x\",\n\t\"EffectiveEchoSpacing\": $EffectiveEchoSpacing_x\n}" >> "$filename" 
	    	ls "$filename" >> $errorlog
	    	fi
	done

fi

# task fMRI 
if [ "${converttask}" == "TRUE" ]; then
	echo -e "\nChecking task fMRI"
	for task in ${tasks[@]}; do 
		runnum="$(echo "${task}" | sed 's/[^0-9]//g')"
		taskalpha="$(echo "${task}" | sed 's/[^a-zA-Z]//g')"

		# Set group Json info
		cd $bidsdir
		groupfile=*"$taskalpha"_bold.json
		RepetitionTime=$(ls -l| grep 'RepetitionTime' $groupfile | sed 's/^.*: //' | sed 's/,$//') 
		EchoTime=$(ls | grep 'EchoTime' $groupfile | sed 's/^.*: //' | sed 's/,$//')
		FlipAngle=$(ls | grep 'FlipAngle' $groupfile | sed 's/^.*: //' | sed 's/,$//')
		MultibandAccelerationFactor=$(ls | grep 'MultibandAccelerationFactor' $groupfile | sed 's/^.*: //' | sed 's/,$//')
		PhaseEncodingDirection=$(ls | grep 'PhaseEncodingDirection' $groupfile | sed 's/^.*: //' | sed 's/,$//' | tr -d '"')
		EffectiveEchoSpacing=$(ls | grep 'EffectiveEchoSpacing' $groupfile | sed 's/^.*: //' | sed 's/,$//')

		#Check subject Json info and create seperate file if different
		cd $niidir/$subid/task
		file=$(echo "$(ls | grep $task | grep 'info')")
		RepetitionTime_x=$(echo "($(ls -l| grep 'Repetition time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.0f", $0}')
    	EchoTime_x=$(echo "($(ls -l| grep 'Echo time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.3f", $0}')
    	FlipAngle_x=$(ls | grep 'Flip angle' $file | sed 's/^.*: //' | awk '{printf "%.0f", $0}')
    	MultibandAccelerationFactor_x=$(ls | grep 'Acceleration factor' $file | sed 's/^.*: //')
    	EffectiveEchoSpacing_x=$(echo "($(ls -l| grep 'Effective echo spacing' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.5f", $0}')

    	cd $bidsdir 
    	file=test_out.csv
    	fileSTRING="sub-"$subid"_ses-"$sessid"_task-"$taskalpha"_run-0"$runnum"_bold.nii.gz"
    	PED=$(ls | grep "$fileSTRING" $file | sed -n 's/^.*nii.gz,[[:space:]]*//p')

    			if [[ "$PhaseEncoding_task" == 1a ]]; then 
					x="A" 
					y="P"
				elif [[ "$PhaseEncoding_task" == 1b ]]; then 
					x="P" 
					y="A"
				elif [[ "$PhaseEncoding_task" == 2a ]]; then 
					x="I" 
					y="S"
				elif [[ "$PhaseEncoding_task" == 2b ]]; then 
					x="S" 
					y="I"
				elif [[ "$PhaseEncoding_task" == 3a ]]; then 
					x="R" 
					y="L"
				elif [[ "$PhaseEncoding_task" == 3b ]]; then 
					x="L" 
					y="R"
				fi

    			if [[ $PED == ?$x? ]]; then
    				PhaseEncodingDirection_x="j"
    			else if [[ $PED == ?$y? ]]; then
    				PhaseEncodingDirection_x="-j"
    			else if [[ $PED == $x?? ]]; then
    				PhaseEncodingDirection_x="i"
				else if [[ $PED == $y?? ]]; then
    				PhaseEncodingDirection_x="-i"
    			else if [[ $PED == ??$x ]]; then
    				PhaseEncodingDirection_x="k"
				else if [[ $PED == ??$y ]]; then
    				PhaseEncodingDirection_x="-k"
    			fi

		if [ "$RepetitionTime" == "$RepetitionTime_x" ] && [ "$EchoTime" == "$EchoTime_x" ] && [ "$FlipAngle" == "$FlipAngle_x" ] && [ "$EffectiveEchoSpacing" == "$EffectiveEchoSpacing_x" ] && [ "$PhaseEncodingDirection" == "$PhaseEncodingDirection_x"];
		then
	    	echo "$subid OK"
	    else 
	        cd $bidsdir/sub-$subid/ses-$sessid/func/
	        filename="sub-"$subid"_ses-"$sessid"_task-"$taskalpha"_run-0"$runnum"_bold.json"
	        echo -e "{\n\t\"TaskName\": \"$taskalpha\",\n\t\"RepetitionTime\": $RepetitionTime_x,\n\t\"EchoTime\": $EchoTime_x,\n\t\"FlipAngle\": $FlipAngle_x,\n\t\"MultibandAccellerationFactor\": $MultibandAccellerationFactor,\n\t\"PhaseEncodingDirection\": \"$PhaseEncodingDirection_x\",\n\t\"EffectiveEchoSpacing\": $EffectiveEchoSpacing_x\n}" >> "$filename" 
	    	ls "$filename" >> $errorlog
	    fi
	done
fi

# fieldmap
if [ "${convertfmap}" == "TRUE" ]; then
	echo -e "\nChecking fieldmap"

	# Set group Json info
	cd $bidsdir
	groupfile=phasediff.json
	EchoTime1=$(ls | grep 'EchoTime1' $groupfile | sed 's/^.*: //' | sed 's/,$//')
	EchoTime2=$(ls | grep 'EchoTime2' $groupfile | sed 's/^.*: //' | sed 's/,$//')

	#Check subject Json info and create seperate file if different
	cd $niidir/$subid/fmap
	file=$(find *info.txt -type f | xargs ls -1S | head -n 1)
	EchoTime1_x=$(echo "scale=5; ($(ls | grep 'Echo time\[[1]*\]' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.5f", $0}')
    EchoTime2_x=$(echo "scale=5; ($(ls | grep 'Echo time\[[2]*\]' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.5f", $0}')

	if [ "$EchoTime1" == "$EchoTime1_x" ] && [ "$EchoTime2" == "$EchoTime2_x" ]
	then
	    echo "$subid OK"
	else 
	    cd $bidsdir/sub-$subid/ses-$sessid/fmap/
	    filename="sub-"$subid"_ses-"$sessid"_phasediff.json"
	    echo -e "{\n\t\"EchoTime1\": $EchoTime1_x,\n\t\"EchoTime2\": $EchoTime2_x,\n\t\"IntendedFor\": [\"func/task-DSD_bold.nii.gz\", \"func/task-SVC_bold.nii.gz\"]\" \n}" >> "$filename" 
	    ls "$filename" >> $errorlog
	fi
fi

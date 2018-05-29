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

# Phase Encoding Direction info
echo -e "\nCreating AFNI file"

cd $bidsdir/sub-$subid/ses-$sessid/
afnifile="${subid}_${sessid}_phase_encoding.csv"
rm "${afnifile}"
touch "${afnifile}"
echo "sid,file,orient" > $afnifile
filelist=`find -name "*nii.gz"`

for f in $filelist; do
	orient=`3dinfo $f | grep 'orient' | sed -e 's/.*orient \(.*\)\]/\1/'`
	echo "$subid,$sessid,$f,$orient" >> $afnifile
done

mv $afnifile $niidir/$subid/${sessid}/

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

# Check subject parameters match group parameters and create seperate Json file within each subject directory if different
# anat

cd $niidir/$subid/${sessid}
file_extra=$(echo "$(ls | grep $subid | grep 'multiband')")

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
	cd $niidir/$subid/${sessid}/anat

	if [ $(ls *"${anat}"_info.txt | wc -l) -eq 1 ]; then
		file=$(echo "$(ls | grep "${anat}"_info)")
    		RepetitionTime_x=$(echo "($(ls -l| grep 'Repetition time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.1f", $0}')
    		EchoTime_x=$(echo "($(ls -l| grep 'Echo time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.5f", $0}')
    		FlipAngle_x=$(ls | grep 'Flip angle' $file | sed 's/^.*: //' | awk '{printf "%.0f", $0}')
    		InversionTime_x=$(echo "($(ls -l| grep 'Inversion time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.1f", $0}')
    
    		if [ "$RepetitionTime" == "$RepetitionTime_x" ] && [ "$EchoTime" == "$EchoTime_x" ] && [ "$FlipAngle" == "$FlipAngle_x" ] && [ "$InversionTime" == "$InversionTime_x" ]; then
			echo "OK"
		else 
	    		cd $bidsdir/sub-$subid/ses-$sessid/anat/
	    		filename="sub-"$subid"_ses-"$sessid"_T1w.json"
	    		rm "$filename"
			echo -e "{\n\t\"RepetitionTime\": $RepetitionTime_x,\n\t\"EchoTime\": $EchoTime_x,\n\t\"FlipAngle\": $FlipAngle_x,\n\t\"InversionTime\": $InversionTime_x,\n}" >> "$filename" 
	    		echo "not OK"
			ls "$filename" >> $newlog
		fi
	elif [ $(ls *"${anat}"_info.txt | wc -l) -gt 1 ]; then
    		echo "ERROR: wrong number of files"
		echo "${subid} ${sessid}: Wrong number of ${anat}" >> $errorlog
	else
    		echo "ERROR: no files; nothing to use"
		echo "${subid} ${sessid}: MISSING ${anat}" >> $errorlog
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
		cd $niidir/$subid/${sessid}/resting

		if [ $(ls *"${rest}"*info.txt | wc -l) -eq 1 ]; then
			file=$(echo "$(ls | grep $rest | grep 'info')")
			
			RepetitionTime_x=$(echo "($(ls -l| grep 'Repetition time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.3f", $0}')
    			EchoTime_x=$(echo "($(ls -l| grep 'Echo time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.3f", $0}')
    			FlipAngle_x=$(ls | grep 'Flip angle' $file | sed 's/^.*: //' | awk '{printf "%.0f", $0}')
			SeriesNo_x=$(ls | grep 'Series number' $file | sed 's/^.*: //')
			EffectiveEchoSpacing_x=$(echo "($(ls -l| grep 'Effective echo spacing' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.5f", $0}')
			
			cd $niidir/$subid/${sessid} 
			MultibandAccelerationFactor_x=$(ls | grep $(echo "$SeriesNo_x","$rest") $file_extra | sed 's/^.*MB//' | cut -d/ -f1)

    			fileSTRING="sub-"$subid"_ses-"$sessid"_task-rest_run-0"$runnum"_bold.nii.gz"
    			PED=$(ls | grep "$fileSTRING" $afnifile | sed -n 's/^.*nii.gz,[[:space:]]*//p')
    			if [[ "$PED" == ?$x? ]]; then
    				PhaseEncodingDirection_x="j-"
    			elif [[ "$PED" == ?$y? ]]; then
    				PhaseEncodingDirection_x="j"
    			elif [[ "$PED" == $x?? ]]; then
    				PhaseEncodingDirection_x="i-"
			elif [[ "$PED" == $y?? ]]; then
    				PhaseEncodingDirection_x="i"
    			elif [[ "$PED" == ??$x ]]; then
    				PhaseEncodingDirection_x="k-"
			elif [[ "$PED" == ??$y ]]; then
    				PhaseEncodingDirection_x="k"
    			fi

			if [ "$RepetitionTime" == "$RepetitionTime_x" ] && [ "$EchoTime" == "$EchoTime_x" ] && [ "$FlipAngle" == "$FlipAngle_x" ] && [ "$EffectiveEchoSpacing" == "$EffectiveEchoSpacing_x" ] && [ "$PhaseEncodingDirection" == "$PhaseEncodingDirection_x" ] && [ "$MultibandAccelerationFactor" == "$MultibandAccelerationFactor_x" ]; then
	   			echo "OK"
			else 
	    			cd $bidsdir/sub-$subid/ses-$sessid/func/
	    			filename="sub-"$subid"_ses-"$sessid"_task-rest_run-0"$runnum"_bold.json"
	    			rm "$filename"
				echo -e "{\n\t\"TaskName\": \"rest\",\n\t\"RepetitionTime\": $RepetitionTime_x,\n\t\"EchoTime\": $EchoTime_x,\n\t\"FlipAngle\": $FlipAngle_x,\n\t\"MultibandAccelerationFactor\": $MultibandAccelerationFactor_x,\n\t\"PhaseEncodingDirection\": \"$PhaseEncodingDirection_x\",\n\t\"EffectiveEchoSpacing\": $EffectiveEchoSpacing_x\n}" >> "$filename" 
	    			echo "not OK"
	    			ls "$filename" >> $newlog
	    		fi
	    	elif [ $(ls *"${rest}"*info.txt | wc -l) -gt 1 ]; then
			echo "ERROR: wrong number of files"
			echo "${subid} ${sessid}: Wrong number of ${rest}" >> $errorlog
		else 
            		echo "ERROR: no files; nothing to use"
                	echo "${subid} ${sessid}: MISSING ${rest}" >> $errorlog
        	fi
	done
fi

# task fMRI 
if [ "${converttask}" == "TRUE" ]; then
	echo -e "\nChecking task fMRI"
	
	for task in ${tasks[@]}; do 
		echo $task
		runnum="$(echo "${task}" | sed 's/[^0-9]//g')"
		taskalpha="$(echo "${task}" | sed 's/[^a-zA-Z]//g')"
		
		# Set group Json info
		cd $bidsdir
		groupfile=*"$taskalpha"_bold.json
		RepetitionTime=$(ls -l| grep 'RepetitionTime' $groupfile | sed 's/^.*: //' | sed 's/,$//') 
		EchoTime=$(ls | grep 'EchoTime' $groupfile | sed 's/^.*: //' | sed 's/,$//')
		FlipAngle=$(ls | grep 'FlipAngle' $groupfile | sed 's/^.*: //' | sed 's/,$//')
		PhaseEncodingDirection=$(ls | grep 'PhaseEncodingDirection' $groupfile | sed 's/^.*: //' | sed 's/,$//' | tr -d '"')
		EffectiveEchoSpacing=$(ls | grep 'EffectiveEchoSpacing' $groupfile | sed 's/^.*: //' | sed 's/,$//')
		MultibandAccelerationFactor=$(ls | grep 'MultibandAccelerationFactor' $groupfile | sed 's/^.*: //' | sed 's/,$//')

		#Check subject Json info and create seperate file if different
		cd $niidir/$subid/${sessid}/task
		
		if [ $(ls *"${task}"*info.txt | wc -l) -eq 1 ]; then
            		file=$(echo "$(ls | grep $task | grep 'info')")
        	elif [ $(ls *"${task}"*info.txt | wc -l) -eq 0 ]; then
            		echo "ERROR: no files; nothing to use"
            		echo "${subid} ${sessid}: MISSING ${task}" >> $errorlog
        	else
        		echo "Largest file used"
            		largestfile=$(du -sh *"${task}"*.nii.gz | sort -n | tail -1 | cut -f2 | cut -c 1-9)
            		file=$(echo "${largestfile}"*info.txt)
		fi	
	
		RepetitionTime_x=$(echo "($(ls -l| grep 'Repetition time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.0f", $0}')
    		EchoTime_x=$(echo "($(ls -l| grep 'Echo time' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.3f", $0}')
    		FlipAngle_x=$(ls | grep 'Flip angle' $file | sed 's/^.*: //' | awk '{printf "%.0f", $0}')
    		EffectiveEchoSpacing_x=$(echo "($(ls -l| grep 'Effective echo spacing' $file | sed 's/^.*: //')) / 1000" | bc -l | awk '{printf "%.5f", $0}')
		SeriesNo_x=$(ls | grep 'Series number' $file | sed 's/^.*: //')
	
		cd $niidir/$subid/${sessid}
		MultibandAccelerationFactor_x=$(ls | grep $(echo "$SeriesNo_x","$task") $file_extra | sed 's/^.*MB//' | cut -d/ -f1)
		
    		fileSTRING="sub-"$subid"_ses-"$sessid"_task-"$taskalpha"_run-0"$runnum"_bold.nii.gz"
    		PED=$(ls | grep "$fileSTRING" $afnifile | sed -n 's/^.*nii.gz,[[:space:]]*//p')

		if [[ "$PED" == ?$x? ]]; then
    			PhaseEncodingDirection_x="j-"
    		elif [[ "$PED" == ?$y? ]]; then
    			PhaseEncodingDirection_x="j"
    		elif [[ "$PED" == $x?? ]]; then
    			PhaseEncodingDirection_x="i-"
		elif [[ "$PED" == $y?? ]]; then
    			PhaseEncodingDirection_x="i"
    		elif [[ "$PED" == ??$x ]]; then
    			PhaseEncodingDirection_x="k-"
		elif [[ "$PED" == ??$y ]]; then
    			PhaseEncodingDirection_x="k"
    		fi

    		if [[ "$file" =~ "${task}" ]]; then
			if [ "$RepetitionTime" == "$RepetitionTime_x" ] && [ "$EchoTime" == "$EchoTime_x" ] && [ "$FlipAngle" == "$FlipAngle_x" ] && [ "$EffectiveEchoSpacing" == "$EffectiveEchoSpacing_x" ] && 
				[ "$PhaseEncodingDirection" == "$PhaseEncodingDirection_x" ] && [ "$MultibandAccelerationFactor" == "$MultibandAccelerationFactor_x" ]; then
	    			echo "OK"
	    		else 
	        		cd $bidsdir/sub-$subid/ses-$sessid/func/
	        		filename="sub-"$subid"_ses-"$sessid"_task-"$taskalpha"_run-0"$runnum"_bold.json"
	        		rm "$filename"
				echo -e "{\n\t\"TaskName\": \"$taskalpha\",\n\t\"RepetitionTime\": $RepetitionTime_x,\n\t\"EchoTime\": $EchoTime_x,\n\t\"FlipAngle\": $FlipAngle_x,\n\t\"MultibandAccelerationFactor\": $MultibandAccelerationFactor_x,\n\t\"PhaseEncodingDirection\": \"$PhaseEncodingDirection_x\",\n\t\"EffectiveEchoSpacing\": $EffectiveEchoSpacing_x\n}" >> "$filename" 
				echo "not OK"	
    				ls "$filename" >> $newlog
	    		fi
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

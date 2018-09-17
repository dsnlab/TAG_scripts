#!/bin/tcsh


if ( "${model}" == "2" ) then
	
	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSHp.txt $stim_dir/${subj}_neutSHp.txt $stim_dir/${subj}_affPRIp.txt $stim_dir/${subj}_neutPRIp.txt `
	set type = `echo 'times times AM2 AM2 AM2 AM2' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `
    
else if ( "${model}" == "1" ) then

	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSHp.txt $stim_dir/${subj}_neutSHp.txt $stim_dir/${subj}_affPRIp.txt $stim_dir/${subj}_neutPRIp.txt $stim_dir/${subj}_missing.txt `
	set type = `echo 'times times AM2 AM2 AM2 AM2 times' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI missing' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `

else if ( "${model}" == "4" ) then
	
	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSHp.txt $stim_dir/${subj}_neutSHp.txt $stim_dir/${subj}_affPRIp.txt $stim_dir/${subj}_neutPRI.txt `
	set type = `echo 'times times AM2 AM2 AM2 times' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `

else if ( "${model}" == "3" ) then

	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSHp.txt $stim_dir/${subj}_neutSHp.txt $stim_dir/${subj}_affPRIp.txt $stim_dir/${subj}_neutPRI.txt $stim_dir/${subj}_missing.txt `
	set type = `echo 'times times AM2 AM2 AM2 times times' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI missing' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `

else if ( "${model}" == "5" ) then
	
	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSHp.txt $stim_dir/${subj}_neutSHp.txt $stim_dir/${subj}_affPRI.txt $stim_dir/${subj}_neutPRIp.txt $stim_dir/${subj}_missing.txt `
	set type = `echo 'times times AM2 AM2 times AM2 times' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI missing' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `

else if ( "${model}" == "6" ) then

	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSHp.txt $stim_dir/${subj}_neutSHp.txt $stim_dir/${subj}_affPRI.txt $stim_dir/${subj}_neutPRI.txt $stim_dir/${subj}_missing.txt `
	set type = `echo 'times times AM2 AM2 times times times' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI missing' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `

else if ( "${model}" == "7" ) then

	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSHp.txt $stim_dir/${subj}_neutSHp.txt $stim_dir/${subj}_affPRI.txt $stim_dir/${subj}_neutPRI.txt `
	set type = `echo 'times times AM2 AM2 times times' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `

else if ( "${model}" == "8" ) then
	
	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSHp.txt $stim_dir/${subj}_neutSH.txt $stim_dir/${subj}_affPRIp.txt $stim_dir/${subj}_neutPRIp.txt $stim_dir/${subj}_missing.txt `
	set type = `echo 'times times AM2 times AM2 AM2 times' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI missing' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `

else if ( "${model}" == "9" ) then

	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSH.txt $stim_dir/${subj}_neutSHp.txt $stim_dir/${subj}_affPRIp.txt $stim_dir/${subj}_neutPRIp.txt $stim_dir/${subj}_missing.txt `
	set type = `echo 'times times times AM2 AM2 AM2 times' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI missing' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `

else if ( "${model}" == "10" ) then

	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSH.txt $stim_dir/${subj}_neutSHp.txt $stim_dir/${subj}_affPRIp.txt $stim_dir/${subj}_neutPRIp.txt `
	set type = `echo 'times times times AM2 AM2 AM2' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `

else if ( "${model}" == "11" ) then

	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSH.txt $stim_dir/${subj}_neutSH.txt $stim_dir/${subj}_affPRIp.txt $stim_dir/${subj}_neutPRIp.txt `
	set type = `echo 'times times times times AM2 AM2' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `

endif

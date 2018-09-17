#!/bin/tcsh

if ( "${model}" == "0" ) then
	
	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSH.txt $stim_dir/${subj}_neutSH.txt $stim_dir/${subj}_affPRI.txt $stim_dir/${subj}_neutPRI.txt `
	set type = `echo 'times times times times times times' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `
    
else if ( "${model}" == "1" ) then

	set stim = `echo $stim_dir/${subj}_affSTATE.txt $stim_dir/${subj}_neutSTATE.txt $stim_dir/${subj}_affSH.txt $stim_dir/${subj}_neutSH.txt $stim_dir/${subj}_affPRI.txt $stim_dir/${subj}_neutPRI.txt $stim_dir/${subj}_missing.txt `
	set type = `echo 'times times times times times times times' `
	set label = `echo 'affSTATE neutSTATE affSH neutSH affPRI neutPRI missing' `
	set basis = `echo 'BLOCK(4,1)' 'BLOCK(4,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' 'BLOCK(3,1)' `

endif


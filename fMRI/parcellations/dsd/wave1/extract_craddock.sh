#!/bin/bash
#
# This script will extract parameter estimates from fx and rx models for a specified parcellation  

# load packages 
module load prl
module load afni

# set directories
model_dir='/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/dsd/wave1/decision_main' #rx model directory
subj_dir='/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1' #subjects directory
con_dir=(fx/cyb/events_concat_wWait) #fx directory
parc_dir='/projects/dsnlab/shared/tag/nonbids_data/fMRI/parcellations/templates' #parcellation atlas directory 
aparc_output='/projects/dsnlab/shared/tag/nonbids_data/fMRI/parcellations/dsd/wave1/decision_main' #parcellation output directory
rx_output=(groupLevel) #sub-directory in $aparc_output
fx_output=(subjectLevel) #sub-directory in $aparc_output

# set variables
parc=(craddock_all.nii.gz) #parcellation atlas file
parc_map=(25) #parcellation map number (if applicable)
aparc=(aligned_craddock) #aligned parcellation map name
aparc_num=$(seq 1 250) #parcellation numbers to extract from; use $(seq 1 N) where N is the total number of parcels to extract from all
subj=(001 004 005 010 011 012 013 014 015 016 018 019 020 022 023 026 027 030 032 033 034 035 036 037 038 040 041 042 045 046 048 049 050 051 052 053 054 055 056 059 060 062 065 066 067 068 069 070 071 072 074 075 076 077 078 080 081 084 085 086 087 088 090 091 094 095 099 100 101 102 103 104 106 107 109 111 112 114 116 119 120 122 124 125 127 130 132 138 141 144 145 147 149 152 155 159 160 164 166 167 169 175 179 180 181 186 194 200 202 203 206 207 208 209 210 211 215 220 221 223 224 225 232 238 240 243 250 253 266) #subjects
rx_conName1=(affDec) #name of rx constrast for output files
rx_con1=(con_0001.nii) #rx affDec con file to extract from
rx_conName2=(neutDec) #name of rx constrast for output files
rx_con2=(con_0002.nii) #rx neutDec con file to extract from
fx_con=(con_0004 con_0005) #fx con files to extract from

# align parcellation map to data
echo "aligning parcellation map"
if [ -f $parc_dir/${aparc}+tlrc.BRIK ]
	then
	echo "aligned parcellation map already exists"
else 
3dAllineate -source $parc_dir/$parc[$parc_map] -master $model_dir/$rx_con1 -final NN -1Dparam_apply '1D: 12@0'\' -prefix $parc_dir/$aparc
fi


# loop through parcellations and extract from group-level rx_cons
echo "extracting from rx cons"
for num in ${aparc_num[@]}
do
	echo $num
	3dmaskave -sigma -quiet -mrange $num $num -mask $parc_dir/${aparc}+tlrc $model_dir/$rx_con1 > $aparc_output/$rx_output/${rx_conName1}_${num}.txt
	3dmaskave -sigma -quiet -mrange $num $num -mask $parc_dir/${aparc}+tlrc $model_dir/$rx_con2 > $aparc_output/$rx_output/${rx_conName2}_${num}.txt
done


# loop through parcellations and extract from subject-level cons
echo "extracting from fx cons"
for sub in ${subj[@]}
do
	echo $sub
	for con in ${fx_con[@]}
	do
		echo $con
		for num in ${aparc_num[@]}
		do
			echo $num
			3dmaskave -sigma -quiet -mrange $num $num -mask $parc_dir/${aparc}+tlrc $subj_dir/$sub/$con_dir/${con}.nii > $aparc_output/$fx_output/${num}_${sub}_${con}.txt
		done
	done

done

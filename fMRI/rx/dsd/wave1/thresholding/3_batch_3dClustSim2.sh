#!/bin/bash
#export PATH=/usr/local/packages/afni/17.1.01/:${PATH} # set path to latest AFNI version
module load afni
module load prl

rx_path=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/dsd/wave1/pmod/MLmotion_AR_RT
cd $rx_path

#cd decisions_diff


#declare -a rx_list=(
#	"decision_main"
#	"decision_pmod"
#	"shareValue_pmod"
#	) # MUST be in order that corresponds ot means_list

#declare -a means_list=("0.6324164" "4.917155" "10.79975" "0.6026691" "4.975973" "11.28673") # avg ACF estimates from 3dFWHMX, ordered by model

#echo "${rx_list[@]}"
#echo "${means_list[@]}"

#for i in {0..3};
#	do
#	cd $rx_path/${rx_list[i]}
3dClustSim -mask /projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/masks/wave1/groupMask_thresh10_bin_2mm.nii -acf 0.73478 4.6649 12.535 > threshold.txt
#	3dClustSim -mask mask.nii -acf ${means_list[@]:$((3*($i))):3} > threshlog_${rx_list[i]}.txt # starting from the 3*(i-1)th position, take three acf values, log it all with the rx folders
#	echo "----"
#done

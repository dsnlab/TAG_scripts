#!/bin/bash

# This script extracts mean parameter estimates and SDs within an map or parcel
# from subject images (e.g. FX condition contrasts). Output is 
# saved as a text file in the output directory.

module load afni

echo -------------------------------------------------------------------------------
echo "${SUB}"
echo "Running ${SCRIPT}"
date
echo -------------------------------------------------------------------------------


# Set paths and variables
# ------------------------------------------------------------------------------------------
# variables
models=(s4_mni_fd  s4_mni_regr  s4_ped_fd  s4_ped_regr  s6_mni_fd  s6_mni_regr  s6_ped_fd  s6_ped_regr)
maps=(self_referential_association-test_z_FDR_0.01) #spmT_0001 #RX maps (without file format, specified below as .nii)
cons_files=`echo $(printf "con_%04d.nii\n" {1..32})`
waves=(wave1 wave2)

# paths
map_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/roi # /projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/wave1/task #map directory
output_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1and2/event_alltheways_forsca/dotProducts #parameter estimate output directory


if [ ! -d ${output_dir} ]; then
	mkdir -p ${output_dir}
fi

for model in ${models[@]}; do 
for wave in ${waves[@]}; do 
con_dir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1and2/event_alltheways_forsca/"${model}"/"${wave}"/sub-"${SUB}" #con directory

# Align images and calculate dot products for each contrast and model map
# ------------------------------------------------------------------------------------------
for map in ${maps[@]}; do 
3dAllineate -source "${map_dir}"/"${map}".nii -master "${con_dir}"/mask.nii -final NN -1Dparam_apply '1D: 12@0'\' -prefix "${map_dir}"/aligned_"${map}"_"${SUB}"
for con in ${cons_files[@]}; do 
echo "${SUB}" "${wave}" "${model}" "${con}" "${map}" `3ddot -dodot "${map_dir}"/aligned_"${map}"_"${SUB}"+tlrc "${con_dir}"/"${con}"` >> "${output_dir}"/"${SUB}"_dotProducts.txt
done
rm  "${map_dir}"/aligned_"${map}"_"${SUB}"*
done

done
done

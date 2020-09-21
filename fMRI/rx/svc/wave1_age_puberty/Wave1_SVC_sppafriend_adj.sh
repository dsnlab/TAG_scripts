#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dMVM_SPPA_FRIEND
#SBATCH --output=output/SVC_3dMVM_SPPA_FRIEND.log
#SBATCH --error=output/SVC_3dMVM_SPPA_FRIEND_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=long,longfat

module load R 
module load afni
#Get R to recognize locally installed package afex
export R_LIBS=/home/barendse/R/x86_64-pc-linux-gnu-library/3.5/


rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/wave1/MI/
cd $rxdir ; mkdir -p SPPA_FRIENDxAdj ; cd SPPA_FRIENDxAdj/

#Two within-subject factors (condition and adjective factor), plus two quantitative variables (age and symptoms).

3dMVM -prefix SPPA_FRIENDxAdj -jobs 4       \
       -bsVars  "sppa_friend+age"           \
       -wsVars "condition*adj"       \
       -qVars  "age,sppa_friend"            \
	   -SC							\
       -num_glt 4                  \
       -gltLabel 1 SPPA_FRIEND_self_pros_anti -gltCode 1 'condition : 1*self -1*change adj : 1*pros -1*anti sppa_friend :'     \
       -gltLabel 2 SPPA_FRIEND_self_pros_with -gltCode 2 'condition : 1*self -1*change adj : 1*pros -1*with sppa_friend :'     \
       -gltLabel 3 SPPA_FRIEND_self_anti_with -gltCode 3 'condition : 1*self -1*change adj : 1*anti -1*with sppa_friend :'    \
	   -gltLabel 4 SPPA_FRIEND_self -gltCode 4 'condition : 1*self -1*change sppa_friend :'    \
	   -dataTable  @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/wave1_age_puberty/MI_fulltable.txt \

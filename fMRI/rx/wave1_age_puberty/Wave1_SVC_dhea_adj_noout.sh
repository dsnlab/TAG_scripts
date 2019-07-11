#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dMVM_dhea
#SBATCH --output=output/SVC_3dMVM_dhea2.log
#SBATCH --error=output/SVC_3dMVM_dhea2_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=short,fat

module load R 
module load afni
#Get R to recognize locally installed package afex
export R_LIBS=/home/barendse/R/x86_64-pc-linux-gnu-library/3.5/


rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/wave1/MI/
cd $rxdir ; mkdir -p DHEAxAdj_nooutl ; cd DHEAxAdj_nooutl/

#Two within-subject factors (condition and adjective factor), plus two quantitative variables (age and pubertal dev).

3dMVM -prefix DHEAxAdj -jobs 4       \
       -bsVars  "dhea+age"           \
       -wsVars "condition*adj"       \
       -qVars  "age,dhea"            \
	   -SC							\
       -num_glt 3                  \
       -gltLabel 1 dhea_self_pros_anti -gltCode 1 'condition : 1*self -1*change adj : 1*pros -1*anti dhea :'     \
       -gltLabel 2 dhea_self_pros_with -gltCode 2 'condition : 1*self -1*change adj : 1*pros -1*with dhea :'     \
       -gltLabel 3 dhea_self_anti_with -gltCode 3 'condition : 1*self -1*change adj : 1*anti -1*with dhea :'    \
	   -dataTable  @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/wave1_age_puberty/MI_fulltable_nooutlier.txt \

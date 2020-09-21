#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dMVM_dhea
#SBATCH --output=output/SVC_3dMVM_dheaV.log
#SBATCH --error=output/SVC_3dMVM_dheaV_err.log
#SBATCH --cpus-per-task=12
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=3000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab

module load R 
module load afni
#Get R to recognize locally installed package afex
export R_LIBS=/home/barendse/R/x86_64-pc-linux-gnu-library/3.5/


rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/wave1/MI/
cd $rxdir ; mkdir -p DHEAxValence ; cd DHEAxValence/

#Two within-subject factors (condition and adjective factor), plus two quantitative variables (age and pubertal dev).

3dMVM -prefix DHEAxValence -jobs 4       \
       -bsVars  "dhea+age"           \
       -wsVars "condition*valence"       \
       -qVars  "age,dhea"            \
	   -SC							\
       -num_glt 2                  \
       -gltLabel 1 dhea_self_pos_neg -gltCode 1 'condition : 1*self -1*change valence : 1*pos -1*neg dhea :'     \
       -gltLabel 2 dhea_self_neg_pos -gltCode 2 'condition : 1*self -1*change valence : 1*neg -1*pos dhea :'     \
	   -dataTable  @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/wave1_age_puberty/MI_fulltable_valence.txt \

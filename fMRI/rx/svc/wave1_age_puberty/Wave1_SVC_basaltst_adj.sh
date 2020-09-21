#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dMVM_tst
#SBATCH --output=output/SVC_3dMVM_tstb.log
#SBATCH --error=output/SVC_3dMVM_tstb_err.log
#SBATCH --account=dsnlab
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=long,longfat

module load R 
module load afni
#Get R to recognize locally installed package afex
export R_LIBS=/home/barendse/R/x86_64-pc-linux-gnu-library/3.5/


rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/wave1/MI/basalhorm_tocompare/
cd $rxdir ; mkdir -p TSTxAdj ; cd TSTxAdj/

#Two within-subject factors (condition and adjective factor), plus two quantitative variables (age and pubertal dev).

3dMVM -prefix TSTxAdj -jobs 4       \
       -bsVars  "testosterone+age"           \
       -wsVars "condition*adj"       \
       -qVars  "age,testosterone"            \
	   -SC							\
       -num_glt 3                  \
       -gltLabel 1 tst_self_pros_anti -gltCode 1 'condition : 1*self -1*change adj : 1*pros -1*anti testosterone :'     \
       -gltLabel 2 tst_self_pros_with -gltCode 2 'condition : 1*self -1*change adj : 1*pros -1*with testosterone :'     \
       -gltLabel 3 tst_self_anti_with -gltCode 3 'condition : 1*self -1*change adj : 1*anti -1*with testosterone :'    \
	   -dataTable  @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/wave1_age_puberty/MI_fulltable_basalh.txt \

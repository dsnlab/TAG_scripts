#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dMVM_SPPA_PHYS
#SBATCH --output=output/SVC_3dMVM_SPPA_PHYS.log
#SBATCH --error=output/SVC_3dMVM_SPPA_PHYS_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=long,longfat

module load R 
module load afni
#Get R to recognize locally installed package afex
export R_LIBS=/home/barendse/R/x86_64-pc-linux-gnu-library/3.5/


rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/wave1/MI/
cd $rxdir ; mkdir -p SPPA_PHYSxAdj ; cd SPPA_PHYSxAdj/

#Two within-subject factors (condition and adjective factor), plus two quantitative variables (age and sppa).

3dMVM -prefix SPPA_PHYSxAdj -jobs 4       \
       -bsVars  "sppa_phys+age"           \
       -wsVars "condition*adj"       \
       -qVars  "age,sppa_phys"            \
	   -SC							\
       -num_glt 4                  \
       -gltLabel 1 SPPA_PHYS_self_pros_anti -gltCode 1 'condition : 1*self -1*change adj : 1*pros -1*anti sppa_phys :'     \
       -gltLabel 2 SPPA_PHYS_self_pros_with -gltCode 2 'condition : 1*self -1*change adj : 1*pros -1*with sppa_phys :'     \
       -gltLabel 3 SPPA_PHYS_self_anti_with -gltCode 3 'condition : 1*self -1*change adj : 1*anti -1*with sppa_phys :'    \
	   -gltLabel 4 SPPA_PHYS_self -gltCode 4 'condition : 1*self -1*change sppa_phys :'    \
	   -dataTable  @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/wave1_age_puberty/MI_fulltable.txt \

#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dMVM_pds
#SBATCH --output=output/SVC_3dMVM_pdsV.log
#SBATCH --error=output/SVC_3dMVM_pdsV_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab

module load R 
module load afni
#Get R to recognize locally installed package afex
export R_LIBS=/home/barendse/R/x86_64-pc-linux-gnu-library/3.5/


rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/wave1/MI/
cd $rxdir ; mkdir -p PDSxValence ; cd PDSxValence/

#Two within-subject factors (condition and adjective factor), plus two quantitative variables (age and pubertal dev).

3dMVM -prefix PDSxValence -jobs 4       \
       -bsVars  "pds+age"           \
       -wsVars "condition*valence"       \
       -qVars  "age,pds"            \
	   -SC							\
       -num_glt 2                  \
       -gltLabel 1 pds_self_pos_neg -gltCode 1 'condition : 1*self -1*change valence : 1*pos -1*neg pds :'     \
       -gltLabel 2 pds_self_neg_pos -gltCode 2 'condition : 1*self -1*change valence : 1*neg -1*pos pds :'     \
	   -dataTable  @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/wave1_age_puberty/MI_fulltable_valence.txt \

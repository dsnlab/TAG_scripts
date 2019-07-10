#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dMVM_age
#SBATCH --output=output/SVC_3dMVM_age.log
#SBATCH --error=output/SVC_3dMVM_age_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=long,longfat

module load R 
module load afni
#Get R to recognize locally installed package afex
export R_LIBS=/home/barendse/R/x86_64-pc-linux-gnu-library/3.5/


rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/wave1/
cd $rxdir ; mkdir -p AGExAdj ; cd AGExAdj/

#Two within-subject factors (condition and adjective factor), plus one quantitative variable (age).

3dMVM -prefix AGExAdj -jobs 4       \
       -bsVars  "age"           \
       -wsVars "condition*adj"       \
       -qVars  "age"            \
	   -SC							\
       -num_glt 6                  \
       -gltLabel 1 age_self_pros_anti -gltCode 1 'condition : 1*self -1*change adj : 1*pros -1*anti age :'     \
       -gltLabel 2 age_self_pros_with -gltCode 2 'condition : 1*self -1*change adj : 1*pros -1*with age :'     \
       -gltLabel 3 age_self_anti_with -gltCode 3 'condition : 1*self -1*change adj : 1*anti -1*with age :'    \
	   -gltLabel 4 self_pros_anti -gltCode 4 'condition : 1*self -1*change adj : 1*pros -1*anti'     \
       -gltLabel 5 self_pros_with -gltCode 5 'condition : 1*self -1*change adj : 1*pros -1*with'     \
       -gltLabel 6 self_anti_with -gltCode 6 'condition : 1*self -1*change adj : 1*anti -1*with'    \
	   -dataTable  @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/wave1_age_puberty/pdstable.txt \

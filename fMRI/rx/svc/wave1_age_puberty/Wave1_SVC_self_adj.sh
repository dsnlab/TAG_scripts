#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dMVM_svc
#SBATCH --output=output/SVC_3dMVM_svc.log
#SBATCH --error=output/SVC_3dMVM_svc_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=long,longfat

module load R 
module load afni
#Get R to recognize locally installed package afex
export R_LIBS=/home/barendse/R/x86_64-pc-linux-gnu-library/3.5/


rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/wave1/
cd $rxdir ; mkdir -p SelfxAdj ; cd SelfxAdj/

#Two within-subject factors (condition and adjective factor), plus one quantitative variable (age).

3dMVM -prefix SelfxAdj -jobs 4       \
       -bsVars  "age"           \
       -wsVars "condition*adj"       \
       -qVars  "age"            \
	   -SC							\
       -num_glt 4                  \
	   -gltLabel 1 self_change -gltCode 1 'condition : 1*self -1*change'     \
	   -gltLabel 2 self_anti_pros -gltCode 2 'condition : 1*self -1*change adj : 1*anti -1*pros'     \
       -gltLabel 3 self_with_pros -gltCode 3 'condition : 1*self -1*change adj : 1*with -1*pros'     \
       -gltLabel 4 self_with_anti -gltCode 4 'condition : 1*self -1*change adj : 1*with -1*anti'    \
	   -dataTable  @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/wave1_age_puberty/pdstable.txt \

#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_atim
#SBATCH --output=output/SVC_3dLME_atim1.log
#SBATCH --error=output/SVC_3dLME_atim1_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab
#SBATCH --time=0-05:00:00

module load R 
module load afni/20.3.00
#R needs packages "nlme", "lme4", "phia", "snow" 

rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/
cd $rxdir ; mkdir -p MenarcheTiming ; cd MenarcheTiming/

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html
3dLMEr -prefix MenarcheTiming_lmer -jobs 8                               \
          -model  "MenarcheTiming+(1|Subj)"                                  \
		  -qVars "MenarcheTiming"                                   \
          -gltCode  Tim1 'Wave : 1*wave1 MenarcheTiming :'    \
		  -gltCode  Tim2 'Wave : 1*wave2 MenarcheTiming :'    \
          -gltCode  Tim_pos 'MenarcheTiming :'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_mentiming.txt \

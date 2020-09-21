#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_tim3
#SBATCH --output=output/SVC_3dLME_tim3.log
#SBATCH --error=output/SVC_3dLME_tim3_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab

module load R 
module load afni
#R needs packages "nlme", "lme4", "phia", "snow" 

rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/
cd $rxdir ; mkdir -p SubTiming ; cd SubTiming/

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html
3dLME -prefix SubTiming -jobs 8                               \
          -model  "SubTiming*Wave"                                  \
		  -qVars "SubTiming"                                   \
          -ranEff '~1'                                        \
		  -num_glt 3                                         \
          -gltLabel 1 'Tim1' -gltCode  1 'Wave : 1*wave1 SubTiming :'    \
		  -gltLabel 2 'Tim2' -gltCode  2 'Wave : 1*wave2 SubTiming :'    \
          -gltLabel 3 'Tim_pos' -gltCode  3 'SubTiming :'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_timing.txt \

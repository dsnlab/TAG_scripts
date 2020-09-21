#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_b_age
#SBATCH --output=output/SVC_3dLME_block_age.log
#SBATCH --error=output/SVC_3dLME_block_age_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab

module load R 
module load afni
#R needs packages "nlme", "lme4", "phia", "snow" 

rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/block/
cd $rxdir ; mkdir -p Age ; cd Age/

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html
3dLME -prefix Age -jobs 8                               \
          -model  "Age*Wave"                                  \
		  -qVars "Age"                                   \
          -ranEff '~1'                                        \
		  -num_glt 4                                         \
          -gltLabel 1 'Age1' -gltCode  1 'Wave : 1*wave1 Age :'    \
		  -gltLabel 2 'Age2' -gltCode  2 'Wave : 1*wave2 Age :'    \
          -gltLabel 3 'Age_pos' -gltCode  3 'Age :'    \
		  -gltLabel 4 'Wave_pos' -gltCode  4 'Wave : 1*wave2 -1*wave1'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable.txt \

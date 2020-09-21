#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_age
#SBATCH --output=output/SVC_3dLME_age_f.log
#SBATCH --error=output/SVC_3dLME_age_f_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab

module load R 
module load afni
#R needs packages "nlme", "lme4", "phia", "snow" 

rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/
cd $rxdir ; mkdir -p Age ; cd Age/

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html #Assuming there is no need for Wave by having age as within-subj covariate
3dLME -prefix Age_by_factor -jobs 8                               \
          -model  "Age*Factor"                                  \
		  -qVars "Age"                                   \
          -ranEff '~1'                                        \
		  -num_glt 3                                         \
          -gltLabel 1 'Age_pros' -gltCode  1 'Factor : 1*pros Age :'    \
		  -gltLabel 2 'Age_anti' -gltCode  2 'Factor : 1*anti Age :'    \
          -gltLabel 3 'Age_soci' -gltCode  3 'Factor : 1*soci Age :'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_factors.txt \

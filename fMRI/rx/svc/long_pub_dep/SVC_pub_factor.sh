#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_PubComp
#SBATCH --output=output/SVC_3dLME_PubComp_f.log
#SBATCH --error=output/SVC_3dLME_PubComp_f_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab

module load R 
module load afni
#R needs packPubComps "nlme", "lme4", "phia", "snow" 

rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/
cd $rxdir ; mkdir -p PubComp ; cd PubComp/

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html #Assuming there is no need for Wave by having PubComp as within-subj covariate
3dLME -prefix PubComp_by_factor -jobs 8                               \
          -model  "PubComp*Factor"                                  \
		  -qVars "PubComp"                                   \
          -ranEff '~1'                                        \
		  -num_glt 3                                         \
          -gltLabel 1 'PubComp_pros' -gltCode  1 'Factor : 1*pros PubComp :'    \
		  -gltLabel 2 'PubComp_anti' -gltCode  2 'Factor : 1*anti PubComp :'    \
          -gltLabel 3 'PubComp_soci' -gltCode  3 'Factor : 1*soci PubComp :'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_factors.txt \

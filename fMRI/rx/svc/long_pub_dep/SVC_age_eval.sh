#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_age
#SBATCH --output=output/SVC_3dLME_eval.log
#SBATCH --error=output/SVC_3dLME_eval_err.log
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

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html
3dLME -prefix Age_eval -jobs 8                               \
          -model  "Age*Eval"                                  \
		  -qVars "Age"                                   \
          -ranEff '~1'                                        \
		  -num_glt 4                                         \
          -gltLabel 1 'Age_poseval' -gltCode  1 'Eval : 1*pos Age :'    \
		  -gltLabel 2 'Age_negeval' -gltCode  2 'Eval : 1*neg Age :'    \
          -gltLabel 3 'Age_main' -gltCode  3 'Age :'    \
		  -gltLabel 4 'Pos_ht_Neg' -gltCode  4 'Eval : 1*pos -1*neg'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_eval.txt \

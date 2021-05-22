#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_PubComp
#SBATCH --output=output/SVC_3dLME_evalp.log
#SBATCH --error=output/SVC_3dLME_evalp_err.log
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

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html
3dLME -prefix PubComp_eval -jobs 8                               \
          -model  "PubComp*Eval"                                  \
		  -qVars "PubComp"                                   \
          -ranEff '~1'                                        \
		  -num_glt 3                                         \
          -gltLabel 1 'Pub_poseval' -gltCode  1 'Eval : 1*pos PubComp :'    \
		  -gltLabel 2 'Pub_negeval' -gltCode  2 'Eval : 1*neg PubComp :'    \
          -gltLabel 3 'Pub_main' -gltCode  3 'PubComp :'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_eval.txt \

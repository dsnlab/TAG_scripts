#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_pub
#SBATCH --output=output/SVC_3dLME_pub.log
#SBATCH --error=output/SVC_3dLME_pub_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab

module load R 
module load afni
#R needs packages "nlme", "lme4", "phia", "snow" 

rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/
cd $rxdir ; mkdir -p PubComp ; cd PubComp/

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html
3dLME -prefix PubComp -jobs 8                               \
          -model  "PubComp*Wave"                                  \
		  -qVars "PubComp"                                   \
          -ranEff '~1'                                        \
		  -num_glt 3                                         \
          -gltLabel 1 'Pub1' -gltCode  1 'Wave : 1*wave1 PubComp :'    \
		  -gltLabel 2 'Pub2' -gltCode  2 'Wave : 1*wave2 PubComp :'    \
          -gltLabel 3 'Pub_pos' -gltCode  3 'PubComp :'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable.txt \

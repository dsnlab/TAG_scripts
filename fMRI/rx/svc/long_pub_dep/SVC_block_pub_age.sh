#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_b_Puba
#SBATCH --output=output/SVC_3dLME_block_Puba.log
#SBATCH --error=output/SVC_3dLME_block_Puba_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab

module load R 
module load afni
#R needs packPubComps "nlme", "lme4", "phia", "snow" 

rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/block/
cd $rxdir ; mkdir -p PubComp ; cd PubComp/

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html
3dLME -prefix PubComp -jobs 8                               \
          -model  "PubComp*Wave"                                  \
		  -qVars "PubComp"                                   \
          -ranEff '~1'                                        \
		  -num_glt 4                                         \
          -gltLabel 1 'PubComp1' -gltCode  1 'Wave : 1*wave1 PubComp :'    \
		  -gltLabel 2 'PubComp2' -gltCode  2 'Wave : 1*wave2 PubComp :'    \
          -gltLabel 3 'PubComp_pos' -gltCode  3 'PubComp :'    \
		  -gltLabel 4 'Wave_pos' -gltCode  4 'Wave : 1*wave2 -1*wave1'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable.txt \

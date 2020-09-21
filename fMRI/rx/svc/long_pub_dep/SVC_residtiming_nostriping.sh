#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_tim2
#SBATCH --output=output/SVC_3dLME_tim5.log
#SBATCH --error=output/SVC_3dLME_tim5_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab
#SBATCH --time=1-00:00:00

module load R 
module load afni
#R needs packages "nlme", "lme4", "phia", "snow" 

rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/
cd $rxdir ; mkdir -p ResidTiming_nostriping ; cd ResidTiming_nostriping/

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html
3dLME -prefix ResidTiming -jobs 8                               \
          -model  "ResidTiming*Wave"                                  \
		  -qVars "ResidTiming"                                   \
          -ranEff '~1'                                        \
		  -num_glt 3                                         \
          -gltLabel 1 'Tim1' -gltCode  1 'Wave : 1*wave1 ResidTiming :'    \
		  -gltLabel 2 'Tim2' -gltCode  2 'Wave : 1*wave2 ResidTiming :'    \
          -gltLabel 3 'Tim_pos' -gltCode  3 'ResidTiming :'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_timing_nostriping.txt \

#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_ptim
#SBATCH --output=output/SVC_3dLME_ptim4.log
#SBATCH --error=output/SVC_3dLME_ptim4_err.log
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
cd $rxdir ; mkdir -p ResidTiming ; cd ResidTiming/

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html
3dLMEr -prefix ResidTiming_selfrest_lmer -jobs 8                               \
          -model  "ResidTiming+(1|Subj)"                                  \
		  -qVars "ResidTiming"      \
          -gltCode Tim1 'Wave : 1*wave1 ResidTiming :'    \
		  -gltCode Tim2 'Wave : 1*wave2 ResidTiming :'    \
          -gltCode Tim_pos 'ResidTiming :'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_residtiming_selfrest.txt \

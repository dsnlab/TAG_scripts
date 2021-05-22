#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_stim
#SBATCH --output=output/SVC_3dLME_stim.log
#SBATCH --error=output/SVC_3dLME_stim_err.log
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
cd $rxdir ; mkdir -p SubTiming ; cd SubTiming/

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html
3dLMEr -prefix SubTiming_lmer -jobs 8                               \
          -model  "SubTiming+(1|Subj)"                                  \
		  -qVars "SubTiming"      \
          -gltCode Tim1 'Wave : 1*wave1 SubTiming :'    \
		  -gltCode Tim2 'Wave : 1*wave2 SubTiming :'    \
          -gltCode Tim_pos 'SubTiming :'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_timing.txt \

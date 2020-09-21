#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmE_ResidTiming
#SBATCH --output=output/SVC_3dLME_ResidTiming_f.log
#SBATCH --error=output/SVC_3dLME_ResidTiming_f_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab
#SBATCH --time=0-02:00:00

module load R 
module load afni
#R needs packResidTimings "nlme", "lme4", "phia", "snow" 

rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/
cd $rxdir ; mkdir -p ResidTiming ; cd ResidTiming/

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html #Assuming there is no need for Wave by having ResidTiming as within-subj covariate
3dLME -prefix ResidTiming_by_factor -jobs 8                               \
          -model  "ResidTiming*Factor"                                  \
		  -qVars "ResidTiming"                                   \
          -ranEff '~1'                                        \
		  -num_glt 3                                         \
          -gltLabel 1 'ResidTiming_pros' -gltCode  1 'Factor : 1*pros ResidTiming :'    \
		  -gltLabel 2 'ResidTiming_anti' -gltCode  2 'Factor : 1*anti ResidTiming :'    \
          -gltLabel 3 'ResidTiming_soci' -gltCode  3 'Factor : 1*soci ResidTiming :'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_residtiming_factors.txt \

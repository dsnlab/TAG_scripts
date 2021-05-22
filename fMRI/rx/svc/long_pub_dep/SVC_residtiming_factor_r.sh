#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmer_ResidTiming
#SBATCH --output=output/SVC_3dLME_ResidTiming_f2.log
#SBATCH --error=output/SVC_3dLME_ResidTiming_f2_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=ctn
#SBATCH --account=dsnlab
#SBATCH --time=0-02:00:00

module load R 
module load afni/20.3.00
#R needs packResidTimings "nlme", "lme4", "phia", "snow" 

rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/
cd $rxdir ; mkdir -p ResidTiming ; cd ResidTiming/

#See https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/programs/3dLMEr_sphx.html #3dLMEr is needed to model 1|Subj and 1|Wave
3dLMEr -prefix ResidTiming_by_factor_lmer -jobs 8                               \
          -model  "ResidTiming*Factor+(1|Subj)+(1|Wave)"                                  \
		  -qVars "ResidTiming"      \
          -gltCode ResidTiming_pros 'Factor : 1*pros ResidTiming :'    \
		  -gltCode ResidTiming_anti 'Factor : 1*anti ResidTiming :'    \
          -gltCode ResidTiming_soci 'Factor : 1*soci ResidTiming :'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_residtiming_factors.txt \

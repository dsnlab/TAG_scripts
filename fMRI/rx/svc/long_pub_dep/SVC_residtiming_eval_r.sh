#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dlmer_ResidTiming
#SBATCH --output=output/SVC_3dLME_ResidTiming_f3.log
#SBATCH --error=output/SVC_3dLME_ResidTiming_f3_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=short
#SBATCH --account=dsnlab
#SBATCH --time=0-05:00:00

module load R 
module load afni/20.3.00
#R needs packResidTimings "nlme", "lme4", "phia", "snow" 

rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/
cd $rxdir ; mkdir -p ResidTiming ; cd ResidTiming/

#See https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/programs/3dLMEr_sphx.html #3dLMEr is needed to model 1|Subj and 1|Wave
3dLMEr -prefix ResidTiming_by_eval_lmer -jobs 4                               \
          -model  "ResidTiming*Eval+(1|Subj)+(1|Wave)"                                  \
		  -qVars "ResidTiming"      \
          -gltCode ResidTiming_poseval 'Eval : 1*pos ResidTiming :'    \
		  -gltCode ResidTiming_negeval 'Eval : 1*neg ResidTiming :'    \
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_residtiming_eval.txt \

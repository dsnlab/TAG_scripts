#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=3dICC_bl
#SBATCH --output=output/SVC_3dLME_icc_bl.log
#SBATCH --error=output/SVC_3dLME_icc_bl_err.log
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --account=dsnlab
#SBATCH --partition=ctn
#SBATCH --time=1-00:00:00

module load R
module load afni
#R needs packages blme,lme4,phia,(metafor),snow
#Get R to recognize locally installed package
export R_LIBS=/gpfs/home/barendse/R/x86_64-pc-linux-gnu-library/3.5

rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc/long/
cd $rxdir ; mkdir -p ICC ; cd ICC/

#See https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dICC.html
#https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dLME.html
3dLME -prefix ICC_block -jobs 12                                \
          -model  "Wave"										\
		  -ranEff "Subj"				 						\
		  -ICCb													\
          -dataTable @/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/fulltable_block.txt  \

#-mask /projects/dsnlab/shared/tag/nonbids_data/fMRI/roi/Brainnetome/aligned_motor_finger+tlrc \
#!/bin/bash
#SBATCH --job-name=fxcheck
#SBATCH --output=/projects/dsnlab/shared/tag/TAG_scripts/fMRI/fx/model_check/svc_wave1and2.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --account=dsnlab
#SBATCH --partition=ctn
#SBATCH --time=60

module load prl
module load python/3.6.0

#python -m pip install fpdf --user
#python -m pip install -U --user nilearn
#python -m pip install -U --user reportlab

python check_fx.py
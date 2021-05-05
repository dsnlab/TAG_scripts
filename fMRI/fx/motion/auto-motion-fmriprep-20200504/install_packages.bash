#!/bin/bash
#
#SBATCH --job-name=install_packages
#SBATCH --output=install_packages.log
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=1000
#SBATCH --account=dsnlab
#SBATCH --partition=ctn

module load R gcc

Rscript --verbose -e "osuRepo = 'http://ftp.osuosl.org/pub/cran/'; if(!require(tidyverse)){ install.packages('tidyverse',repos=osuRepo) }; if(!require(caret)){ install.packages('caret',repos=osuRepo) }; if(!require(randomForest)){ install.packages('randomForest',repos=osuRepo) }; if(!require(snakecase)){ install.packages('snakecase',repos=osuRepo) }; message('Installation complete')"

#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=acf_aver
#SBATCH --output=../output/acf_aver2.log
#SBATCH --error=../output/acf_aver2.log
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=1
#SBATCH --partition=ctn
#SBATCH --account=dsnlab

#This script averages the ACF parameters from svc across individuals (including only those in 'subjectlist.txt')
fxDIR='/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/valence'

for subj in `cat subjectlist.txt` ; do
	sed -n '1p' ${fxDIR}/sub-${subj}/ACFparameters_average.1D >> ACFparameters_allX.txt ;
	sed -n '2p' ${fxDIR}/sub-${subj}/ACFparameters_average.1D >> ACFparameters_allY.txt ;
	sed -n '3p' ${fxDIR}/sub-${subj}/ACFparameters_average.1D >> ACFparameters_allZ.txt ;
	done
for par in {X..Z} ; do 
awk '{ total += $1 } END { print total/NR }' ACFparameters_all${par}.txt >> ACFparameters_average_valence.txt ;
done
rm ACFparameters_all*.txt

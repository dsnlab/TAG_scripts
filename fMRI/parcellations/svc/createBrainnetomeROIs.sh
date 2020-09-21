#!/bin/bash
#SBATCH --job-name=rois_bn
#SBATCH --output=/projects/dsnlab/shared/tag/TAG_scripts/fMRI/rx/svc/long_pub_dep/output/rois_bn.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --account=dsnlab
#SBATCH --partition=ctn
#SBATCH --time=60

# This script takes parcels from the Brainnetome atlas (http://atlas.brainnetome.org/bnatlas.html)
# and turns them into ROIs (2mm isotropic MNI space)
# 
# The following ROIs are created:
# vmPFC/pgACC: A14m and A32sg; numbers 41, 42, 187, 188
# dmPFC: A9m and A10m; numbers 11, 12, 13, 14
# precuneus/posterior cingulate: A23d, A23v, and A31; numbers 175, 176, 181, 182, 153, 154
# ventral striatum: vCa and NAC; numbers 219, 220, 223, 224

## define paths
roiDir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/roi/Brainnetome

## load FSL
module load fsl

# cd into directory with the default mask files
cd ${roiDir}

echo -e "\nroi folder is in $roiDir"

## create masks
echo "Creating masks"

echo "vmpfc"
fslmaths BN_Atlas_246_2mm.nii.gz -thr 41 -uthr 42 -bin vmpfc.nii.gz

echo "spgacc"
fslmaths BN_Atlas_246_2mm.nii.gz -thr 187 -uthr 188 -bin spgacc.nii.gz

echo "dmpfc"
fslmaths BN_Atlas_246_2mm.nii.gz -thr 11 -uthr 14 -bin dmPFC.nii.gz

echo "precun"
fslmaths BN_Atlas_246_2mm.nii.gz -thr 175 -uthr 176 -bin precun.nii.gz

echo "pcc1"
fslmaths BN_Atlas_246_2mm.nii.gz -thr 181 -uthr 182 -bin pcc1.nii.gz

echo "pcc2"
fslmaths BN_Atlas_246_2mm.nii.gz -thr 153 -uthr 154 -bin pcc2.nii.gz

echo "vcaud"
fslmaths BN_Atlas_246_2mm.nii.gz -thr 219 -uthr 220 -bin vcaud.nii.gz

echo "nacc"
fslmaths BN_Atlas_246_2mm.nii.gz -thr 223 -uthr 224 -bin nacc.nii.gz


echo "vmPFCpgACC"
fslmaths vmpfc.nii.gz -add spgacc.nii.gz -bin vmPFCpgACC.nii.gz
echo "PrecPCC"
fslmaths precun.nii.gz -add pcc1.nii.gz -add pcc2.nii.gz -bin PrecPCC.nii.gz
echo "vStriatum"
fslmaths vcaud.nii.gz -add nacc.nii.gz -bin vStriatum.nii.gz

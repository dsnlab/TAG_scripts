#!/bin/bash
#
# This script will convert afni files
# to gzipped nifti files
#
#SBATCH --job-name=gzip
#SBATCH --account=dsnlab
#SBATCH --mem-per-cpu=8G
#SBATCH --output /projects/dsnlab/shared/tag/TAG_scripts/rsfMRI/proc2_output/%x-%A_%a.out
#SBATCH --array=0-2

#SUBJLIST=(sub-TAG074 sub-TAG087 sub-TAG124 sub-TAG125 sub-TAG155 sub-TAG175 sub-TAG203 sub-TAG211 sub-TAG215 sub-TAG218 sub-TAG225 sub-TAG232 sub-TAG238 sub-TAG243 sub-TAG244 sub-TAG247 sub-TAG250 sub-TAG252 sub-TAG253 sub-TAG261 sub-TAG266)
SUBJLIST=(sub-TAG200 sub-TAG099 sub-TAG205)

SUBID=${SUBJLIST[$SLURM_ARRAY_TASK_ID]}
echo -e "\nSetting up AFNI"

module load afni

date

echo $SHELL
echo $SHLVL
echo ${SUBID}

# set subject and group identifiers
subj="${SUBID}"
echo $subj
group_id=tag
echo $group_id
pipeline=rsfMRI_preproc_wave2

# set data directories
top_dir=/projects/dsnlab/shared/"${group_id}"
echo $top_dir
rsfMRI_output=$top_dir/bids_data/derivatives/$pipeline/$subj/$subj.results
echo $rsfMRI_output

pushd $rsfMRI_output
gen_epi_review.py -script @epi_review."${subj}"             \
    -dsets pb00."${subj}".r*.tcat+orig.HEAD

gen_ss_review_scripts.py -mot_limit 0.2 -out_limit 0.1  \
    -errts_dset errts."${subj}".fanaticor+orig.HEAD -exit0

./@ss_review_basic |& tee out.ss_review."${subj}".txt

rm rm.*
ls *.BRIK > afnifiles.txt

afnifiles=`cat afnifiles.txt`
for i in $afnifiles
	do 
	filename=${i::-5}
	niftiname=${i::-10}
	echo $filename
	echo $niftiname
	3dAFNItoNIFTI $filename
	gzip $niftiname.nii
	rm $filename.BRIK
	rm $filename.HEAD
done

popd

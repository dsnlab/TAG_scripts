#!/bin/tcsh
# This script calls from the variables set in batch_rsfMRIproc.sh
# and uses afni_proc.py to generate a participant-specific resting
# state preprocessing script, which will:
#
#  a) live in the participants' folder
#  b) be named t{SUBID}.proc
#  c) execute automatically.
#
#SBATCH --job-name=rsfmri_proc_w2
#SBATCH --account=dsnlab
#SBATCH --mem-per-cpu=16G
#SBATCH --output /projects/dsnlab/shared/tag/TAG_scripts/rsfMRI/proc2_output/%x-%A_%a.out
#SBATCH --array=0-3

#set SUBJLIST=(sub-TAG074 sub-TAG087 sub-TAG124 sub-TAG125 sub-TAG155 sub-TAG175 sub-TAG203 sub-TAG211 sub-TAG215 sub-TAG218 sub-TAG225 sub-TAG232 sub-TAG238 sub-TAG243 sub-TAG244 sub-TAG247 sub-TAG250 sub-TAG252 sub-TAG253 sub-TAG261 sub-TAG266)
set SUBJLIST =(sub-TAG200 sub-TAG099 sub-TAG205 sub-TAG208)

set SUBID=${SUBJLIST[$SLURM_ARRAY_TASK_ID]}


echo -e "\nSetting up AFNI"

module load afni
date

echo $SHELL
echo $SHLVL
echo ${SUBID}

# set subject and group identifiers
set subj="${SUBID}"
echo $subj
set group_id=tag
echo $group_id
set wave=2
echo $wave
set pipeline=rsfMRI_preproc_wave"$wave"
echo $pipeline

# set data directories
set top_dir=/projects/dsnlab/shared/"${group_id}"
echo $top_dir
set anat_dir=$top_dir/bids_data/derivatives/freesurfer_w"$wave"/$subj/SUMA
echo $anat_dir
set epi_dir=$top_dir/bids_data/"$subj"/ses-wave"$wave"/func
echo $epi_dir
set rsfMRI_output=$top_dir/bids_data/derivatives/$pipeline
echo $rsfMRI_output

# create subject folder
cd $rsfMRI_output
if (! -d ./"$subj") then
   echo '"$subj" folder created'
   mkdir "$subj"
   cd "$subj"
else
   echo 'Directory for "$subj" exists'
   rm -r "$subj"
   mkdir "$subj"
   cd "$subj"
endif

# run afni_proc.py to create a single subject processing script
afni_proc.py -subj_id $subj                                \
-script $pipeline.proc.$subj -scr_overwrite                          \
-blocks despike align volreg blur mask scale regress	  \
-copy_anat $anat_dir/"${subj}"_SurfVol.nii                          \
-anat_follower_ROI aaseg anat $anat_dir/aparc.a2009s+aseg_rank.nii   \
-anat_follower_ROI aeseg epi  $anat_dir/aparc.a2009s+aseg_rank.nii   \
-anat_follower_ROI FSvent epi $anat_dir/"${subj}"_vent.nii           \
-anat_follower_ROI FSWe epi $anat_dir/"${subj}"_WM.nii            \
-anat_follower_erode FSvent FSWe                           \
-dsets $epi_dir/"${subj}"_ses-wave"$wave"_task-rest_run-0?_bold.nii.gz \
-tcat_remove_first_trs 5                                  \
-volreg_align_to MIN_OUTLIER                               \
-volreg_align_e2a                                          \
-align_opts_aea -giant_move -cost lpc+ZZ                   \
-volreg_interp -Fourier \
-blur_size 2                            \
-mask_apply epi \
-mask_test_overlap yes \
-scale_max_val 200 \
-regress_ROI_PC FSvent 3                                   \
-regress_make_corr_vols aeseg FSvent                       \
-regress_anaticor_fast                                     \
-regress_anaticor_label FSWe                               \
-regress_censor_outliers 0.1                               \
-regress_censor_motion 0.2                                \
-regress_bandpass 0.009 0.2                               \
-regress_apply_mot_types demean deriv                      \
-regress_run_clustsim no                                  \
-regress_est_blur_errts                                   \

tcsh -xef $pipeline.proc.$subj







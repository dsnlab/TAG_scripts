#!/bin/tcsh

# This script calls from the variables set in batch_dsd_fx.sh
# and uses afni_proc.py to generate a participant-specific DSD fx
# script, which will:
#
# a) live in the participants' folder
# b) be named sub-TAG{SUBID}.proc
# c) execute automatically.

#load packages
module load prl
module load afni

# set data directories
set bids_dir = /projects/dsnlab/shared/tag/bids_data/derivatives/fmriprep
set stim_dir = /projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/multiconds/dsd/wave1/Summary/2x2/AFNI
set motion_dir = /projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/motion/wave1/rawmotion_afni
set outlier_dir = /projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/motion/wave1/auto-motion-fmriprep/afni_outlier/fd0.7_dv2.0_noN_withEdits
set working_dir = /projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/afni/pmod

# set subject and group identifiers [gname unused here]
set subj  = sub-TAG"${SUBID}"
set model = ${MODEL}
set gname = TAG

echo $subj
echo $model

# source stim details

source main_model.sh $model $stim_dir $subj

echo $stim
echo $type
echo $label
echo $basis

# create subject folder
pushd $working_dir
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

# set dataset for template (tlrc block)
set basedset = MNI152_2009_template.nii.gz

# run afni_proc.py to create a single subject processing script
afni_proc.py -subj_id $subj                                      \
        -script proc.$subj -scr_overwrite                        \
        -blocks blur mask scale regress                          \
        -copy_anat ${bids_dir}/${subj}/ses-wave1/anat/${subj}_ses-wave1_T1w_space-MNI152NLin2009cAsym_preproc.nii.gz             \
        -dsets ${bids_dir}/${subj}/ses-wave1/func/${subj}_ses-wave1_task-DSD_run-0?_bold_space-MNI152NLin2009cAsym_preproc.nii.gz   \
	-blur_in_automask					 \
	-blur_size 6						 \
        -regress_local_times					 \
	-regress_stim_times $stim				 \
        -regress_stim_types $type 				 \
        -regress_stim_labels $label				 \
        -regress_basis_multi $basis				 \
	-regress_motion_file $motion_dir/${subj}_DSD_motion.1D      \
	-regress_motion_per_run					 \
	-regress_censor_motion 0.3              		 \
	-regress_censor_outliers 0.99				 \
	-regress_censor_extern $outlier_dir/${subj}_DSD_outlier.1D				 \
	-regress_opts_3dD					 \
            -gltsym 'SYM: 0.25*affSH +0.25*affPRI -0.25*neutSH -0.25*neutPRI' -glt_label 1 aff-neut      \
            -gltsym 'SYM: 0.25*affSH +0.25*neutSH -0.25*affPRI -0.25*neutPRI' -glt_label 2 SH-PRI        \
            -gltsym 'SYM: 0.5*affSH -0.5*neutSH' -glt_label 3 SH:aff-neut                                \
            -gltsym 'SYM: 0.5*affSH -0.5*affPRI' -glt_label 4 PRI:aff-neut                               \
            -gltsym 'SYM: 0.5*affSH -0.5*affPRI' -glt_label 5 aff:SH-PRI                                 \
            -gltsym 'SYM: 0.5*neutSH -0.5*neutPRI' -glt_label 6 neut:SH-PRI                              \
            -gltsym 'SYM: 0.5*affSTATE -0.5*neutSTATE' -glt_label 7 STATE:aff-neut                       \
        -regress_3dD_stop                                        \
        -regress_reml_exec                                       \
        -regress_compute_fitts                                   \
        -regress_make_ideal_sum sum_ideal.1D                     \
        -regress_est_blur_errts                                  \
        -regress_run_clustsim no				 \
	-execute
time ; exit 0

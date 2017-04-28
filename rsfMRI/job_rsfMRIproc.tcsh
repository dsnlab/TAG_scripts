#!/bin/tcsh
#
# This script calls from the variables set in batch_rsfMRIproc.sh
# and uses afni_proc.py to generate a participant-specific resting
# state preprocessing script, which will:
#
#  a) live in the participants' folder
#  b) execute automatically.
#
# All you need to do here is set the groupid
# and the pipeline name

echo -e "\nSetting up AFNI"

module use /projects/tau/packages/Modules/modulefiles/
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
set pipeline=rsfMRIpreproc_April28


# set data directories
set top_dir=/projects/dsnlab/"${group_id}"
echo $top_dir
set anat_dir=$top_dir/sMRI/subjects/$subj/SUMA
echo $anat_dir
set epi_dir=$top_dir/bids_data/"$subj"/ses-wave1/func
echo $epi_dir
set rsfMRI_output=$top_dir/bids_data/derivatives
echo $rsfMRI_output

# create pipeline folder if needed
pushd $rsfMRI_output
if (! -d ./"$pipeline") then
   echo '"$pipeline" folder created'
   mkdir "$pipeline"
   cd "$pipeline"
else
   echo 'Directory for "$pipeline" exists'
   cd "$pipeline"
endif

# create subject folder if needed
if (! -d ./"$subj") then
   echo '"$subj" folder created'
   mkdir "$subj"
   cd "$subj"
else
   echo 'Directory for "$subj" exists'
   cd "$subj"
endif

# run afni_proc.py to create a single subject processing script
afni_proc.py -subj_id $subj                                \
-script $pipeline.proc.$subj -scr_overwrite                          \
-blocks despike tshift align volreg mask regress      \
-copy_anat $anat_dir/"${subj}"_SurfVol.nii.gz                          \
-anat_follower_ROI aaseg anat $anat_dir/aparc.a2009s+aseg_rank.nii.gz   \
-anat_follower_ROI aeseg epi  $anat_dir/aparc.a2009s+aseg_rank.nii.gz   \
-anat_follower_ROI FSvent epi $anat_dir/"${subj}"_vent.nii.gz           \
-anat_follower_ROI FSWe epi $anat_dir/"${subj}"_WM.nii.gz            \
-anat_follower_erode FSvent FSWe                           \
-dsets $epi_dir/"${subj}"_ses-wave1_task-rest_run-01_bold.nii.gz \
-tcat_remove_first_trs 13                                  \
-volreg_align_to MIN_OUTLIER                               \
-volreg_align_e2a                                          \
-regress_ROI_PC FSvent 3                                   \
-regress_make_corr_vols aeseg FSvent                       \
-regress_anaticor_fast                                     \
-regress_anaticor_label FSWe                               \
-regress_apply_mot_types demean deriv                      \
-regress_run_clustsim no

tcsh -xef $pipeline.proc.$subj
#!/bin/bash

# This script copies (a) DICOMS from lcni to our lab, on Talapas, (b) DICOMS & physio from Talapas to CAS server

# the following inputs should be the directory names (subject ID + session dates) of the three SOS subjects whose DICOMS are in the TAG folder
EXCLUDED_SESS_1=$1
EXCLUDED_SESS_2=$2
EXCLUDED_SESS_3=$3

# Create log file with today's date:
log_name=$(date +%Y-%m-%d-%H-%M-%S)_rsync.log
touch $log_name

## TASK BEH DATA (laptops first)
#### Sherri to CAS
rsync -aiv --log-file=$log_name -e ssh FP@10.174.6.120:/Users/FP/Desktop/TAG-fMRI-task/task/input/tag*_info.mat /Volumes/psych-cog/dsnlab/TAG/behavior/task/info/ # inputs
rsync -aiv --log-file=$log_name -e ssh FP@10.174.6.120:/Users/FP/Desktop/TAG-fMRI-task/task/output/* /Volumes/psych-cog/dsnlab/TAG/behavior/task/output/ # outputs 10.109.94.238

#### Terri to CAS - note that foldername is plural (taskS)
rsync -aiv --log-file=$log_name -e ssh FP@10.109.34.8:/Users/FP/Desktop/TAG-fMRI-tasks/task/input/tag*_info.mat /Volumes/psych-cog/dsnlab/TAG/behavior/task/info/ # inputs
rsync -aiv --log-file=$log_name -e ssh FP@10.109.34.8:/Users/FP/Desktop/TAG-fMRI-tasks/task/output/* /Volumes/psych-cog/dsnlab/TAG/behavior/task/output/ # outputs

#### LCNI Desktop (backup) to CAS
rsync -aiv --log-file=$log_name -e ssh dsnlab@controlroommac.uoregon.edu:/Users/dsnlab/Desktop/TAG-fMRI-tasks/task/input/tag*_info.mat /Volumes/psych-cog/dsnlab/TAG/behavior/task/info/ # inputs
rsync -aiv --log-file=$log_name -e ssh dsnlab@controlroommac.uoregon.edu:/Users/dsnlab/Desktop/TAG-fMRI-tasks/task/output/* /Volumes/psych-cog/dsnlab/TAG/behavior/task/output/ # outputs

#### Mock scanner to CAS
rsync -aiv --log-file=$log_name -e ssh dsnlab@simulatormac:/Users/dsnlab/Studies/TAG/task/DRS/task/input/tag*_info.mat /Volumes/psych-cog/dsnlab/TAG/behavior/task/info/ # inputs
rsync -aiv --log-file=$log_name -e ssh dsnlab@simulatormac:/Users/dsnlab/Studies/TAG/task/DRS/task/output/* /Volumes/psych-cog/dsnlab/TAG/behavior/task/output/ # outputs

## NEURO + PHYSIO DATA
## COPY TALAPAS LCNI DICOMS TO TALAPAS DSNLAB ARCHIVE
<<<<<<< HEAD
ssh jpfeifer@talapas-ln1.uoregon.edu rsync -aiv -P /projects/lcni/dcm/dsnlab/Pfeifer/TAG/TAG???_20* /projects/dsnlab/shared/tag/archive/DICOMS/ --exclude $EXCLUDED_SESS_1 --exclude $EXCLUDED_SESS_2 --exclude $EXCLUDED_SESS_3  # for tag
ssh jpfeifer@talapas-ln1.uoregon.edu rsync -aiv -P /projects/lcni/dcm/dsnlab/Pfeifer/SOS/TAG???_20* /projects/dsnlab/shared/sos/archive/DICOMS/ # for SOS (named correctly)
ssh jpfeifer@talapas-ln1.uoregon.edu rsync -aiv -P /projects/lcni/dcm/dsnlab/Pfeifer/SOS/SOS???_20* /projects/dsnlab/shared/sos/archive/DICOMS/ # for SOS (named incorrectly)
=======
# RUN THIS LINE USING THE VERSION IN THE TEXT FILE copy_lcni_dicoms_to_dsnlab.txt TO AVOID BACKING UP SOS FILES - it has extra options that are omitted for privacy reasons (ssh jpfeifer@talapas-ln1.uoregon.edu rsync -aiv -P /projects/lcni/dcm/dsnlab/Pfeifer/TAG/TAG???_20* /projects/dsnlab/shared/tag/archive/DICOMS/) # for tag
ssh jpfeifer@talapas-ln1.uoregon.edu rsync -aiv --log-file=$log_name -P /projects/lcni/dcm/dsnlab/Pfeifer/SOS/TAG???_20* /projects/dsnlab/shared/sos/archive/DICOMS/ # for SOS (named correctly)
ssh jpfeifer@talapas-ln1.uoregon.edu rsync -aiv --log-file=$log_name -P /projects/lcni/dcm/dsnlab/Pfeifer/SOS/SOS???_20* /projects/dsnlab/shared/sos/archive/DICOMS/ # for SOS (named incorrectly)
>>>>>>> 023a6f5de34aed223370b7d60d2f6bf7127e4a7b

## COPY TALAPAS LCNI PHYSIO TO TALAPAS DSNLAB ARCHIVE
ssh jpfeifer@talapas-ln1.uoregon.edu rsync -aiv --log-file=$log_name -P /projects/lcni/dcm/dsnlab/Pfeifer/TAG/*physio* /projects/dsnlab/shared/tag/archive/physio/
##New TAG physio is now saved in dcm format… no additional backup required
##SOS physio is now saved in dcm format… no additional backup required

# OTHER DATA SHUFFLING
## COPY TALAPAS DSNLAB ARCHIVE TO CAS
rsync -aiv --log-file=$log_name -e ssh jpfeifer@talapas-ln1.uoregon.edu:/projects/dsnlab/shared/tag/archive/ /Volumes/psych-cog/dsnlab/TAG/archive/ --exclude 'sos_subjects' # tag dicoms and physio
rsync -aiv --log-file=$log_name -e ssh jpfeifer@talapas-ln1.uoregon.edu:/projects/dsnlab/shared/sos/archive/ /Volumes/psych-cog/dsnlab/SOS/archive/ # sos dicoms and physio

## COPY ALL FILES FROM TAG TO EXTERNAL HARDDRIVE ("Chief")
rsync -aiv --log-file=$log_name -P /Volumes/psych-cog/dsnlab/TAG/ /Volumes/Chief/TAG/ # tag
rsync -aiv --log-file=$log_name -P /Volumes/psych-cog/dsnlab/SOS/ /Volumes/Chief/SOS/ # sos

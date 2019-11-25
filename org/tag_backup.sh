#!/bin/bash

# This script copies (a) DICOMS from lcni to our lab, on Talapas, (b) DICOMS & physio from Talapas to CAS server

## TASK BEH DATA (laptops first)
#### Sherri to CAS
rsync -aiv -e ssh FP@10.174.6.120:/Users/FP/Desktop/TAG-fMRI-task/task/input/tag*_info.mat /Volumes/psych-cog/dsnlab/TAG/behavior/task/info/ # inputs
rsync -aiv -e ssh FP@10.174.6.120:/Users/FP/Desktop/TAG-fMRI-task/task/output/* /Volumes/psych-cog/dsnlab/TAG/behavior/task/output/ # outputs 10.109.94.238

#### Terri to CAS - note that foldername is plural (taskS)
rsync -aiv -e ssh FP@10.109.34.8:/Users/FP/Desktop/TAG-fMRI-tasks/task/input/tag*_info.mat /Volumes/psych-cog/dsnlab/TAG/behavior/task/info/ # inputs
rsync -aiv -e ssh FP@10.109.34.8:/Users/FP/Desktop/TAG-fMRI-tasks/task/output/* /Volumes/psych-cog/dsnlab/TAG/behavior/task/output/ # outputs

#### LCNI Desktop (backup) to CAS
rsync -aiv -e ssh dsnlab@controlroommac.uoregon.edu:/Users/dsnlab/Desktop/TAG-fMRI-tasks/task/input/tag*_info.mat /Volumes/psych-cog/dsnlab/TAG/behavior/task/info/ # inputs
rsync -aiv -e ssh dsnlab@controlroommac.uoregon.edu:/Users/dsnlab/Desktop/TAG-fMRI-tasks/task/output/* /Volumes/psych-cog/dsnlab/TAG/behavior/task/output/ # outputs

#### Mock scanner to CAS
rsync -aiv -e ssh dsnlab@simulatormac:/Users/dsnlab/Studies/TAG/task/DRS/task/input/tag*_info.mat /Volumes/psych-cog/dsnlab/TAG/behavior/task/info/ # inputs
rsync -aiv -e ssh dsnlab@simulatormac:/Users/dsnlab/Studies/TAG/task/DRS/task/output/* /Volumes/psych-cog/dsnlab/TAG/behavior/task/output/ # outputs

## NEURO + PHYSIO DATA
## COPY TALAPAS LCNI DICOMS TO TALAPAS DSNLAB ARCHIVE
# RUN THIS LINE USING THE VERSION IN THE TEXT FILE copy_lcni_dicoms_to_dsnlab.txt TO AVOID BACKING UP SOS FILES - it has extra options that are omitted for privacy reasons (ssh jpfeifer@talapas-ln1.uoregon.edu rsync -aiv -P /projects/lcni/dcm/dsnlab/Pfeifer/TAG/TAG???_20* /projects/dsnlab/shared/tag/archive/DICOMS/) # for tag
ssh jpfeifer@talapas-ln1.uoregon.edu rsync -aiv -P /projects/lcni/dcm/dsnlab/Pfeifer/SOS/TAG???_20* /projects/dsnlab/shared/sos/archive/DICOMS/ # for SOS (named correctly)
ssh jpfeifer@talapas-ln1.uoregon.edu rsync -aiv -P /projects/lcni/dcm/dsnlab/Pfeifer/SOS/SOS???_20* /projects/dsnlab/shared/sos/archive/DICOMS/ # for SOS (named incorrectly)

## COPY TALAPAS LCNI PHYSIO TO TALAPAS DSNLAB ARCHIVE
ssh jpfeifer@talapas-ln1.uoregon.edu rsync -aiv -P /projects/lcni/dcm/dsnlab/Pfeifer/TAG/*physio* /projects/dsnlab/shared/tag/archive/physio/
##New TAG physio is now saved in dcm format… no additional backup required
##SOS physio is now saved in dcm format… no additional backup required

# OTHER DATA SHUFFLING
## COPY TALAPAS DSNLAB ARCHIVE TO CAS
rsync -aiv -e ssh jpfeifer@talapas-ln1.uoregon.edu:/projects/dsnlab/shared/tag/archive/ /Volumes/psych-cog/dsnlab/TAG/archive/ --exclude 'sos_subjects' # tag dicoms and physio
rsync -aiv -e ssh jpfeifer@talapas-ln1.uoregon.edu:/projects/dsnlab/shared/sos/archive/ /Volumes/psych-cog/dsnlab/SOS/archive/ # sos dicoms and physio

## COPY ALL FILES FROM TAG TO EXTERNAL HARDDRIVE ("Chief")
rsync -aiv -P /Volumes/psych-cog/dsnlab/TAG/ /Volumes/Chief/TAG/ # tag
rsync -aiv -P /Volumes/psych-cog/dsnlab/SOS/ /Volumes/Chief/SOS/ # sos

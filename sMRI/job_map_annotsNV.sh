#!/bin/bash
#
# This scripts maps the annotation files to the subs
# then makes them into labels, and finally creates
# volume files for each of the labels.
#

echo "job_map_annotsNV.sh ran on $(date)"

echo -e "\nSetting Up Freesurfer6.0"

source /projects/dsnlab/shared/tag/TAG_scripts/sMRI/SetUpFreeSurfer.sh

echo -e "\nMapping labels"

mri_label2label --srclabel /projects/dsnlab/shared/tag/bids_data/derivatives/freesurfer6/nandi/lh_BA9_v3_medial.label --srcsubject fsaverage --trglabel lh_BA9_v3_medial.label --trgsubject $SUBID --regmethod surface --hemi lh
mri_label2label --srclabel /projects/dsnlab/shared/tag/bids_data/derivatives/freesurfer6/nandi/rh_BA9_v3_medial.label --srcsubject fsaverage --trglabel rh_BA9_v3_medial.label --trgsubject $SUBID --regmethod surface --hemi rh
mri_label2label --srclabel /projects/dsnlab/shared/tag/bids_data/derivatives/freesurfer6/nandi/lh_BA10_v3_medial.label --srcsubject fsaverage --trglabel lh_BA10_v3_medial.label --trgsubject $SUBID --regmethod surface --hemi lh
mri_label2label --srclabel /projects/dsnlab/shared/tag/bids_data/derivatives/freesurfer6/nandi/rh_BA10_v3_medial.label --srcsubject fsaverage --trglabel rh_BA10_v3_medial.label --trgsubject $SUBID --regmethod surface --hemi rh
mri_label2label --srclabel /projects/dsnlab/shared/tag/bids_data/derivatives/freesurfer6/nandi/lh_BA11_v3_medial.label --srcsubject fsaverage --trglabel lh_BA11_v3_medial.label --trgsubject $SUBID --regmethod surface --hemi lh
mri_label2label --srclabel /projects/dsnlab/shared/tag/bids_data/derivatives/freesurfer6/nandi/rh_BA11_v3_medial.label --srcsubject fsaverage --trglabel rh_BA11_v3_medial.label --trgsubject $SUBID --regmethod surface --hemi rh

echo -e "\nDone"

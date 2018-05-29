#!/bin/bash
#
# This scripts maps the annotation files to the subs
# then makes them into labels, and finally creates
# volume files for each of the labels.


echo "job_map_annots.sh ran on $(date) $line"

echo -e "\nSetting Up Freesurfer6.0"

source /projects/dsnlab/shared/tag/TAG_scripts/sMRI/SetUpFreeSurfer.sh

mri_annotation2label --subject ${SUBID} --hemi lh --outdir $SUBJECTS_DIR/$SUBID/label/fromannots/
mri_annotation2label --subject ${SUBID} --hemi rh --outdir $SUBJECTS_DIR/$SUBID/label/fromannots/

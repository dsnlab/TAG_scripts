#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Rename mprage files

Problem: After dicom2bids, both mprage_ND (non-distortion corrected) and mprage (corrected) files exist and are labeled as run_01 and run_02 respectively. fMRIprep will average across these T1w files.
   
Solution: This script removes the mprage_ND (run_01) and renames the mprage and corresponding json file (run_02) without a run number

Inputs: 
* Subject list
* Folder containing bids data
* Output folder

Outputs: 
* Reformatted bids data anat files
* Error and output txt files in output folder

Sample command on Talapas:
rename_anat.py '/projects/dsnlab/shared/tag/' 'TAG_scripts/fMRI/ppc/fmriprep_20.2.1/subject_list_test.txt' 'bids_data_sep_wave' 'TAG_scripts/fMRI/ppc/fmriprep_20.2.1/rename_anat_output'

Date: 05/05/2021
"""

import os # standard library
from sys import argv


__author__ = "Theresa Cheng"
__email__ = "tcheng@uoregon.edu"


# Inputs
project_dir=sys.argv[1] # '/projects/dsnlab/shared/tag/'
subject_list_file = sys.argv[2] # 'TAG_scripts/fMRI/ppc/fmriprep_20.2.1/subject_list_test.txt'
bids_data_dir = sys.argv[3]  # 'bids_data_sep_wave'
output_dir = sys.argv[4] # 'TAG_scripts/fMRI/ppc/fmriprep_20.2.1/rename_anat_output'

# read in subject_list_file as subject_list
subject_list_file = open(project_dir + subject_list_file, "r") 
subject_list_file.read()

# rename anat files

for subject_id,wave_num in subject_list

# Delete 
# sub-{subject_id}_ses-{wave_num}_run-01_T1w.json
# sub-{subject_id}_ses-{wave_num}_run-01_T1w.nii.gz
# print("Deleted {subject_id} and {wave_num} mprage_ND")

# Rename
# sub-{subject_id}_ses-{wave_num}_run-02_T1w.json 
#	to sub-{subject_id}_ses-{wave_num}_T1w.json
# print("Renamed {subject_id} and {wave_num} mprage json from run-02 to default")

# Rename
# sub-{subject_id}_ses-{wave_num}_run-02_T1w.nii.gz 
#	to sub-{subject_id}_ses-{wave_num}_T1w.nii.gz
# print("Renamed {subject_id} and {wave_num} mprage nii.gz from run-02 to default")

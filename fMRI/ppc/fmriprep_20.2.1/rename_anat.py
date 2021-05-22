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
* Reformatted files in bids data anat dir

Sample command on Talapas:
python2 rename_anat.py '/projects/dsnlab/shared/tag/' 'TAG_scripts/fMRI/ppc/fmriprep_20.2.1/subject_list_test.txt' 'bids_data_sep_wave' > 'rename_anat_output/rename_anat_output.txt' 

Date: 05/05/2021
"""

import os # standard library
from sys import argv


__author__ = "Theresa Cheng"
__email__ = "tcheng@uoregon.edu"


# Inputs
project_dir=argv[1] # '/projects/dsnlab/shared/tag/'
subject_list_file = argv[2] # 'TAG_scripts/fMRI/ppc/fmriprep_20.2.1/subject_list_test.txt'
bids_data_dir = argv[3]  # 'bids_data_sep_wave'

# read in subject_list_file as subject_list
infile = open(project_dir + subject_list_file, "r") 
subject_list = infile.readlines()
infile.close()

# delete and rename anat files
for line in subject_list: # for each line of the subject list
    sline = line.rstrip()
    sline = sline.split(',') # split lines by comma
    
    sub = sline[0]
    ses = sline[1]
    
    sub_dir = project_dir + bids_data_dir + "sub-" + sub + "/ses-" + ses + "/anat"
    os.chdir(sub_dir)
    print("Changing into " + sub_dir)
    
    del_json_file = "sub-" + sub + "_ses-" + ses + "_run-01_T1w.json"
    del_nii_file = "sub-" + sub + "_ses-" + ses + "_run-01_T1w.nii.gz"
    
    json_init_file = "sub-" + sub + "_ses-" + ses + "_run-02_T1w.json"
    json_target_file = "sub-" + sub + "_ses-" + ses + "_T1w.json"
    
    nii_init_file = "sub-" + sub + "_ses-" + ses + "_run-02_T1w.nii.gz"
    nii_target_file = "sub-" + sub + "_ses-" + ses + "_T1w.nii.gz"
    
    if os.path.exists(del_nii_file):
        os.remove(del_json_file)
        os.remove(del_nii_file)
        print("Deleting " + del_json_file + " " + del_nii_file)

        os.rename(json_init_file, json_target_file)
        print("Replacing " + json_init_file + " with " + json_target_file)

        os.rename(nii_init_file, nii_target_file)
        print("Replacing " + nii_init_file + " with " + nii_target_file)
    
    elif os.path.exists(nii_target_file):
        print("No T1w file renaming needed")

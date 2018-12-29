# This is the configuration file for the dcm2bids_helper script,
# which will use the dcm2bids_helper to create json files
# for use in creating the study specific configuration file
#
# See the dcm2Bids repo for instructions to create the config file:
# https://github.com/cbedetti/Dcm2Bids
#
# More detailed instructions for using these scripts here:
# https://github.com/kdestasio/dcm2bids

import os
# Set study info (may need to change for your study)
# These variables are used only in this file for paths. Can omit if wanted.
group = "dsnlab"
study = "tag"


# The following variables are used in the main script and need to be defined here. 
# They need to exist prior to running the script

# Directories
parentdir = os.path.join(os.sep, "projects", "dsnlab", "shared", "tag") # folder that contains bidsdir and codedir
dicomdir = os.path.join(os.sep, "projects", "lcni", "dcm", "dsnlab", "Pfeifer", "TAG")
bidsdir = os.path.join(parentdir, "bids_data") # where the niftis will be put
codedir = os.path.join(parentdir, "TAG_scripts", "org", "bids-conversion") # Contains subject_list.txt, config file, and dcm2bids_batch.py
logdir = os.path.join(codedir, "logs_helper")

# Log files
outputlog = os.path.join(logdir, "outputlog_helper.txt")
errorlog = os.path.join(logdir, "errorlog_helper.txt")

# Test subject
test_subject = "TAG074_20171013" # Name of a directory that contains DICOMS for one participant

# Run on local machine (run_local = True) or high performance cluster with slurm (run_local = False)
run_local = False

# If false, set the singularity image. Else, set to "NA"
singularity_image =  os.path.join(os.sep, "projects", group, "shared", "BIDS", "SingularityContainers", "Dcm2Bids-master.simg")

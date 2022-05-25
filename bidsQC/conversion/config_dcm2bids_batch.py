import os
from datetime import datetime

######################## CONFIGURABLE PART BELOW ########################

# Set your Talapas user group
group = "dsnlab"
partition = "ctn" # ignored if running locally
singularity_image = "dcm2bids_latest_2021-01-18.sif" # ignored if running locally; dcm2bids singularity image name
config_file = "study_config.json"

# Set directories
# These variables are used in the main script and mustbe defined here.
# They need to exist prior to running the script
path_toplevel = os.path.join(os.sep, "home", "cmccann2", "tag_w3_bids") # folder that contains path_bidsdata and path_conversionfolder
path_dicoms = os.path.join(os.sep, "projects", "dsnlab", "shared", "tag", "archive", "DICOMS")
path_conversionfolder = os.path.join(path_toplevel, "bidsQC", "conversion")  # Contains subject_list.txt, config file, and dcm2bids_batch.py
path_config = os.path.join(path_conversionfolder, config_file)  # Don't cahnge this one
singularity_image = os.path.join(os.sep, "home", "cmccann2", "containers", "dcm2bids_2021-01-18.sif") # Set equal to "NA" if you are running the script locally

# These variables are also used in the main script and need to be defined here.
# If the directories don't exist, they will be created by the script
path_bidsdata = os.path.join(os.sep, "home", "cmccann2", "tag_w3_bids", "bids_data") # Where the niftis will be put
logdir = os.path.join(path_bidsdata, "logs_dcm2bids")
outputlog = os.path.join(logdir, "output_dcmn2bids" + datetime.now().strftime("%Y%m%d-%H%M") + ".txt")
errorlog = os.path.join(logdir, "errors_dcm2bids" + datetime.now().strftime("%Y%m%d-%H%M") + ".txt")

# Source the subject list (needs to be in your current working directory)
subjectlist = "subject_list_test.txt"

# Run on local machine (run_local = True) or high performance cluster with slurm (run_local = False)
run_local = False

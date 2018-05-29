#!/bin/bash -p

#
# SetUpFreeSurfer.sh
#

# This is a sample SetUpFreeSurfer.sh file.
# Edit as needed for your specific setup.
# The defaults should work with most installations.

# Set up FreeSurfer 6.0.0
export FREESURFER_HOME=/packages/freesurfer/6.0.0/freesurfer

# Set this to your subjects/ dir, usually freesurfer/subjects/
export SUBJECTS_DIR=/projects/dsnlab/shared/tag/bids_data/derivatives/freesurfer

# Set this to your functional sessions dir, usually freesurfer/sessions/
if [ -z $FUNCTIONALS_DIR ]; then
    export FUNCTIONALS_DIR=$FREESURFER_HOME/sessions
fi

# Specify the location of the MINC tools.
# Necessary only if the script $FREESURFER_HOME/FreeSurferEnv.csh
# does not find the tools (and issues warnings pertaining to
# the following two environment variables, which have example
# locations that might need user-specific modification):
#export MINC_BIN_DIR=/usr/pubsw/packages/mni/current/bin
#export MINC_LIB_DIR=/usr/pubsw/packages/mni/current/lib
# ... or just disable the MINC toolkit (although some Freesurfer
# utilities will fail!)
#export NO_MINC=1

# Enable or disable fsfast (enabled by default)
#export NO_FSFAST=1

# Call configuration script:
source $FREESURFER_HOME/FreeSurferEnv.sh

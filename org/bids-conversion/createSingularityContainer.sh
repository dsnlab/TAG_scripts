#!/bin/bash

#This script creates singulatiry containers for use on HPC. It needs to be run on a local machine (with Docker installed: Ralph) and then transferred to HPC.

outputdir='/Volumes/psych-cog/dsnlab/BIDS/SingularityContainers'

#docker run --privileged -t --rm \
#    -v /var/run/docker.sock:/var/run/docker.sock \
#    -v ${outputdir}:/output \
#    singularityware/docker2singularity \
#    poldracklab/fmriprep:latest

docker run --privileged -t --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ${outputdir}:/output \
    singularityware/docker2singularity \
    poldracklab/mriqc:latest
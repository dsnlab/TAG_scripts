#!/bin/bash
if [ -z ${1+x} ]
then
    echo "usage: bash `basename $0` /directory/to/receive/task/output/"
    echo "Note that there should be a trailing '/'"
else
    echo "Connecting to scan-room computer..."
    rsync -aiv -e ssh dsnlab@kashkaval:/Users/dsnlab/Studies/TAG/DRS/task/output/*  $1
fi

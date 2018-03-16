#!/bin/bash

if [ -z ${1+x} ]
then
    echo "usage: bash `basename $0` /directory/to/receive/task/info/"
    echo "Note that there should be a trailing '/'"
else
    SIMDIR="$1/simulatum_data/"
    echo "Connecting to scan-room computer..."
    rsync -aiv -e ssh dsnlab@kashkaval:/Users/dsnlab/Studies/TAG/DRS/task/input/tag*_info.mat $1
    if [ ! -d "$SIMDIR"]; then
        mkdir -p $SIMDIR
    fi
    echo "Will save mock-scan data to directory: $SIMDIR"
    echo "Connecting to mock-scan computer..."
    rsync -aiv -e ssh dsnlab@simulatum:/Users/dsnlab/Studies/TAG/task/DRS/task/input/tag*_info.mat $SIMDIR
fi

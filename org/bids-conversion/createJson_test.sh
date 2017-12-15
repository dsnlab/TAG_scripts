#!/bin/bash

# This script will compare the group-level Json parameters (from the scan protocol) to those of each subject. 
# It will create subject-specific Json file if parameters differ from that of the group.
#
# Dependencies:
# * edited createJson_config.sh
# * $subid from batch_createJson.sh

# Load variables

source /projects/dsnlab/shared/tag/TAG_scripts/org/bids-conversion/createJson_config.sh
echo "${subid}"
echo "${sessid}"

#Load packages
module load prl afni

# Create error log file
touch "${errorlog}"

# Create AFNI output with Phase Encoding Direction
echo -e "\nCreating AFNI file"

cd $bidsdir
afnifile="afnifile.csv"
touch "${afnifile}"
echo "sid,file,orient" > $afnifile
filelist=`find sub-$subid -name "*nii.gz"`
for file in $filelist; do
        orient=`3dinfo $file | grep 'orient' | sed -e 's/.*orient \(.*\)\]/\1/'`
        echo "$subid,$file,$orient" >> $afnifile
done

cd $bidsdir
rm $afnifile


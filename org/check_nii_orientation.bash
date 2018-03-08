#!/bin/bash

#Please run this from the directory where the subject folders are located!

#!/bin/bash

#Load afni
module load prl afni

#manual sublist like:
#sub-TAG000
#sub-TAG001
#
#You can also replace a manual list with `ls -1d sub*`
#sublist=`cat ~/sublist.txt`
sublist=`ls -1d sub*`

outputfile=3dinfo_out.csv

echo "sid,file,orient" > $outputfile

for sub in $sublist
do
    filelist=`find $sub -name "*nii.gz"`
    for file in $filelist
    do
        echo ""
        echo ""
        echo "Checking file $file:"
        echo ""
        orient=`3dinfo $file | grep 'orient' | sed -e 's/.*orient \(.*\)\]/\1/'`
        echo "$sub,$file,$orient" >> $outputfile
    done
done

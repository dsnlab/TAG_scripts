#!/bin/bash

#Please run this from the directory where the subject folders are located!

#Path to afni 3dinfo binary (just 3dinfo if it's in your path already)
afniinfo=/usr/lib/afni/bin/3dinfo

#manual sublist like:
#sub-TAG000
#sub-TAG001
#
#You can also replace a manual list with `ls -1d sub*`
#sublist=`cat ~/sublist.txt`
sublist=`ls -1d sub*`

outputfile=test_out.csv

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
        orient=`$afniinfo $file | grep 'orient' | sed -e 's/.*orient \(.*\)\]/\1/'`
        echo "$sub,$file,$orient" >> $outputfile
    done
done

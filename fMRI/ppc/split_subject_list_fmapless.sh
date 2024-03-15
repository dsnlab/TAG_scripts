#!/usr/bin/env bash
## To run: (example)
## ./split_subject_list_fmapless.sh 1<subject_list.txt 3>fmapless.txt 4>fmap.txt

IFS=','
while read tagid wave
do 
  dirname="sub-${tagid}w0${wave##wave}"
  fmapdir="$dirname/ses-wave${wave##wave}/fmap"
  [ ! -e "$dirname" ] && continue

  if [ $(ls -A "$fmapdir" 2>/dev/null | wc -l) -eq 0 ] || [ ! -e "$fmapdir" ]  #list out the fmap directories for each subject; ignore errors; if there is nothing in fmap directory, or if it doesn't exist, then put these subjects in the third file output (which in this case, according to the command, is fmapless.txt)
  then
    # fmap missing
    echo "$tagid,$wave" >&3
  else
    # fmap present
    echo "$tagid,$wave" >&4 #else: if there is something in the fmap directory, put that subject in the fourth file output which, in this case, according to the command, is fmap.txt
  fi
done 


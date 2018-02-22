#!/bin/bash

cd /projects/dsnlab/shared/tag/bids_data/

for tag in sub-TAG*; do

rm "${tag}"/ses-wave?/func/*json
rm "${tag}"/ses-wave?/anat/*json
rm "${tag}"/ses-wave?/fmap/*json
rm "${tag}"/ses-wave?/dwi/*json

done


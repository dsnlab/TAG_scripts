
Scripts for automated assessment of motion artifacts in TAG fMRI data based on changes in translation and rotation parameters, Framewise Displacement and DVARS.

## To use this package, run the scripts in the following order:
### 1. extract_rawMotion.Rmd
This script reads in confounds.tsv files from fmriprep output folders, and saves X,Y,Z,ptich,roll,yaw parameters for each subject. 

### 2.create_eucMotion.r
This script takes the rp text files generated from the prior step and calculates Euclidian composite scores for X,Y,Z translation and pitch, yaw, roll rotation.

### 3. auto-motion-fmriprep.Rmd
This script calculates a trash regressor for motion artifacts using a combination of Framewise Displacement and DVARS. The combination of the Euclidean parameters and this trash regressor produce the final rp_txt files. 


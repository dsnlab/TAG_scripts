#!/bin/bash

module load fsl 

indir=/projects/dsnlab/shared/tag/bids_data/derivatives/fmriprep/
outdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/masks/

SUBJLIST=`cat maskSubjects.txt`

for subj in $SUBJLIST

do

fslmaths "${indir}"'sub-'"${subj}"'/ses-wave1/anat/sub-'"${subj}"'_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -s 6 "${outdir}"'ssub-'"${subj}"'_ses-wave1_T1w_space-
MNI152NLin2009cAsym_brainmask.nii.gz'

done

cd $outdir

fslmaths 'ssub-TAG001_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG002_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG004_ses-w
ave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG005_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG006_ses-wave1_T1w_space-MNI152NLin20
09cAsym_brainmask.nii.gz' -add 'ssub-TAG007_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG008_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -
add 'ssub-TAG009_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG010_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG011_ses-wave1_
T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG012_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG013_ses-wave1_T1w_space-MNI152NLin2009cAs
ym_brainmask.nii.gz' -add 'ssub-TAG014_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG015_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add '
ssub-TAG016_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG018_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG019_ses-wave1_T1w_s
pace-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG020_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG022_ses-wave1_T1w_space-MNI152NLin2009cAsym_br
ainmask.nii.gz' -add 'ssub-TAG023_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG024_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-
TAG026_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG027_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG028_ses-wave1_T1w_space-
MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG030_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG032_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainma
sk.nii.gz' -add 'ssub-TAG033_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG034_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG03
5_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG036_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG037_ses-wave1_T1w_space-MNI15
2NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG038_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG040_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.ni
i.gz' -add 'ssub-TAG041_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG042_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG044_ses
-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG045_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG046_ses-wave1_T1w_space-MNI152NLin
2009cAsym_brainmask.nii.gz' -add 'ssub-TAG047_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG048_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz'
 -add 'ssub-TAG049_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG050_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG051_ses-wave
1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG052_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG053_ses-wave1_T1w_space-MNI152NLin2009c
Asym_brainmask.nii.gz' -add 'ssub-TAG054_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG055_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add
 'ssub-TAG056_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG057_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG058_ses-wave1_T1w
_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG059_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG060_ses-wave1_T1w_space-MNI152NLin2009cAsym_
brainmask.nii.gz' -add 'ssub-TAG062_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG064_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssu
b-TAG065_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG066_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG067_ses-wave1_T1w_spac
e-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG068_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG069_ses-wave1_T1w_space-MNI152NLin2009cAsym_brain
mask.nii.gz' -add 'ssub-TAG070_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG071_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG
072_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG074_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG075_ses-wave1_T1w_space-MNI
152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG076_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG077_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.
nii.gz' -add 'ssub-TAG078_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG080_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG081_s
es-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG083_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG084_ses-wave1_T1w_space-MNI152NL
in2009cAsym_brainmask.nii.gz' -add 'ssub-TAG085_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG086_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.g
z' -add 'ssub-TAG087_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG088_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG089_ses-wa
ve1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG090_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG091_ses-wave1_T1w_space-MNI152NLin200
9cAsym_brainmask.nii.gz' -add 'ssub-TAG094_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG095_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -a
dd 'ssub-TAG099_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG100_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG101_ses-wave1_T
1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG102_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG103_ses-wave1_T1w_space-MNI152NLin2009cAsy
m_brainmask.nii.gz' -add 'ssub-TAG104_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG105_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 's
sub-TAG106_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG107_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG109_ses-wave1_T1w_sp
ace-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG110_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG111_ses-wave1_T1w_space-MNI152NLin2009cAsym_bra
inmask.nii.gz' -add 'ssub-TAG112_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG113_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-T
AG114_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG116_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG119_ses-wave1_T1w_space-M
NI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG120_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG122_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmas
k.nii.gz' -add 'ssub-TAG124_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG125_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG127
_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG130_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG131_ses-wave1_T1w_space-MNI152
NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG132_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG137_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii
.gz' -add 'ssub-TAG138_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG140_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG141_ses-
wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG143_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG144_ses-wave1_T1w_space-MNI152NLin2
009cAsym_brainmask.nii.gz' -add 'ssub-TAG145_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG147_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' 
-add 'ssub-TAG149_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG152_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG155_ses-wave1
_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG159_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG160_ses-wave1_T1w_space-MNI152NLin2009cA
sym_brainmask.nii.gz' -add 'ssub-TAG164_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG165_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 
'ssub-TAG166_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG167_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG169_ses-wave1_T1w_
space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG173_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG174_ses-wave1_T1w_space-MNI152NLin2009cAsym_b
rainmask.nii.gz' -add 'ssub-TAG175_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG176_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub
-TAG177_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG179_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG180_ses-wave1_T1w_space
-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG181_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG186_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainm
ask.nii.gz' -add 'ssub-TAG188_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG190_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG1
92_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG194_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG200_ses-wave1_T1w_space-MNI1
52NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG202_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG203_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.n
ii.gz' -add 'ssub-TAG206_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG207_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG208_se
s-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG209_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG210_ses-wave1_T1w_space-MNI152NLi
n2009cAsym_brainmask.nii.gz' -add 'ssub-TAG211_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG215_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz
' -add 'ssub-TAG218_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG220_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG221_ses-wav
e1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG223_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG224_ses-wave1_T1w_space-MNI152NLin2009
cAsym_brainmask.nii.gz' -add 'ssub-TAG225_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG232_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -ad
d 'ssub-TAG233_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG238_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG240_ses-wave1_T1
w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG243_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG244_ses-wave1_T1w_space-MNI152NLin2009cAsym
_brainmask.nii.gz' -add 'ssub-TAG247_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG250_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ss
ub-TAG252_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG253_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG261_ses-wave1_T1w_spa
ce-MNI152NLin2009cAsym_brainmask.nii.gz' -add 'ssub-TAG266_ses-wave1_T1w_space-MNI152NLin2009cAsym_brainmask.nii.gz' groupMask.nii.gz

#create thresholded mask, binarized to 15% (also 25 subjects out of 164).
fslmaths groupMask.nii.gz -thr 25 -bin groupMask.nii.gz
gunzip groupMask.nii.gz

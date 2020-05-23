
#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the job_reconall.sh file for
# each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your study
STUDY=/projects/dsnlab/shared/tag

# Set subject list
SUBJLIST=`cat subject_list_n21_52220.txt`

# 
for SUBJ in $SUBJLIST
do
 sbatch --export SUBID=${SUBJ} --job-name=reconall_w2 --account=dsnlab --mem-per-cpu=8G  -o "${STUDY}"/TAG_scripts/sMRI/output/"${SUBJ}"_recon$
 /packages/racs/bin/slurm-throttle 
done



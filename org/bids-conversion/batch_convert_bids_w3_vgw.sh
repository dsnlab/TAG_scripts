#!/bin/bash
#
# TODO: Update this description
# This batch file calls on your subject
# list (named subject_list.txt) in the 
# script directory. And runs the specified job 
# file for each subject. It saves the ouput
# and error files in their specified
# directories.


# SYNOPSIS
#     ./batch_convert_bids_w3_vgw.sh [OPTIONS] SUBJ_LIST
# 
# DESCRIPTION
#     Batch-converts the subjects listed in the SUBJ_LIST file.
# 
#     -d, --data-base-dir=DBDIR
#             The DBDIR argument is the base DICOMS directory. The default
#             value is: /gpfs/projects/dsnlab/shared/tag/archive/DICOMS
#     -o, --output-dir=OUTDIR
#             The OUTDIR argument is the name of the output directory. The
#             default behavior is to produce a timestamped directory
#             `./output_w3_vgw/<Timestamp>/' for each batch run.
#     -c, --config=CONFIG_SCRIPT
#             The CONFIG_SCRIPT argument is the name of the configuration
#             script that is run by the conversion script on each run,
#             containing options for which conversions to perform, etc. By
#             default, it searches for a file named
#             `convert_bids_config_w3_vgw.sh' in the same directory as the
#             `batch_convert_bids_w3_vgw.sh' script. 
#     -s, --script=SBATCH_SCRIPT
#             The SBATCH_SCRIPT argument is the name of the actual conversion
#             script that is run for each item in the subject list. By
#             default, it searches for a file named `convert_bids_w3_vgw.sh'
#             in the same directory as the `batch_conver_bids_w3.vgw.sh'
#             script
# 
# EXAMPLES
#     ./batch_convert_bids_w3_vgw.sh subject_list_w3_vgw.txt
#     ./batch_convert_bids_w3_vgw.sh -c custom_config.sh custom_subject_list.txt
#     etc.


# Basedir is the location of THIS script. We assume that the sbatch and config scripts are in the same directory
# All three scripts must be in the same directory, or the lines below must be updated 
basedir="$(readlink -f "$(dirname "$0")")" # Hack to get this file's location, even if working directory is different
sbatch_script="$basedir/convert_bids_w3_vgw.sh" # Location of convert_bids script to run on each DICOM
config_script="$basedir/convert_bids_config_w3_vgw.sh" # Location of convert_bids_config script that convert_bids sources

#Set defaults
output_dir="$(readlink -f ./)/output_w3_vgw/$(date +%y.%m.%d-%k:%M)" # Where to put results; defaults to current working directory
data_base_dir="/gpfs/projects/dsnlab/shared/tag/archive/DICOMS" # Location of raw DICOM data
mkdir -p "$output_dir"

#Process command-line options
OPTS=$(getopt -n $0 -o d:o:c: -l data_base_dir:,output_dir:,config: -- $@)
eval set -- "${OPTS[@]}"
while true; do
  case "$1" in
    -d | --data-base-dir)
      data_base_dir="$2"
      shift 2
      ;;
    -o | --output-dir)
      output_dir="$2"
      shift 2
      ;;
    -c | --config)
      config_script="$2"
      shift 2
      ;;
    -s | --script)
      sbatch_script="$2"
      shift 2
      ;;
    --) shift; break;;
    *) break;;
  esac
done

if [[ $# -lt 1 ]]
then
  printf "Usage: %s [-o|--output-dir OUTDIR] [-d|--data-base-dir DBDIR] [-c|--config CONFIG_SCRIPT] [-s|--script SBATCH_SCRIPT] SUBJ_LIST\n" "$0" >&2
  exit 1
fi
  
subj_list="$1"
exec 4<"$subj_list"

function getline() {
  export REPLY
  if read
  then
    IFS=$'\n' REPLY=($(xargs -n1 <<<"$REPLY"))
    return 0
  else
    return 1
  fi
}
getline <&4
HEADERS=("${REPLY[@]}")

while getline
do
  SUBJID="${REPLY[0]}"
  SESSID="${REPLY[1]}"
  INDIR="$data_base_dir/${REPLY[2]}"
  echo "$INDIR -> $SUBJID/$SESSID"
  mkdir -p "$output_dir/bcb" 
  sbatch  \
    --export sessid="$SESSID",subid="$SUBJID",dicomdir="$INDIR",outdir="$output_dir",config_script="$config",scriptsdir="$basedir"  \
    --job-name convertBIDS_"$SUBJID-$SESSID"  \
    --account=dsnlab  \
    --partition=ctn  \
    --time 00:60:00  \
    --mem-per-cpu=2G  \
    --cpus-per-task=1 \
    -o "$output_dir/bcb/$SUBJID-$SESSID-stdout.txt" \
    -e "$output_dir/bcb/$SUBJID-$SESSID-stderr.txt" \
    "$sbatch_script"
done <&4

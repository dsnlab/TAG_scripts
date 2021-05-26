# DSD Motion Summary
# T Cheng | May 25, 2021

# Load packages
packages <- c("tidyr", "dplyr", "psych", "rio")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}
lapply(packages, library, character.only = TRUE)

# Set variables
input_file <- "/Volumes/psych-cog/dsnlab/TAG/bids_data/derivatives/fmriprep_20.2.1_QC/TAG_summaryRun.csv"

# Read inputs
motion_summary <- import(input_file)

# Summarize DSD
dsd_summary <- filter(motion_summary, task == "DSD") %>% 
  mutate(motion = case_when(
    round(percent, 0) > 20 ~ "exclude",
    round(percent, 0) > 15 &  round(percent, 0) <= 20 ~ "inspect",
    round(percent, 0) <=15 ~ "ok"))

dsd_exclude <- dsd_summary[which(dsd_summary$motion == "exclude"), ]
dsd_inspect <- dsd_summary[which(dsd_summary$motion == "inspect"), ] 
dsd_inspect <- dsd_inspect[order(dsd_inspect$wave),]

nrow(dsd_inspect %>% filter(wave == "wave1"))




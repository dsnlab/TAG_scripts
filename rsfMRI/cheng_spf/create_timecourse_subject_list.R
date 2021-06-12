## Create subject list for timecourse extraction 

# Load packages
packages <- c("tidyverse", "stringr", "rio")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}
lapply(packages, library, character.only = TRUE)

# Set variables
inclusion_info_dir <-'/home/tcheng/xcpengine/data/'
output_dir <- '/projects/dsnlab/shared/tag/TAG_scripts/rsfMRI/cheng_spf'
  
func_cohort <- import(paste0(inclusion_info_dir, "func_cohort_files/func_cohort_tag_single_runs.csv"))

subject_list <- func_cohort %>% 
  select(id0, id1, id2)

colnames(subject_list) <- c("subject_id", "wave", "run")

subject_list$subject_id <- unlist(lapply(str_split(subject_list$subject_id, "-TAG"), function(x){x[[2]]}))
subject_list$wave <- unlist(lapply(str_split(subject_list$wave, "-"), function(x){x[[2]]}))
subject_list$run <- unlist(lapply(str_split(subject_list$run, "-"), function(x){x[[2]]}))

write.table(subject_list, paste0(output_dir, "/subject_list.txt"), row.names = FALSE, quote = FALSE, sep = ",")

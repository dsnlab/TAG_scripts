# Check xcpengine output
# T Cheng | June 9, 2021 

# Load packages
packages <- c("ggplot2", "tidyverse", "stringr", "knitr", "rio", "snakecase")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}
lapply(packages, library, character.only = TRUE)

# Set inputs
data_dir <- '/projects/dsnlab/shared/tag/fmriprep_20.2.1/xcp_output'
inclusion_info_dir <-'/home/tcheng/xcpengine/data/'
func_cohort_file <- 'func_cohort_files/func_cohort_tag_single_runs.csv'
# output_dir <- '/projects/dsnlab/shared/tag/fmriprep_20.2.1/fmriprep/derivatives'

# important info
func_cohort <- import(paste0(inclusion_info_dir, func_cohort_file))

# create a list of output files 
output <- apply(func_cohort, 1, function(x){
  
  id0 <- x[[1]]
  id1 <- x[[2]]
  id2 <- x[[3]]
    
  paste0(data_dir, "/", id0, "/", id1, "/", id2, "/regress/", id0, "_", id1, "_", id2, "_residualised.nii.gz")
})

output_df <- as.data.frame(do.call(rbind, as.list(output)))
colnames(output_df) <- "file_names"
output_df$file_names <- as.character(output_df$file_names)

output_df$file_exists <- file.exists(output_df$file_names)

missing_file_idx <- which(output_df$file_exists == FALSE)
output_df[missing_file_idx, ]

# okay, one subset of errors has to do with Bus errors: 
# bus_error_indices <-import(paste0(inclusion_info_dir, "/bus_error_indices.txt"), header = FALSE)
# func_cohort_bus_errors <- func_cohort[bus_error_indices$V1, ]
# write.table(func_cohort_bus_errors, paste0(inclusion_info_dir, "/func_cohort_files/func_cohort_bus_errors.csv"), row.names = FALSE, quote = FALSE, sep = ",")

func_cohort_rerun <- func_cohort[missing_file_idx[!(missing_file_idx %in% bus_error_indices$V1)], ]
# write.table(func_cohort_rerun, paste0(inclusion_info_dir, "/func_cohort_files/func_cohort_rerun.csv"), row.names = FALSE, quote = FALSE, sep = ",")

single_subject <- func_cohort[which(func_cohort$id0 == "sub-TAG181w02" & func_cohort$id1 == "ses-wave2" & func_cohort$id2 == "run-1"), ]
write.table(single_subject, paste0(inclusion_info_dir, "/func_cohort_files/func_cohort_single_subject.csv"), row.names = FALSE, quote = FALSE, sep = ",")


# Get average PSE per wave
# T Cheng | Feb 28, 2020

# load packages, install as needed
packages = c("tidyr", "dplyr", "ggplot2", "rio")

package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE) }})

## load and clean data
inputDir <- '/Volumes/psych-cog/dsnlab/TAG/behavior/task/processed/DSD/' 
headers <- c("subject_id", "PSE_neutral", "PSE_affect", "PSE_all", "equal_per_neutral", "equal_per_affect", "equal_per_all", "loss_per_neutral", "loss_per_affect", "loss_per_all") # in matlab: headers = {'subj_num','PSE_neutral','PSE_affect','PSE_all','equal_%_neutral','equal_%_affect','equal_%_all','loss_%_neutral','loss_%_affect','loss_%_all'};

w1_pse_df <- import(paste0(inputDir, 'W1_results_no_hdr_11June18.csv'))
colnames(w1_pse_df) <- headers
w1_pse_df$wave = 1

w2_pse_df <- import(paste0(inputDir, 'W2_results_no_hdr_20Feb20.csv'))
colnames(w2_pse_df) <- headers 
w2_pse_df$wave = 2

w3_pse_df <- import(paste0(inputDir, 'W3_results_no_hdr_20Feb20.csv'))
w3_pse_df_extras <- import(paste0(inputDir, 'results_no_hdr_W3_extras_26Feb20.csv'))
w3_pse_df_precovid <- import(paste0(inputDir, 'results_no_hdr_W3_pre_covid_17Jun21.csv'))
w3_pse_df <- rbind(w3_pse_df, w3_pse_df_extras, w3_pse_df_precovid)
colnames(w3_pse_df)<- headers 
w3_pse_df$wave = 3

pse_df <- rbind(w1_pse_df, w2_pse_df, w3_pse_df)
pse_df$wave <- as.factor(pse_df$wave)

pse_df_summary <- pse_df %>% 
  group_by(wave) %>% 
  summarise(mean_neutral_PSE = mean(PSE_neutral),
            sd_neutral_PSE = sd(PSE_neutral), 
            mean_affect_PSE = mean(PSE_affect),
            sd_affect_PSE = sd(PSE_affect),
            mean_all_PSE = mean(PSE_all),
            sd_all_PSE = sd(PSE_all),  # "equal_%_neutral", "equal_%_affect", "equal_%_all", "loss_%_neutral", "loss_%_affect", "loss_%_all")
            mean_equal_per_neutral = mean(equal_per_neutral, na.rm = TRUE),
            sd_equal_per_neutral = sd(equal_per_neutral, na.rm = TRUE), 
            mean_equal_per_affect = mean(equal_per_affect, na.rm = TRUE),
            sd_equal_per_affect = sd(equal_per_affect, na.rm = TRUE),
            mean_loss_per_neutral = mean(loss_per_neutral, na.rm = TRUE),
            sd_loss_per_neutral = sd(loss_per_neutral, na.rm = TRUE),
            mean_loss_per_affect = mean(loss_per_affect, na.rm = TRUE),
            sd_loss_per_affect = sd(loss_per_affect, na.rm = TRUE)) #%>% 
  #pivot_longer(cols = -wave, names_to = "param", values_to = "values")

write.csv(pse_df, paste0(inputDir, "disclosure_data_waves123_20210617.csv"))
write.csv(pse_df_summary, paste0(inputDir, "disclosure_summary_allWaves_20210617.csv"))

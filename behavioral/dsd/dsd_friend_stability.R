# DSD Friend Stability

# load packages, install as needed
packages = c("tidyr", "dplyr", "ggplot2", "rio")

package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE) }})


## load and clean data
inputDir <- '/Volumes/psych-cog/dsnlab/TAG/behavior/MRI/' 

w1_df <- import(paste0(inputDir, 'Wave1/DSD/W1_friendname.csv')) %>% 
  mutate(wave = 1)
w2_df <- import(paste0(inputDir, 'Wave2/DSD/TAG_W2_DSDfriend.csv'))
w3_df <- import(paste0(inputDir, 'Wave3/DSD/TAG_W3_DSDfriend.csv')) %>% 
  mutate(wave = 3)

# clean w2_df: W2S2_friend_name is very sparse. I'm asusming that if the W2S2_friend_name was left blank, but if the participant completed the crq_friend item (saying whether or not the co-rumination questionnaire was completed with their friend in mind) then i used their W2S1_friend_name variable. not sure if this is a good idea or not.

w2_df$friend_name = ifelse(is.na(w2_df$W2S2_friend_name) & (w2_df$crq_friend > 0), w2_df$W2S1_friend_name, w2_df$W2S2_friend_name)

w2_df <- w2_df %>% 
  select(c("SID", "friend_name")) %>% 
  mutate(wave = 2)

colnames(w2_df)[1] = "ID"

w3_df$ID <- sub("_", "", w3_df$ID)

friends_df <- rbind(w1_df, w2_df, w3_df)
friends_df_wide <- pivot_wider(friends_df, id_cols = "ID", names_from = wave, values_from = friend_name, names_prefix = "wave_")

# fix differences in TAG ID naming
# note that about 80% of the w3_df$IDs have an underscore
# remove this underscore

## generate variables corresponding to if friend stayed the same between waves

friends_df_wide <- friends_df_wide %>% 
  mutate(w1_w2_same = (wave_1 == wave_2),
         w2_w3_same = (wave_2 == wave_3),
         w1_w3_same = (wave_1 == wave_3),
         all_waves_same = (wave_1 == wave_2) & (wave_2 == wave_3))

# manual correction
friends_df_wide$w1_w2_same <- ifelse(friends_df_wide$ID %in% c("TAG003", "TAG035", "TAG084", "TAG143"), TRUE, friends_df_wide$w1_w2_same)
friends_df_wide$w2_w3_same <- ifelse(friends_df_wide$ID == "TAG035", TRUE, friends_df_wide$w2_w3_same)
friends_df_wide$w1_w3_same <- ifelse(friends_df_wide$ID %in% c("TAG007", "TAG016", "TAG034", "TAG035", "TAG084"), TRUE, friends_df_wide$w1_w3_same)
friends_df_wide$all_waves_same <- ifelse(friends_df_wide$ID == "TAG084", TRUE, friends_df_wide$all_waves_same)

# unclear TAG138 TAG141 TAG169
friends_df_wide$any_same <- friends_df_wide$w1_w2_same | friends_df_wide$w2_w3_same | friends_df_wide$w1_w3_same
sum(friends_df_wide$any_same, na.rm = TRUE)

# remove subjects for whom W3 is NA
nrow(friends_df_wide[!is.na(friends_df_wide$wave_3), ])

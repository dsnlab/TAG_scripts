setwd("/Volumes/psych-cog/dsnlab/TAG/behavior/MRI/Wave1")
      
MRI_overview <- read.csv("MRI_W1overview.csv")
MRI_overview <- MRI_overview %>% filter(!SID==0) %>%
  filter(Withdrawn_W1==0) 

summary(as.factor(MRI_overview$check_mri_completed.2.partial.1.full.0.none.))

MRI_overview <- MRI_overview %>% filter(!check_mri_completed.2.partial.1.full.0.none. == 0)
MRI_overview <- MRI_overview %>% mutate(dsd_completed = ifelse(dsd1_num == 0 & dsd2_num == 0, 0,
                                                               ifelse(!dsd1_num == 0 & dsd2_num == 0, 1,
                                                                      ifelse(dsd1_num == 0 & !dsd2_num == 0,1,2))))
MRI_overview <- MRI_overview %>% arrange(dsd_completed)
summary(as.factor(MRI_overview$dsd_completed))

excluded <- MRI_overview %>% filter(!dsd_completed == 2)

write.csv(MRI_overview,"dsd_overview.csv")

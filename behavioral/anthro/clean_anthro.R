install.packages("measurements")
library(measurements)

options(digits=5)

anthro <- read.csv(paste0(cas_dir,'/Behavior/Anthro/Wave1/TAG_W1_anthro.csv'),na.strings=c("","NA"))

anthro_cleaned <- anthro %>% filter(!SID==0) %>%
  mutate(weight_1=as.numeric(as.character(weight_1)),
         weight_2=as.numeric(as.character(weight_2)),
         weight_3=as.numeric(as.character(weight_3))) %>%
  rowwise %>%
  mutate(height=ifelse(is.na(height_3), mean(c(height_1,height_2),na.rm=T),
                       ifelse(!is.na(height_3), median(c(height_1,height_2,height_3)),NA))) %>%
  mutate(waist=ifelse(is.na(waist_3), mean(c(waist_1,waist_2),na.rm=T),
                      ifelse(!is.na(waist_3), median(c(waist_1,waist_2,waist_3)),NA))) %>%
  mutate(weight=ifelse(is.na(weight_3), mean(c(weight_1,weight_2),na.rm=T),
                       ifelse(!is.na(weight_3), median(c(weight_1,weight_2,weight_3)),NA))) %>%
  select(SID,height_1,height_2,height_3,height,height_system,weight_1,weight_2,weight_3,weight,weight_system,
         waist_1,waist_2,waist_3,waist,waist_system) %>%
  mutate(weight_system = ifelse(SID=="054",2,weight_system)) %>%
  mutate(weight = ifelse(weight_system==1, (conv_unit(weight,"kg","lbs")), weight),
         height = ifelse(height_system==3, (conv_unit(height,"inch","cm")), height),
         waist = ifelse(waist_system==3, (conv_unit(waist,"inch","cm")), waist))

overview <- read.xlsx(paste0(cas_dir,'behavior/Overview/Overview_Withdrawn_Completed/TAG_Overview_Doc.xlsx'),1)
overview <- overview[,c("TAG_ID","W1S2_Completed","Withdrawn_W1","Exclusionary_Withdrawl")]

#removing everyone who withdrew at W1 (exclusionary withdrawals)
overview <- overview %>% 
  rename(SID = TAG_ID) %>%
  replace_na(list(Withdrawn_W1 = 0)) %>%
  replace_na(list(Exclusionary_Withdrawl = 0)) %>% 
  arrange(Exclusionary_Withdrawl) %>% 
  mutate(SID=as.numeric(gsub("[^0-9\\.]", "", SID))) %>%
  filter(Exclusionary_Withdrawl==0) %>%
  select(SID)

anthro_cleaned <- anthro_cleaned %>% right_join(.,overview) 

write.csv(anthro_cleaned,'/Volumes/psych-cog/dsnlab/TAG/behavior/Anthro/Wave1/TAG_W1_anthro_processed.csv',row.names=F)
  

install.packages("measurements")
library(measurements)
library(dplyr)

options(digits=5)
cas_dir = '/Volumes/psych-cog/dsnlab/TAG/behavior/'

#load raw data
anthro1 <- read.csv(paste0(cas_dir,'Anthro/Wave1/TAG_W1_anthro_copy.csv'),na.strings=c("","NA"))
anthro2 <- read.csv(paste0(cas_dir,'Anthro/Wave2/TAG_W2_anthro.csv'),na.strings=c("","NA"))
anthro3 <- read.csv(paste0(cas_dir,'Anthro/Wave3/TAG_W3_Anthro_overview.csv'),na.strings=c("","NA"))

#calculate final heigth,weight,waist for wave 1
anthro1_cleaned <- anthro1 %>% filter(!SID==0) %>%
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
  mutate(weight_lbs = ifelse(weight_system==1, (conv_unit(weight,"kg","lbs")), weight),
         weight_kg = ifelse(weight_system==2, (conv_unit(weight,"lbs","kg")), weight),
         height = ifelse(height_system==3, (conv_unit(height,"inch","cm")), height),
         waist = ifelse(waist_system==3, (conv_unit(waist,"inch","cm")), waist),
         BMI = weight_kg/(height/100)^2) %>%
  select(-weight)

#calculate final heigth,weight,waist for wave 2
anthro2_cleaned <- anthro2 %>% filter(!SID==0) %>%
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
  mutate(weight_lbs = ifelse(weight_system==1, (conv_unit(weight,"kg","lbs")), weight),
         weight_kg = ifelse(weight_system==2, (conv_unit(weight,"lbs","kg")), weight),
         height = ifelse(height_system==3, (conv_unit(height,"inch","cm")), height),
         waist = ifelse(waist_system==3, (conv_unit(waist,"inch","cm")), waist),
         BMI = weight_kg/(height/100)^2) %>%
  select(-weight)

#calculate final heigth,weight,waist for wave 3
anthro3_cleaned <- anthro3 %>% 
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
  mutate(weight_lbs = ifelse(weight_system==1, (conv_unit(weight,"kg","lbs")), weight),
         weight_kg = ifelse(weight_system==2, (conv_unit(weight,"lbs","kg")), weight),
         height = ifelse(height_system==3, (conv_unit(height,"inch","cm")), height),
         waist = ifelse(waist_system==3, (conv_unit(waist,"inch","cm")), waist),
         BMI = weight_kg/(height/100)^2) %>%
  select(-weight)


#removing everyone who was excluded or withdrew at W1 
overview <- read.csv(paste0(cas_dir,'Overview/TAGfinal174.csv'),1) %>%
  mutate(SID=as.numeric(gsub("[^0-9\\.]", "", tagid)))
anthro1_cleaned <- anthro1_cleaned %>% right_join(.,overview) 
anthro2_cleaned <- anthro2_cleaned %>% right_join(.,overview)
anthro3_cleaned <- anthro3_cleaned %>% right_join(.,overview)

# check for outliers / distribution
ggplot(anthro1_cleaned,aes(x=height)) + geom_histogram() + theme_minimal()
ggplot(anthro1_cleaned,aes(x=weight_kg)) + geom_histogram() + theme_minimal()
ggplot(anthro1_cleaned,aes(x=waist)) + geom_histogram() + theme_minimal()
ggplot(anthro1_cleaned,aes(x=BMI)) + geom_histogram() + theme_minimal()

ggplot(anthro2_cleaned,aes(x=height)) + geom_histogram() + theme_minimal()
ggplot(anthro2_cleaned,aes(x=weight_kg)) + geom_histogram() + theme_minimal()
ggplot(anthro2_cleaned,aes(x=waist)) + geom_histogram() + theme_minimal()
ggplot(anthro2_cleaned,aes(x=BMI)) + geom_histogram() + theme_minimal()

ggplot(anthro3_cleaned,aes(x=height)) + geom_histogram() + theme_minimal()
ggplot(anthro3_cleaned,aes(x=weight_kg)) + geom_histogram() + theme_minimal()
ggplot(anthro3_cleaned,aes(x=waist)) + geom_histogram() + theme_minimal()
ggplot(anthro3_cleaned,aes(x=BMI)) + geom_histogram() + theme_minimal()

#save processed data
write.csv(anthro1_cleaned,paste0(cas_dir,'Anthro/Wave1/TAG_W1_anthro_processed.csv'),row.names=F)
write.csv(anthro2_cleaned,paste0(cas_dir,'Anthro/Wave2/TAG_W2_anthro_processed.csv'),row.names=F)
write.csv(anthro3_cleaned,paste0(cas_dir,'Anthro/Wave3/TAG_W3_anthro_processed.csv'),row.names=F)

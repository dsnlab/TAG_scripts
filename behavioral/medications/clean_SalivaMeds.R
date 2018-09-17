#Set directories
```{r}
cas_dir <- '/Volumes/psych-cog/dsnlab/TAG/'
med_dir <- paste0(cas_dir,'behavior/Medications')
saliva_dir <- paste0(cas_dir,'behavior/Puberty/Saliva/Wave1')
```

#Load med data
```
med_df <- read.csv(paste0(med_dir,'/TAS_W1_Saliva_meds.csv'))
med_df <- med_df %>% select(-Saliva_form_endorsed) %>%
  mutate(SID=gsub("[^0-9\\.]", "", TAG_ID)) %>%
  mutate(SID = as.factor(SID)) %>%
  select(-TAG_ID) %>%
  gather(., class, code, -SID) %>%
  mutate(class = paste0('class_',code)) %>%
  filter(!class == "class_NA") %>%
  mutate(code = 1) %>%
  spread(class,code)

med_df <- replace(med_df, is.na(med_df), 0)
```

#import saliva forms
```{r}
form_df <- read.csv(paste0(saliva_dir,'/W1_at_home_saliva_overview.csv'))
form_df <- form_df %>% select(subject_spit_id,any_forms_completed) %>%
  mutate(SID=gsub("[^0-9\\.]", "", subject_spit_id)) %>%
  mutate(SID = as.factor(SID)) %>%
  select(SID, any_forms_completed) %>%
  filter(!SID=="")

med_df2 <- form_df %>% left_join(.,med_df) %>% 
  gather(code,use,-SID,-any_forms_completed) %>%
  mutate(use = ifelse(is.na(use) & (any_forms_completed == 1),0,use)) %>%
  spread(code,use)
```  
  
#limit to our final dataset of 182
```{r, include = F}
overview <- read.xlsx(paste0(cas_dir,'behavior/Overview/Overview_Withdrawn_Completed/TAG_Overview_Doc.xlsx'),1)
overview <- overview[,c("TAG_ID","W1S2_Completed","Withdrawn_W1","Exclusionary_Withdrawl")]

#removing everyone who withdrew at W1 (exclusionary withdrawals)
overview <- overview %>% 
  rename(SID = TAG_ID) %>%
  replace_na(list(Withdrawn_W1 = 0)) %>%
  replace_na(list(Exclusionary_Withdrawl = 0)) %>% 
  arrange(Exclusionary_Withdrawl) %>% 
  mutate(SID=gsub("[^0-9\\.]", "", SID)) %>%
  filter(Exclusionary_Withdrawl==0) 

med_df <- med_df %>% filter(SID %in% overview$SID)
write.csv(med_df,paste0(med_dir,'/TAG_W1_Saliva_meds_processed.csv'),row.names=F)
```


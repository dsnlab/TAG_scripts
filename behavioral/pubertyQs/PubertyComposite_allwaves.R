
###LOAD PACKAGES AND SET DIRECTORIES ######
packages <- c("psych","xlsx","dplyr")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}
lapply(packages, library, character.only = TRUE)
cas_dir <- 'Y:/dsnlab/TAG/'
age_dir <- paste0(cas_dir,'behavior/Demographics/Age/')
quest_dir <- paste0(cas_dir,'behavior/Questionnaires/')
puberty_dir <- paste0(cas_dir,'behavior/Questionnaires/Puberty/')
options(digits=3)

###IMPORT TAG OVERVIEW DOC FROM CAS ######
overview <- read.xlsx(paste0(cas_dir,'behavior/Overview/Overview_Withdrawn_Completed/TAG_Overview_Doc.xlsx'),1)
overview <- overview[,c("TAG_ID","W1S2_Completed","Withdrawn_W1","Exclusionary_Withdrawl")]
#removing everyone who withdrew at W1 (exclusionary withdrawals)
overview <- overview %>% 
  rename(tagid = TAG_ID) %>%
  replace_na(list(Withdrawn_W1 = 0)) %>%
  replace_na(list(Exclusionary_Withdrawl = 0)) %>% 
  arrange(Exclusionary_Withdrawl) %>% 
  filter(Exclusionary_Withdrawl==0) %>%
  filter(Withdrawn_W1==0)

###### LOAD PDS, PBIP AND AGE  ######
file_list_pds = Sys.glob(paste0(quest_dir, 'Wave*/PDS_Wave*.csv'))
file_list_pbip = Sys.glob(paste0(quest_dir,'Wave*/PBIP_Wave*.csv'))

PDS = data.frame()
for (file in file_list_pds) {
  temp <- read.table(file, header=TRUE, sep=",") %>%
    select(tagid, adrenf2, gonadf2, pdss) %>%
    mutate(wave = regmatches(file, regexpr("[[:digit:]]+", file)))
  PDS = rbind(PDS, temp)
  rm(temp)
}

PBIP = data.frame()
for (file in file_list_pbip) {
  temp <- read.table(file, header=TRUE, sep=",") %>%
    select(tagid, PBIP_1A, PBIP_2A, stage) %>%
    mutate(wave = regmatches(file, regexpr("[[:digit:]]+", file)))
  PBIP = rbind(PBIP, temp)
  rm(temp)
}

Age <- read.table(paste0(age_dir, "TAG_age.csv"), header=TRUE, sep=",") %>%
  filter(session==2) %>% 
  select(tagid,wave,age_excel) 

Allwaves_Puberty_Q <- merge(PDS, PBIP,  by=c("tagid","wave"), all=T) 
#If there are duplicates for TAG077 W2 and TAG124 W2, this is because these pp completed the W2 version at Wave 2 and 3
#Allwaves_Puberty_Q <- Allwaves_Puberty_Q[!(Allwaves_Puberty_Q$tagid=="TAG077" & Allwaves_Puberty_Q$pdss==3.5 & Allwaves_Puberty_Q$stage==2),] 
#Allwaves_Puberty_Q <- Allwaves_Puberty_Q[!(Allwaves_Puberty_Q$tagid=="TAG077" & Allwaves_Puberty_Q$pdss==2 & Allwaves_Puberty_Q$stage==3),] 
#Allwaves_Puberty_Q$wave[Allwaves_Puberty_Q$tagid=="TAG077" & Allwaves_Puberty_Q$pdss==3.5 & Allwaves_Puberty_Q$stage==3] = 3
#Allwaves_Puberty_Q <- Allwaves_Puberty_Q[!(Allwaves_Puberty_Q$tagid=="TAG124" & Allwaves_Puberty_Q$pdss==5 & Allwaves_Puberty_Q$stage==2.5),] 
#Allwaves_Puberty_Q <- Allwaves_Puberty_Q[!(Allwaves_Puberty_Q$tagid=="TAG124" & Allwaves_Puberty_Q$pdss==3 & Allwaves_Puberty_Q$stage==4),] 
#Allwaves_Puberty_Q$wave[Allwaves_Puberty_Q$tagid=="TAG124" & Allwaves_Puberty_Q$pdss==5 & Allwaves_Puberty_Q$stage==4] = 3
Allwaves_Puberty_Q <- merge(Allwaves_Puberty_Q, Age, by=c("tagid","wave"), all.x=T) %>%
  filter(tagid %in% overview$tagid)


###CREATE COMPOSITE ADRENAL AND GONADAL AND PUBERTAL SCORES FROM PDS & PBIP ######
#calculates mean of adrenal and gonadal composites that are mean of PBIP and PDS items, 
PubertyComposite <- Allwaves_Puberty_Q %>%
  mutate(ADRENdiff = adrenf2-PBIP_2A,
         GONADdiff = gonadf2-PBIP_1A) %>%
  rowwise %>% 
  mutate(ADRENcomp = mean(c(adrenf2,PBIP_2A),na.rm=T), #if only one measure (i.e. PDS or PBIP) is available, will use that instead of NA.
         GONADcomp = mean(c(gonadf2,PBIP_1A),na.rm=T),
         PUBcomp = mean(c(pdss, stage),na.rm=T)) %>%
  rename(age=age_excel)

PubertyMissing <- PubertyComposite %>% filter(is.na(PUBcomp)) 


###SAVE COMPOSITE SCORES ######
write.csv(PubertyComposite,paste0(puberty_dir,'Allwaves_PubertyComposite.csv'),row.names=F)
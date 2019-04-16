###########
# title: "cleaning SVC output files"
# author: "Marjolein"
# date: "12 April 2019"
###########
## This script imports SVC output files, and outputs a long format file with SVC behavior across all waves and runs
## It also codes response tendencies and reaction times per adjective factor for self and change.
##############

#Install packages & set directories
 
library(dplyr)
library(tidyr)
library(stringr)
library(psych)
library(data.table)

inputDir <- 'Y:/dsnlab/TAG/behavior/task/info/'
rawDataDir <- 'Y:/dsnlab/TAG/behavior/task/output/'
outDataDir <- 'Y:/dsnlab/TAG/behavior/task/processed/SVC/'


#Import and clean data
 
dataHeader <- c('trial', 'condition.and.factor', 'onset', 'RT.seconds',
                'response', 'reverse.coding', 'syllables', 'word')
# %   task.output.raw:
# %       1. Trial Number
# %       2. condition+adjective factor
# %           [1-3] = Self; [4-6] = Change;
# %           [1,4] = Prosocial; [2, 5] = Withdrawn; [3,6] Antisocial
# %       3. Time since trigger
# %       4. Reaction time
# %       5. Response 1=yes, 2=no, 0=no response
# %       6. Reverse coding 1=not reverse coded, 0=reverse coded (i.e. if it loads negatively on the adjective factor)
# %       7. Number of syllables in the word
# %       8. The presented word/adjective

Filestrings = list.files(path=rawDataDir,pattern="tag.*svc.*output.txt",full.names=T,recursive=T)

longDF <- setNames(data.frame(matrix(ncol = 8, nrow = 0)),paste0(dataHeader)) 

for (string in Filestrings) {
  filename <- sub(".*tag", "", string)
  SID <- sub(".*tag","",filename) %>% substring(.,1,3) %>% as.numeric(.)
  wave <- sub(".*wave_","",filename) %>% substring(.,1,1) %>% as.numeric(.)
  run <- sub(".*run","",filename) %>% substring(.,1,1) %>% as.numeric(.) 
    DF.raw <- read.csv(file=string,
                     header=F, col.names=dataHeader,
                     stringsAsFactors=F)
    DF.raw <- DF.raw %>%
    filter(!trial=="NaN") %>%
    mutate(sid = SID,
           wave = wave,
           run = run) %>%
    select(sid, wave, run, everything()) %>%
    mutate(onset=as.numeric(onset),
           response=as.numeric(response),
           reverse.coding=as.numeric(reverse.coding),
           syllables = as.numeric(syllables),
           change=condition.and.factor %in% 4:6) 
    longDF <- rbind(longDF,DF.raw)
}

longDF <- longDF %>% 
  filter(sid<350) %>%
  mutate(response.0NA = ifelse(response==0,NA,response)) %>%
  mutate(response.recoded = ifelse(reverse.coding==0,
                             ifelse(change==FALSE,
                              ifelse(response.0NA==1,2,1),response.0NA),response.0NA))
write.csv(longDF,paste0(outDataDir,'svc_trials_long.csv'),row.names=F)

wave1DF <- longDF %>% 
  filter(wave==1)
write.csv(wave1DF,paste0(outDataDir,'svc_trials_wave1.csv'),row.names=F)


#Get mean and distribution of responses and RTs for self and change
responsetable <- table(wave1DF$condition.and.factor, wave1DF$response.recoded)
prop.table(responsetable, margin=1)
#endorsement of prosocial adjectives is 93%, of withdrawn items 32% and of antisocial items 21%
#on average about 80% of the items are considered malleable, no difference between adjective factors
describeBy(wave1DF$RT.seconds,wave1DF$change)
describeBy(wave1DF$RT.seconds,wave1DF$condition.and.factor)
#average reaction times between 1.5 and 2 seconds, does not vary much by condition or adjective factor


#Save subject-specific files for behavioral analyses 

ids <- as.vector(unique(wave1DF$sid))
files <- lapply(X=ids, df=wave1DF, FUN=function(id, df) {

  df <- df %>% filter(sid==id) %>% select(-word) %>%
    mutate(self = ifelse(change==TRUE,0,1))
    
  fid = str_pad(id, 3, "left", 0)
  
  write.table(df,file=paste0(outDataDir,'subjects/tag',fid,'.csv'),sep=",",row.names=F,na="") 
})

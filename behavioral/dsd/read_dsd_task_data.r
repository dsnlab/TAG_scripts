#'
# DSD Data
#'
#install.packages(c('dplyr','tidyr','ggplot2'), Ncpus = 6)
library(dplyr)
library(tidyr)
library(ggplot2)
#library(cowplot)
jftheme <- theme_minimal()+
	theme(axis.line=element_line(size=0),
	      strip.background=element_rect(fill='white'))
theme_set(jftheme)

dataHeader <- c('trial', 'condition', 'left.target', 'right.target', 'left.coin', 'right.coin',
                'disc.onset', 'target.choice','target.rt.seconds',
                'statement.onset', 'statement.choice', 'statement.rt.seconds',
                'payout', 'statement')
# %   task.output.raw:
# %       1. Trial Number
# %       2. condition
# %           [1-3] = Neutral; [4-6] = Affective;
# %           [1,4] = loss to share; [2, 5] = loss to private; [3,6] equal
# %       3. leftTarget (self == 1, friend == 2) 
# %       4. rightTarget
# %       5. leftCoin
# %       6. rightCoin
# %       7. Time since trigger for disclosure (choiceOnset - loopStartTime);
# %       8. choiceResponse - Share or not? (leftkeys = 1, rightkeys = 2)
# %       9. choiceRT - reaction time
# %       10. Time since trigger for statement decisions (discoOnset - loopStartTime);
# %       11. discoResponse - endorse or not?  (leftkeys = 1, rightkeys = 2)
# %       12. discoRT - reaction time
# %       13. task.payout
# %       14. task.input.statement

inputDir <- '/Volumes/psych-cog/dsnlab/TAG/behavior/task/info/'
rawDataDir <- '/Volumes/psych-cog/dsnlab/TAG/behavior/task/output/'
outDataDir <- '/Volumes/psych-cog/dsnlab/TAG/behavior/task/processed/'

discoSide <- read.csv(paste0(inputDir,'discoside.csv'),header=F,sep=",")
discoSide <- discoSide %>% rename(sid=V1, side=V2)

dsdFiles = list.files(path=rawDataDir,pattern="tag.*dsd.*output.txt",full.names=T,recursive=T)
dsdFiles <- as.data.frame(dsdFiles) %>% 
  mutate(file = sub(".*tag", "", dsdFiles)) %>% 
  mutate(sid = as.numeric(substring(file,1,3))) %>%
  filter(sid < 350)
  
longDF <- lapply(X=dsdFiles$dsdFiles, FUN=function(file) {
  SID <- sub(".*tag","",file) %>% substring(.,1,3) %>% as.numeric(.)
  wave <- sub(".*wave_","",file) %>% substring(.,1,1) %>% as.numeric(.)
  run <- sub(".*run","",file) %>% substring(.,1,1) %>% as.numeric(.)
  side <- subset(discoSide,sid==SID)$side
  DF.raw <- read.csv(file=paste0(file),
                     header=F, col.names=dataHeader,
                     stringsAsFactors=F)
  DF.raw <- DF.raw %>%
    filter(!grepl('trial_number', trial)) %>%
    mutate(sid = SID,
           wave = wave,
           run = run) %>%
    select(sid, wave, run, everything()) %>%
    mutate(target.choice=as.numeric(target.choice),
           right.coin=as.numeric(right.coin),
           left.coin=as.numeric(left.coin),
           affective=condition %in% 4:6) %>%
    rowwise() %>%
    mutate(disclosed=ifelse(side==1,(target.choice==2),
                            ifelse(side==2, (target.choice==1), NA)),
           share.value=ifelse(side==1, (right.coin-left.coin),
                              ifelse(side==2, (left.coin-right.coin), NA))) %>%
    mutate(disclosed = as.numeric(disclosed),
           share.value = as.numeric(share.value))
  
  DF.raw <- as.data.frame(DF.raw)
})

longDF <- rbindlist(longDF)

write.csv(longDF,paste0(outDataDir,'dsd_trials_long.csv'),row.names=F)

allSubs <- ggplot(longDF, aes(x=share.value, y=disclosed, group=affective))+
	geom_point(aes(color=affective),position=position_jitter(h=.1, w=.2))+
	geom_line(aes(color=affective), stat='smooth', method='glm', 
		  method.args=list(family='binomial'))+
	geom_hline(yintercept=.5, color='gray')+
	facet_wrap(~sid)+
	scale_y_continuous(breaks = c(0,.5, 1), labels = c('0', 'eq.', '1'))+
	theme(strip.background=element_rect(fill='#eeeeee'),
	      panel.spacing=unit(0, 'pt'),
	      panel.border=element_rect(fill=NA, color='#eeeeee', size=1, linetype=1))
ggsave(allSubs, file=paste0(outDataDir, 'PSE-all_pid.png'),
       width=10, height=15, dpi=72)

allSubs2 <- longDF %>% 
  mutate(endorsed=statement.choice==1) %>%
  unite(affect_endorsed, affective, endorsed) %>%
  ggplot(aes(x=share.value, y=disclosed, group=affect_endorsed))+
  geom_point(aes(color=affect_endorsed),position=position_jitter(h=.1, w=.2))+
  geom_line(aes(color=affect_endorsed), stat='smooth', method='glm', 
            method.args=list(family='binomial'))+
  geom_hline(yintercept=.5, color='gray')+
  facet_wrap(~sid)+
  scale_y_continuous(breaks = c(0,.5, 1), labels = c('0', 'eq.', '1'))+
  theme(strip.background=element_rect(fill='#eeeeee'),
        panel.spacing=unit(0, 'pt'),
        panel.border=element_rect(fill=NA, color='#eeeeee', size=1, linetype=1),
        text=element_text(size=12, face='bold'))
ggsave(allSubs2, file=paste0(outDataDir, 'PSE-all_pid_endoresed.png'),
       width=10, height=15, dpi=72)

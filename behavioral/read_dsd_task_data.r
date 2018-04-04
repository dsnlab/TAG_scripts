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

rawDataDir <- '/Volumes/psych-cog/dsnlab/TAG/behavior/task/output'
outDataDir <- '/Volumes/psych-cog/dsnlab/TAG/behavior/task/processed/'

dsdFiles = list.files(path=rawDataDir,pattern="tag.*dsd.*output.txt",full.names=T)

longDF <- lapply(X=dsdFiles, FUN=function(file) {
  sid <- sub(".*task/output/","",file) %>% substring(.,4,6) %>% as.numeric(.)
  run <- sub(".*run","",file) %>% substring(.,1,1) %>% as.numeric(.)
  DF.raw <- read.csv(file=paste0(file),
                     header=F, col.names=dataHeader,
                     stringsAsFactors=F)
  DF.raw <- DF.raw %>%
    mutate(sid = sid,
           run = run) %>%
    select(sid, run, everything()) %>%
    mutate(disclosed=as.numeric(target.choice==2),
           share.value=as.numeric(right.coin)-as.numeric(left.coin),
           affective=condition %in% 4:6)
  
})

longDF <- rbindlist(longDF)

write.csv(longDF,paste0(outDataDir,'dsd_trials_long_test.csv'),row.names=F)

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

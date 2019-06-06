# prep qualtrics data for export
# T Cheng | started 06062019

get_cleaned_survey_data <- function(datadir, up_to_this_date){
  ## Load required packages ##
  packages <- c("lme4", "nlme", "ggplot2", "dplyr", "tidyr", "knitr",
                "parallel", "data.table", "lubridate","xml2","devtools")
  if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
    install.packages(setdiff(packages, rownames(installed.packages())))  
  }
  lapply(packages, library, character.only = TRUE)
  #install_github('jflournoy/qualtrics')
  library(scorequaltrics)
  rm(packages)
  
  # Extract qualtrics data from website
  credsFile<-file.path(datadir,"Questionnaires/RDOC/Confidential/credentials.yaml.DEFAULT", fsep="")
  creds<-creds_from_file(credsFile)

  exclude_survey=c("NV","GUT","TEST","Appointment","Newsletter","SOS","Sharing Task")
  survey_info<-scorequaltrics::get_surveys(creds) %>% 
    filter(!grepl(paste0(exclude_survey,collapse="|"),SurveyName)) %>% 
    #filter(!SurveyName %in% paste0(exclude_survey)) %>%
    dplyr::select(SurveyID, SurveyName)
  
  get_survey_data<-function(surveysDF,pid_col){
    #Takes the data.frame that is returned by `get_surveys`
    #Returns a long format data.frame of survey data with names
    # "SID variable name"         "item"        "value"       "survey_name"
    survey_data<-surveysDF %>% 
      group_by(SurveyID) %>%
      do(
        survey_name=.$SurveyName[[1]],
        survey_data=scorequaltrics::get_survey_responses(
          creds,
          surveyid=.$SurveyID[[1]])
      )
    long_survey_data<-survey_data %>% 
      filter(dim(survey_data)[1]>0) %>%
      do({
        colNames <- names(.$survey_data)
        gather_cols_list <- lapply(pid_col, function(x) colNames[!grepl(x, colNames)])
        gather_cols<-Reduce(intersect, gather_cols_list)
        aDF<-gather_(.$survey_data,
                     'item',
                     'value',
                     gather_cols)
        aDF$survey_name<-.$survey_name
        aDF
      })
    long_survey_data
  }
  
  raw_survey_data <- get_survey_data(survey_info,pid_col=c("SID", "SID_embed"))
  
  long_survey_data<- raw_survey_data %>% mutate(value = ifelse(value == -99, NA, value)) %>% 
    mutate(SID = ifelse(!is.na(SID_embed), SID_embed, 
                        ifelse(SID=="", SID_embed, SID))) %>%
    select(-SID_embed)
  
  embedded_qs<-survey_info %>% 
    filter(SurveyName %in% c("TAG - Home Qs - V3 - with SID embedded", 
                             "TAG - W1 Home Qs - Current V4")) 
  sortbyqid_data <- get_survey_data(embedded_qs,pid_col="qid") %>% mutate(value = ifelse(value == -99, NA, value))
  
  rm(creds,credsFile,get_survey_data)
  
  # Clean qualtrics (from scratch)
  
  library(data.table)
  cleaned_survey_data <- as.data.table(long_survey_data)
  cleaned_survey_data[, tagid := ifelse(nchar(SID)==3, sprintf("TAG%03s",SID), SID)]
  cleaned_survey_data[, SID := NULL]
  cleaned_survey_data <- cleaned_survey_data[!(tagid %in% c('TAG000', 'TAG999'))]
  cleaned_survey_data[tagid == '013 ', tagid := 'TAG013']
  cleaned_survey_data[tagid == '70', tagid := 'TAG070']
  cleaned_survey_data[tagid == 'TAG255', tagid := 'TAG225'] #SJC updated
  cleaned_survey_data[tagid == 'home', tagid := "TAG244"] #NV updated
  cleaned_survey_data[tagid == '541695411', tagid := "TAG040"] #NV updated
  cleaned_survey_data[tagid == "TAGHVU", tagid := "TAG070"] #NV updated
  cleaned_survey_data <- as.data.frame(cleaned_survey_data)
  #The above is much much quicker.
  #  user  system elapsed 
  # 0.228   0.012   0.241 
  
  IDs<-unique(cleaned_survey_data$tagid)
  
  # Need to fix the IDs of participants
  # who showed an error with their qualtrics
  # home questionnaires
  misIDkey<-read.csv(paste0(datadir,"Questionnaires/RDOC/Confidential/qidkey.csv"))
  TAGHomeQ<-sortbyqid_data
  for (i in 1:length(misIDkey$qid)){
    TAGHomeQ <- TAGHomeQ %>%
      mutate(value=ifelse(qid==as.character(misIDkey$qid[i]) && item=="SID",
                          as.character(misIDkey$SID[i]),value))
  }
  gather_cols<-unique(TAGHomeQ$item)
  TAGEmbeddedHomeQ_Gathered <- TAGHomeQ %>% 
    spread(item,value) %>%
    mutate(tagid=ifelse(nchar(SID)==3, sprintf("TAG%03s",SID), SID))
  test1 <- select(TAGEmbeddedHomeQ_Gathered, tagid, survey_name, qid, everything())
  test2 <- gather(test1,"item","value",3:dim(test1)[2]) %>%
    filter(!tagid=='')
  
  cleaned_survey_data2 <- bind_rows(cleaned_survey_data, test2)
  cleaned_survey_data3<-cleaned_survey_data2 %>% distinct(tagid,item,value,survey_name,.keep_all = TRUE)
  
  #Remove missing data and the duplicated data from the embedded ID home questionnaires
  cleaned_survey_data<-cleaned_survey_data3 %>% 
    filter(!tagid=="") %>% 
    filter(!tagid=="SV_eqvWqPtsOO4uqPP") %>% 
    filter(grepl('TAG', tagid))
  
  # Change the one participant with a ghost SID
  cleaned_survey_data <- cleaned_survey_data %>%
    mutate(tagid=ifelse(tagid=="078\177","TAG078",tagid)) 
  
  #Check odd IDs:
  #cleaned_survey_data %>% filter(item == 'qid') %>% distinct(tagid, survey_name, value) %>% filter(!grepl('TAG', tagid)) %>% write.csv('~/weirdIDs.csv')
  
  rm(cleaned_survey_data2,cleaned_survey_data3,embedded_qs,misIDkey,missingID,sortbyqid_data,TAGEmbeddedHomeQ_Gathered,TAGHomeQ,test1,test2,i,gather_cols,IDs)
  rm(long_survey_data)
  
  surveyed<-unique(cleaned_survey_data$tagid)
  surveyed
  
  print(paste0("A total of ",length(surveyed)," participants have completed surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("Home",survey_name)))$tagid))," participants have completed home surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("Sess 1",survey_name) | grepl("W1S1",survey_name)))$tagid))," participants have completed Wave 1 Session 1 surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("Sess 2",survey_name) | grepl("W1S2",survey_name)))$tagid))," participants have completed Wave 1 Session 2 surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("W2S1",survey_name)))$tagid))," participants have completed Wave 2 Session 1 surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("W2S2",survey_name)))$tagid))," participants have completed Wave 2 Session 2 surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("W3S1",survey_name)))$tagid))," participants have completed Wave 3 Session 1 surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("W3S2",survey_name)))$tagid))," participants have completed Wave 3 Session 2 surveys!"))
  
  
  # Load and clean redcap info
  redcapData <- read.csv(paste0(datadir,"Questionnaires/RDOC/Confidential/redcap_dates_", up_to_this_date, ".csv"), header = TRUE, stringsAsFactors = FALSE)# %>%
  # filter(!grepl("wave_2",redcap_event_name))
  redcapData_dob<-redcapData %>%
    select(dob,subject_spit_id) %>%
    filter(!dob=="")
  redcapData_sessiondates<-redcapData %>%
    select(sa_date,sb_date,redcap_event_name,subject_spit_id) %>%
    filter(!sa_date=="") %>%
    extract(redcap_event_name, c('wave'), 'wave_([\\d]).*')
  redcap_cleaned<-merge(redcapData_sessiondates,redcapData_dob) %>%
    mutate(tagid=substring(subject_spit_id,first=4,last=length(subject_spit_id)))%>%
    filter(!subject_spit_id=="TAG_001P") %>%
    mutate(tagid=ifelse(nchar(tagid)==4,substring(subject_spit_id,first=5,last=length(subject_spit_id)),tagid)) %>%
    mutate(tagid=sprintf("TAG%03d",as.integer(tagid))) %>%
    select(-subject_spit_id)
  redcap_cleaned$sa_date <- as.Date(redcap_cleaned$sa_date, format = "%m/%d/%Y")
  redcap_cleaned$sb_date <- as.Date(redcap_cleaned$sb_date, format = "%m/%d/%Y")
  redcap_cleaned$dob <- as.Date(redcap_cleaned$dob, format = "%m/%d/%Y")
  rm(redcapData_dob,redcapData,redcapData_sessiondates)
  
  # Configure anthro information
  redcap_anthro <- read.csv(paste0(datadir,"Questionnaires/RDOC/Confidential/redcap_anthro_", up_to_this_date, ".csv"), header = TRUE, stringsAsFactors = FALSE) %>%
    filter(!anthro_doc=="") %>%
    extract(redcap_event_name, c('wave'), 'wave_([\\d]).*') %>%
    mutate(tagid=substring(subject_spit_id,first=4,last=length(subject_spit_id)))%>%
    filter(!subject_spit_id=="TAG_001P") %>%
    mutate(tagid=ifelse(nchar(tagid)==4,substring(subject_spit_id,first=5,last=length(subject_spit_id)),tagid)) %>%
    mutate(tagid=sprintf("TAG%03d",as.integer(tagid))) %>%
    select(-subject_spit_id)
  anthro<-left_join(redcap_anthro,redcap_cleaned,by=c("tagid", "wave")) %>%
    mutate_at(vars(matches('(height|weight|waist).*')), funs(as.numeric)) %>%
    mutate(height_1=ifelse(height_system==3,(height_1*2.54),height_1),
           height_2=ifelse(height_system==3,(height_2*2.54),height_2),
           height_3=ifelse(height_system==3,(height_3*2.54),height_3),
           waist_1=ifelse(waist_system==3,(waist_1*2.54),waist_1),
           waist_2=ifelse(waist_system==3,(waist_2*2.54),waist_2),
           waist_3=ifelse(waist_system==3,(waist_3*2.54),waist_3),
           weight_1=ifelse(weight_system==2,(weight_1*0.453592),weight_1),
           weight_2=ifelse(weight_system==2,(weight_2*0.453592),weight_2),
           weight_3=ifelse(weight_system==2,(weight_3*0.453592),weight_3))
  anthro<- left_join(anthro, 
                     anthro %>%
                       group_by(tagid, wave) %>%
                       summarise(height=ifelse(!is.na(height_1 & height_2 & height_3),
                                               median(c(height_1,height_2,height_3)),
                                               ifelse(!is.na(height_1 & height_2) & is.na(height_3),
                                                      mean(c(height_1,height_2)),
                                                      ifelse(!is.na(height_1) & is.na(height_2 & height_3), height_1,
                                                             height_1)))))
  anthro<- left_join(anthro, anthro %>%
                       group_by(tagid, wave) %>%
                       summarise(weight=round(ifelse(!is.na(weight_1 & weight_2 & weight_3), median(c(weight_1, weight_2, weight_3)),
                                                     ifelse(!is.na(weight_1 & weight_2) & is.na(weight_3), mean(c(weight_1, weight_2)),
                                                            ifelse(!is.na(weight_1) & is.na(weight_2 & weight_3), weight_1, weight_1))),3)))
  anthro<- left_join(anthro, anthro %>%
                       group_by(tagid, wave) %>%
                       summarise(waist=ifelse(!is.na(waist_1 & waist_2 & waist_3), median(c(waist_1, waist_2, waist_3)),
                                              ifelse(!is.na(waist_1 & waist_2) & is.na(waist_3), mean(c(waist_1, waist_2)),
                                                     ifelse(!is.na(waist_1) & is.na(waist_2 & waist_3), waist_1, waist_1)))))
  anthro$anthro_doc <- as.Date(anthro$anthro_doc, format = "%m/%d/%Y")
  anthro<-anthro %>% 
    filter(!is.na(anthro_doc)) %>%
    mutate(age=round((interval(start = dob, end = anthro_doc) / duration(num = 1, units = "years")),2)) %>%
    select(-sa_date,-sb_date,-contains("waist_"),-contains("height_"),-contains("weight_"),-dob)
  
  heights_graph<-ggplot(anthro, aes(x=height)) +
    geom_histogram(alpha=.3)+
    ggtitle(paste0("Height (cm) for ",length(anthro$height[!is.na(anthro$height)])," participants"))+
    facet_grid(~wave)
  
  weights_graph<-ggplot(anthro, aes(x=weight)) +
    geom_histogram(alpha=.3)+
    ggtitle(paste0("Weight (lb) for ",length(anthro$weight[!is.na(anthro$weight)])," participants"))+
    facet_grid(~wave)
  
  waist_graph<-ggplot(anthro, aes(x=waist)) +
    geom_histogram(alpha=.3)+
    ggtitle(paste0("Waist measurement (cm) for ",length(anthro$waist[!is.na(anthro$waist)])," participants"))+
    facet_grid(~wave)
  
  anthro_change_graph <- anthro %>%
    select(tagid, height, weight, waist, age) %>%
    gather(key='key', value='value', -tagid, -age) %>%
    ggplot(aes(x=age, y=value, group=tagid)) +
    geom_point(alpha=.15) +
    geom_line(alpha=.5) +
    geom_line(aes(group=NULL), stat = 'smooth', method = 'loess', span=1, color = 'blue') +
    facet_wrap(~key, scales='free') +
    theme_bw()
  
  rm(waist_graph,heights_graph,weights_graph,redcap_anthro,anthro_change_graph)
  
  # Get Survey Date info 
  
  survey_startdate<-filter(cleaned_survey_data, grepl("StartDate",item)) %>%
    filter(!survey_name=="Sharing Task Experience Survey") %>%
    mutate(startdate=as.Date(value),
           survey_type=ifelse(grepl("(Sess 1|W[123]S1)",survey_name),"Sess 1",
                              ifelse(grepl("(Sess 2|W[123]S2)",survey_name),"Sess 2",
                                     ifelse(grepl("Parent",survey_name),"Parent",
                                            ifelse(grepl("Home",survey_name),"Home",
                                                   NA)))))  %>%
    select(-value,-item) %>%
    # filter(!survey_type=="Parent") %>%
    dplyr::arrange(startdate)
  
  survey_originaldate<-filter(cleaned_survey_data, grepl("original.date.timestamp",item)) %>%
    filter(!survey_name=="Sharing Task Experience Survey") %>%
    filter(!value=="") %>%
    mutate(originaldate=as.Date(value),
           survey_type=ifelse(grepl("Sess 1|W[123]S1",survey_name),"Sess 1",
                              ifelse(grepl("Sess 2|W[123]S2",survey_name),"Sess 2",
                                     ifelse(grepl("Parent",survey_name),"Parent",
                                            ifelse(grepl("Home",survey_name),"Home",
                                                   NA))))) %>%
    select(-value,-item) %>%
    # filter(!survey_type=="Parent") %>%
    dplyr::arrange(originaldate)
  
  survey_date<-left_join(survey_startdate,survey_originaldate) %>%
    mutate(value=as.Date(ifelse(is.na(originaldate),startdate,originaldate),origin="1970-01-01 UTC")) %>%
    select(-originaldate,-startdate)
  
  survey_date_sorted <- survey_date %>%
    mutate(tagid_sorted = factor(tagid, levels = unique(tagid[order(value)])))
  
  graph_dates<-ggplot(survey_date_sorted, aes(x=value, y=tagid_sorted, group=tagid)) +
    geom_line(colour="black", alpha=.5) +
    geom_point(aes(colour = survey_type)) +
    scale_x_date(date_breaks = "1 month", date_labels =  "%b %Y") +
    theme_minimal() + 
    theme(axis.text.y=element_blank(),
          axis.text.x = element_text(hjust = 0, angle = 360-45))
  graph_dates
  
  timebetween=function(subid){
    tag_id <- as.character(subid)
    start <- strptime((survey_date %>%
                         filter(tagid==tag_id) %>%
                         filter(survey_type=="Sess 1") %>%
                         select(value) %>%
                         arrange(value))[[1]][[1]], format="%Y - %m - %d") 
    if (nrow(survey_date %>%
             filter(tagid==tag_id) %>%
             filter(survey_type=="Sess 2"))>0) {
      end <- strptime((survey_date %>%
                         filter(tagid==tag_id) %>%
                         filter(survey_type=="Sess 2") %>%
                         select(value) %>%
                         arrange(desc(value)))[[1]][[1]], format="%Y - %m - %d")
      totaldays<-(end-start)
    } else {
      end <- "NA"
      totaldays<-"NA"
    }
    as.data.frame(cbind(tag_id, totaldays))
  }
  
  # Prep for Export
  redcap_cleaned_dates <- redcap_cleaned
  redcap_cleaned$sa_date <- as.character(redcap_cleaned$sa_date)
  redcap_cleaned$sb_date <- as.character(redcap_cleaned$sb_date)
  redcap_cleaned$dob <- as.character(redcap_cleaned$dob)
  
  save(cleaned_survey_data, file = paste0(datadir, "Questionnaires/cleaned_survey_data.RDS"))
  return(cleaned_survey_data)
}

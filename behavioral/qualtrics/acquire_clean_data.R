# prep qualtrics data for export
# T Cheng | started 06062019

get_cleaned_survey_data <- function(datadir, up_to_this_date){
  # this function acquires data from qualtrics and transforms it into long format
  
  ## Load required packages ##
  packages <- c("lme4", "nlme", "ggplot2", "dplyr", "tidyr", "knitr",
                "parallel", "data.table", "lubridate","xml2","devtools", "stringr")
  if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
    install.packages(setdiff(packages, rownames(installed.packages())))  
  }
  lapply(packages, library, character.only = TRUE)
  #install_github('jflournoy/qualtrics') # uncommenting this line results in a timeout error
  library(scorequaltrics)
  
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

  # clean tagid values
  
  library(data.table)
  cleaned_survey_data <- as.data.table(long_survey_data)
  
  # general tidying of tagids
  cleaned_survey_data[, tagid := ifelse(nchar(SID)==3, sprintf("TAG%03s",SID), SID)]
  cleaned_survey_data[, SID := NULL]
  cleaned_survey_data <- cleaned_survey_data[!(tagid %in% c('TAG000', 'TAG999'))]
  
  # read csv file of bad tagid entries (col 1) and correct replacements (col 2)
  tagid_replacements <- read.csv(paste0(scriptsdir,"behavioral/qualtrics/tagid_replacements.csv"), header = FALSE)
  colnames(tagid_replacements) <- c("bad_tagids", "good_tagids")
  tagid_replacements$bad_tagids <- as.character(tagid_replacements$bad_tagids)
  tagid_replacements$good_tagids <- as.character(tagid_replacements$good_tagids)
  #str_replace(tagid_replacements$bad_tagids, "\\\\", "\")
  #gsub(pattern = "\\", replacement = '"\"', x = tagid_replacements$bad_tagids, fixed = TRUE)
  
  cleaned_survey_data$tagid<- as.character(cleaned_survey_data$tagid)
  
  replace_tagid <-function(bad_tagid, good_tagid){
    cleaned_survey_data[tagid == bad_tagid, tagid := good_tagid]} 

  for (i in 1:nrow(tagid_replacements)){
    replace_tagid(tagid_replacements[i, 1], tagid_replacements[i, 2])
    }
  
  # automated way of doing this can't handle searching for single backslashes, doing one of the tagid replacements manually ... sorry
  cleaned_survey_data <- cleaned_survey_data %>%
    mutate(tagid=ifelse(tagid=="078\177","TAG078",tagid)) 

  
  IDs <- unique(cleaned_survey_data$tagid)
  
  # Need to fix the IDs of participants who showed an error with their qualtrics home questionnaires
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
  
  surveyed<-unique(cleaned_survey_data$tagid)
  
  print(paste0("A total of ",length(surveyed)," participants have completed surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("Home",survey_name)))$tagid))," participants have completed home surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("Sess 1",survey_name) | grepl("W1S1",survey_name)))$tagid))," participants have completed Wave 1 Session 1 surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("Sess 2",survey_name) | grepl("W1S2",survey_name)))$tagid))," participants have completed Wave 1 Session 2 surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("W2S1",survey_name)))$tagid))," participants have completed Wave 2 Session 1 surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("W2S2",survey_name)))$tagid))," participants have completed Wave 2 Session 2 surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("W3S1",survey_name)))$tagid))," participants have completed Wave 3 Session 1 surveys!"))
  print(paste0("A total of ",length(unique((cleaned_survey_data %>% filter(grepl("W3S2",survey_name)))$tagid))," participants have completed Wave 3 Session 2 surveys!"))
  

#   cleaned_survey_data[tagid == '013 ', tagid := 'TAG013']
#   cleaned_survey_data[tagid == '70', tagid := 'TAG070']
#   cleaned_survey_data[tagid == 'TAG255', tagid := 'TAG225'] #SJC updated
#   cleaned_survey_data[tagid == 'home', tagid := "TAG244"] #NV updated
#   cleaned_survey_data[tagid == '541695411', tagid := "TAG040"] #NV updated
#   cleaned_survey_data[tagid == "TAGHVU", tagid := "TAG070"] #NV updated
#   cleaned_survey_data <- as.data.frame(cleaned_survey_data)
#   #The above is much much quicker.
#   #  user  system elapsed 
#   # 0.228   0.012   0.241 
  
  saveRDS(cleaned_survey_data, file = paste0(datadir, "Questionnaires/cleaned_survey_data.rds"))
  return(cleaned_survey_data)
}


get_redcap_cleaned <- function(datadir, up_to_this_date){
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
                       summarise(height = ifelse(!is.na(height_1 & height_2 & height_3),
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
  
  saveRDS(redcap_cleaned, file = paste0(datadir, "Questionnaires/redcap_cleaned.rds"))
  saveRDS(survey_date, file = paste0(datadir, "Questionnaires/survey_date.rds"))
  
  redcap_cleaned_and_survey_date = list(redcap_cleaned, survey_date)
  return(redcap_cleaned_and_survey_date)
}


write_guids_to_csv <- function(datadir, up_to_this_date){
  redcap_NDA_info <- read.csv(paste0(datadir,"RDoCdb/Confidential/redcap_nda_consent_", up_to_this_date, ".csv"),
                              header = TRUE,
                              stringsAsFactors = FALSE)
  
  redcapNDA_sessiondates<-redcap_NDA_info %>%
    select(sa_date,sb_date,subject_spit_id) %>%
    filter(!sa_date=="" & !sb_date=="") %>%
    distinct()
  
  redcap_NDA_info$nda_form_date <- as.Date(redcap_NDA_info$nda_form_date, format = "%m/%d/%Y")
  redcap_NDA_info$dob <- as.Date(redcap_NDA_info$dob, format = "%m/%d/%Y")
  redcap_NDA_info$sa_date <- as.Date(redcap_NDA_info$sa_date, format = "%m/%d/%Y")
  redcap_NDA_info$sb_date <- as.Date(redcap_NDA_info$sb_date, format = "%m/%d/%Y")
  
  redcapNDA_data<-redcap_NDA_info %>%
    select(-sa_date,-sb_date) %>%
    filter(!participant_first_name=="") %>%
    distinct()
  
  redcapNDA_sessiondates$sa_date <- as.Date(redcapNDA_sessiondates$sa_date, format = "%m/%d/%Y")
  redcapNDA_sessiondates$sb_date <- as.Date(redcapNDA_sessiondates$sb_date, format = "%m/%d/%Y")
  
  redcap_NDA_info<-merge(redcapNDA_sessiondates,redcapNDA_data) %>%
    mutate(tagid=substring(subject_spit_id,first=4,last=length(subject_spit_id)))%>%
    filter(!subject_spit_id=="TAG_001P") %>%
    mutate(tagid=ifelse(nchar(tagid)==4,substring(subject_spit_id,first=5,last=length(subject_spit_id)),tagid),
           dob=as.Date(dob),
           sa_date=as.Date(sa_date),
           sb_date=as.Date(sb_date))
  
  rm(redcapNDA_data,redcapNDA_sessiondates)
  
  guid_colnames<-colnames(read.csv(paste0(datadir,"RDoCdb/templates/guid_sample_template.csv"),
                                   header = TRUE,
                                   stringsAsFactors = FALSE,
                                   nrow=1))
  
  consentedlist<-unique(redcap_NDA_info %>%
                          filter(nda_consent___1==1 & nda_consent___2==1) %>%
                          select(tagid))[[1]]
  
  prepareGUIDs=function(subID){
    sub_NDA_info<-redcap_NDA_info %>% filter(tagid==subID)
    assign(guid_colnames[2], sub_NDA_info$participant_first_name)
    assign(guid_colnames[3], ifelse(sub_NDA_info$participant_middle_name=="No Middle Name",
                                    "",
                                    sub_NDA_info$participant_middle_name))
    assign(guid_colnames[4], sub_NDA_info$participant_last_name)
    assign(guid_colnames[5], month(parse_date_time(sub_NDA_info$dob[1], order=c('ymd'))))
    assign(guid_colnames[6], day(parse_date_time(sub_NDA_info$dob[1], order=c('ymd'))))
    assign(guid_colnames[7], year(parse_date_time(sub_NDA_info$dob[1], order=c('ymd'))))
    assign(guid_colnames[8], sub_NDA_info$participant_city_of_birth)
    assign(guid_colnames[9],"F")
    assign(guid_colnames[10],ifelse(sub_NDA_info$participant_middle_name=="No Middle Name","NO","YES"))
    assign(guid_colnames[11],"YES")
    cbind(subID,get(guid_colnames[2]),get(guid_colnames[3]),get(guid_colnames[4]),get(guid_colnames[5]),get(guid_colnames[6]),
          get(guid_colnames[7]),get(guid_colnames[8]),get(guid_colnames[9]),get(guid_colnames[10]),get(guid_colnames[11]))
  }
  
  guid_batch<-lapply(consentedlist,prepareGUIDs)
  guid_batch.df<-as.data.frame(do.call(rbind,guid_batch)) %>% distinct()
  guid_batch_ids<-guid_batch.df %>%
    select(subID) %>%
    mutate(ID=row.names(guid_batch.df),
           tagid=sprintf("TAG%03s",subID)) %>%
    select(-subID)
  guid_batch.df<- guid_batch.df %>% select(-subID)
  guid_batch.df<-cbind(guid_colnames[1],guid_batch.df)
  colnames(guid_batch.df) <- guid_colnames
  guid_batch.df$ID <-row.names(guid_batch.df)
  print(paste0("GUID batch created for ",nrow(guid_batch.df)," participants!"))
  rm(guid_batch,guid_colnames,consentedlist,redcap_NDA_info)
  write.csv(guid_batch.df,file=paste0(datadir,"RDoCdb/Confidential/GUID_batch_",Sys.Date(),".csv"),row.names = FALSE)
  write.csv(guid_batch_ids,file=paste0(datadir,"RDoCdb/Confidential/GUID_batch_subIDkey_",Sys.Date(),".csv"),row.names = FALSE)
  
}

get_ndar_key <- function(datadir, cleaned_survey_data, redcap_cleaned, up_to_this_month){
  #2018-09-14
  # Info on correspondences should be in REDCap. If not, here's some more info:
  # It is easier, and better for the NIH system if we keep a record of the correspondence between anonymized TAG ID and
  # the NIH GUID or (especially) the pseudo-GUID. If the participant actually has all the correct 
  # info: First, last, middle name; date of birth; city of birth; and sex; and if they already have a 
  # GUID, we can just use that. If it becomes apparent that they have a mistaken GUID (because last time their
  # city of birth was listed as NA which was erroneously used) then we need to email NDAHelp@mail.nih.gov.
  # This happened to me, which is why it's probably important to check current participant info against older
  # participant info in the confidential folder. We still don't have complete info for each participant meaning
  # we could still get updates too.
  #
  # It is also possible that someone who didn't have complete info now has complete info. If they did not have complete
  # info before, we uploaded data using a pseudo-GUID. We can now get a full GUID and promote the pseudo-GUID (see 
  # https://data-archive.nimh.nih.gov/guid). 
  #
  # If we've used a pseudo-GUID in the past, it's important that we use the same one. This is why I started keeping
  # track in the csv below of who has what GUID or pseudo-GUID. 
  #
  # Anyone without an existing GUID or pseudo-GUID, and who you are not able to generate a new GUID for just gets
  # a pseudo-GUID which does not depend on their personal information (assign it arbitrarily).
  #
  # What NIH does check is whether the uploaded src_subject_id and NDAR subjectkey pair for the current upload matches
  # the pair from the previous upload. If it does not, it throws an error.
  #
  # There are three correspondences you need to be aware of:
  # 1) TAG ID in redcap to anonymized TAG ID in the TAG_RDoC_key.csv file
  # 2) TAG ID in redcap to "ID" column in GUID_batch_subIDkey_*.csv file
  # 3) "ID" column in the GUID_batch_*.csv files and the number in the output_guid_*.txt file, which also contains 
  #    the NDAR GUID or pseudo GUID.
  #
  # Before running this you must have generated GUIDs for each participant to be uploaded
  # Change file names below to match the dates of the actual files you're using
  
  # If you need to read in new GUIDs or pseudo-GUIDs, here's an example:
  #
  # #read the output from the GUID tool, with added pseudo GUIDs if necessary
  # rawGUIDoutput <- readr::read_lines(file.path(datadir,'RDoCdb/confidential/GUID_Batch_201806','guid_w_pguid_1531351660887.txt'))
  # rawGUIDoutput_df <- dplyr::data_frame(unparsed = rawGUIDoutput) %>%
  #   extract(unparsed, c('ID', 'guid'), '^(\\d+) - (.*)$') %>%
  #   mutate(ID = as.numeric(ID))
  #   
  # # Load the subject key which has the original TAGID, an anonymized ID, and the GUID
  # ndar_key_<-left_join(read.csv(file=paste0(datadir,"RDoCdb/confidential/GUID_Batch_201806/GUID_batch_subIDkey_2018-07-11.csv"),stringsAsFactors = FALSE),
  #                     read.csv(file=paste0(datadir,"RDoCdb/confidential/TAG_RDoC_key.csv"),stringsAsFactors = FALSE),by="tagid")
  # ndar_key <- left_join(ndar_key_, rawGUIDoutput_df, by = 'ID') 
  
  # ndar_key should contain the tagid, anontagid, and the guid columns - find this info on redcap
  ndar_key <- read.csv(paste0(datadir,'RDoCdb/confidential/ndar_key.csv'))
  # careful below, some code may also expect "ID" column which is just the row number. 
  # I dont *think* this column matters, so you can add this by running:
  ndar_key$ID <- 1:nrow(ndar_key)
  
  # NDAR requires a constrained answer for a participants "race"
  ethnicity_long <- cleaned_survey_data %>%
    filter(grepl("Ethnicity",item)) %>%
    filter(!value=="") %>%
    arrange(tagid) %>%
    select(-survey_name) %>%
    arrange(tagid)
  
  figure_out_ethnicity=function(subid){
    subethnicity<-ethnicity_long %>%
      filter(tagid==as.character(subid)) %>%
      distinct()
    numethnicity<-nrow(subethnicity %>%
                         filter(!item=="Ethnicity_7_TEXT"))
    if (numethnicity<2 & (nrow(subethnicity)==1)){
      race=ifelse(subethnicity$item=="Ethnicity_1","Black or African American",
                  ifelse(subethnicity$item=="Ethnicity_2","Unknown or not reported",
                         ifelse(subethnicity$item=="Ethnicity_3","American Indian/Alaska Native",
                                ifelse(subethnicity$item=="Ethnicity_4","White",
                                       ifelse(subethnicity$item=="Ethnicity_5","Asian",
                                              ifelse(subethnicity$item=="Ethnicity_10","Hawaiian or Pacific Islander",
                                                     ifelse(subethnicity$item=="Ethnicity_7",value,
                                                            ifelse(subethnicity$item=="Ethnicity_6","More than one race",
                                                                   ifelse(subethnicity$item=="Ethnicity_8","Unknown or not reported",
                                                                          ifelse(subethnicity$item=="Ethnicity_9","Unknown or not reported",""))))))))))
      cbind(subid,race)
    } else if (numethnicity<2 & (nrow(subethnicity)==2)){
      race=as.character(subethnicity %>%
                          filter(item=="Ethnicity_7_TEXT") %>%
                          select(value))
      cbind(subid,race)
    } else if (numethnicity>1) {
      race="More than one race"
      cbind(subid,race)
    }
  }
  ndar_ethnicity<-lapply(as.list(unique(ethnicity_long$tagid)),figure_out_ethnicity)
  ndar_ethnicity.df <- data.frame(matrix(unlist(ndar_ethnicity), nrow=length(ndar_ethnicity), byrow=T),stringsAsFactors=FALSE)
  
  ndar_race<- ndar_ethnicity.df %>%
    mutate(tagid=.[[1]],
           race=.[[2]]) %>%
    select(tagid, race) %>%
    mutate(race=case_when(
      race=="Asian white" ~ "More than one race",
      race=="Caucasian " ~ "White",
      race=="1/4 Mexican / white" ~ "More than one race",
      race=="Jewish" ~ "Unknown or not reported",
      TRUE ~ race))
  
  #
  
  participants_ndar_data <- redcap_cleaned %>% 
    filter(!is.na(dob),!is.na(sb_date)) %>%
    select(tagid, sa_date, dob) %>%
    arrange(tagid) %>%
    mutate(src_subject_id=tagid,
           interview_date=paste0(sprintf("%02d",month(sa_date)),"/",sprintf("%02d",day(sa_date)),"/",year(sa_date)),
           interview_age=round((interval(start = dob, end = sa_date) / duration(num = 1, units = "months")),0),
           gender="F",
           phenotype="Typical Control",
           phenotype_description="Typical Control",
           twins_study="No",
           sibling_study="No",
           family_study="No",
           sample_taken="Yes",
           sample_id_original="Session1_Saliva",
           sample_description="saliva",
           biorepository_name="NA",
           sample_id_biorepository="NA",
           patient_id_biorepository="NA",
           site="University of Oregon",
           comments_misc="Session1",
           study="UO TAG Study")
  participants_ndar_data<-left_join(participants_ndar_data,(ndar_race %>%
                                                              filter(tagid %in% ndar_key$tagid)), by="tagid") %>%
    mutate(race=ifelse(is.na(race),"Unknown or not reported",race))
  participants_ndar_data<-left_join(ndar_key,participants_ndar_data, by="tagid") %>%
    mutate(src_subject_id=anontagid,
           subjectkey=guid) %>%
    select(-tagid,-sa_date,-dob,-anontagid,-ID,-guid) 
  
  ndar_subject <- as.list(read.csv(paste0(datadir,"RDoCdb/templates/ndar_subject01_template.csv"), header = TRUE, stringsAsFactors = FALSE, skip=1))
  ndar_subject_df<-data.frame(ndar_subject)
  ndar_subject_df<-bind_rows(ndar_subject_df,participants_ndar_data)
  ndar_subject_df_header<-rep(NA,length(ndar_subject_df))
  ndar_subject_df_header[1]<-read.csv(paste0(datadir,"RDoCdb/templates/ndar_subject01_template.csv"), header = FALSE, stringsAsFactors = FALSE)[1,1]
  ndar_subject_df_header[2]<-read.csv(paste0(datadir,"RDoCdb/templates/ndar_subject01_template.csv"), header = FALSE, stringsAsFactors = FALSE)[1,2]
  part2<-colnames(ndar_subject_df)
  part3<-as.matrix(ndar_subject_df)
  colnames(part3)<-NULL
  together<-rbind(ndar_subject_df_header,part2,part3)
  write.table(together,file = paste0(datadir,"RDoCdb/output/", up_to_this_month, "/ndar_subject01.csv"),sep=",",na = "",row.names=FALSE,col.names=FALSE)
  rm(ndar_race,ethnicity_long,ndar_ethnicity,together,part3,part2,ndar_subject_df_header,ndar_subject,ndar_subject_df,ndar_ethnicity.df,participants_ndar_data)
}


replace_values <- function(datadir, cleaned_survey_data){
  # this function reads a csv with modified answers and replaces values in cleaned_survey_data with the replacement values when appropriate
  
  replacement <- read.csv(paste0(datadir, "Questionnaires/Modified_Answers.csv")) # import csv of modified answers
  cleaned_replaced_survey_data <- cleaned_survey_data 
  
  # generate columns with all info to match on (ID, survey name, and item name)
  replacement$all_match_info <- interaction(replacement$tagid, replacement$survey_name, replacement$item)
  cleaned_replaced_survey_data$all_match_info <- interaction(cleaned_replaced_survey_data$tagid, cleaned_replaced_survey_data$survey_name, cleaned_replaced_survey_data$item)
  
  # replace values in cleaned_replaced_survey_data with those in the replacement dataframe if they match on the matching indices
  replacement_exact <- replacement[!is.na(match(replacement$all_match_info, cleaned_replaced_survey_data$all_match_info)), ] # filter out non-matching values
  cleaned_replaced_survey_data$value[match(replacement_exact$all_match_info, cleaned_replaced_survey_data$all_match_info)] <- replacement_exact$kept_value
  
  # CTQ is the most commonly replaced value, but its qualtrics output ends in "..1" for some weird reason... the next couple of lines account for that
  no_exact_replacement <- replacement[is.na(match(replacement$all_match_info, cleaned_replaced_survey_data$all_match_info)), ]
  replacement_dots <- no_exact_replacement
  replacement_dots$item <- paste0(replacement_dots$item, "..1")
  replacement_dots$all_match_info <- interaction(replacement_dots$tagid, replacement_dots$survey_name, replacement_dots$item)
  replacement_dots <- replacement_dots[!is.na(match(replacement_dots$all_match_info, cleaned_replaced_survey_data$all_match_info)), ]
  cleaned_replaced_survey_data$value[match(replacement_dots$all_match_info, cleaned_replaced_survey_data$all_match_info)] <- replacement_dots$kept_value

  match(as.character(replacement_dots$all_match_info), as.character(no_exact_replacement$all_match_info))
  
  # print to console
  ifelse((!no_exact_replacement$all_match_info %in% replacement_dots$all_match_info),
         print(paste0("There is no ", replacement_dots$all_match_info, " in the cleaned_survey_data from qualtrics")), 
         NA)
               # print values with no tagid, survey_name, and item match between modified_answers.csv and the qualtrics output 

  saveRDS(cleaned_replaced_survey_data, file = paste0(datadir, "Questionnaires/cleaned_replaced_survey_data.rds"))
  return(cleaned_replaced_survey_data)
}



manual_replacement <- function(datadir, questionnaire_name){
  manual_replacement <- read.csv(paste0(datadir, "Qualtrics_and_MRI_Issues/Qualtrics_and_MRI_Issues.csv")) %>% 
    filter(!is.na(discarded_value))
  manual_replacement$tagid <- as.character(manual_replacement$tagid) 
  manual_replacement$survey_name <- as.character(manual_replacement$survey_name)
  manual_replacement$item <- as.character(manual_replacement$item)
  manual_replacement$item[startsWith(manual_replacement$item, "CTQ")] <- paste0(manual_replacement$item[startsWith(manual_replacement$item, "CTQ")], "..1") # for CTQ items, add "..1" to the end of the manual replacements, because that's what the cleaned survey data look like
  
  manual_replacement_ftq <- filter(manual_replacement, stringr::str_detect(manual_replacement$item, paste0("^", questionnaire_name))) # ftq = "for this questionnaire
  
  # a lot of the manual replacements are for CTQ, which are CTQ_## appended by "..1", so figure out how to get that to match
  for (i in 1:nrow(manual_replacement_ftq)){ #
    idx = which(cleaned_survey_data$tagid == manual_replacement_ftq$tagid[i] & 
                  (cleaned_survey_data$survey_name == manual_replacement_ftq$survey_name[i] |  cleaned_survey_data$survey_name == manual_replacement_ftq$survey_name_alt[i]) & 
                  cleaned_survey_data$item == manual_replacement_ftq$item[i])
    
    if (length(idx) == 1){  
      cleaned_survey_data[idx, ]$value = manual_replacement_ftq$kept_value[i] # otherwise, replace with the correct value
    } else if (length(idx) == 0) {
      # one common problem is that the survey_name was entered incorrectly in manual replacements. uncommenting this piece of code will help you check what survey_names participants took, so that you can see if they match
      # filter(cleaned_survey_data, (tagid == "INDICATE_TAGID_HERE")) %>% distinct(survey_name)
      print("Problematic: One of the manual replacements indicated is NOT being made, because it doesn't match the data. Check the entry for typos, including extra spaces. Use filter(cleaned_survey_data, (tagid == \"INDICATE_TAGID_HERE\")) %>% distinct(survey_name)\" to see the names of surveys taken by the subject in question.")
      print(paste0("There are no entries matching ", manual_replacement_ftq$survey_name[i], " for ", manual_replacement_ftq$tagid[i], " for the following item: ", manual_replacement_ftq$item[i]))
    } else if (length(idx) > 1) {
      print(paste0("There is more than one entry matching ", manual_replacement_ftq$survey_name[i], " for ", manual_replacement_ftq$tagid[i], " for the following item: ", manual_replacement_ftq$item[i], ". This is not necessarily problematic. Some subjects took a questionnaire >1x; this will replace all instances with the kept_value specified in the csv file.")) 
    }
  }

  return(cleaned_survey_data)
}
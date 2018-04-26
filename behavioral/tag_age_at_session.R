# TAG study calculate age at each session
# Last updated MLB 11 Apr 2018

# Load packages
install.packages("readr")
install.packages("tidyr")
install.packages("lubridate")
library(readr)
library(tidyr)
library(lubridate)

# WD is on server \\casfiles2\psych-cog
setwd("B:/dsnlab/TAG/behavior/Demographics/Age")

# Import the CSV file
tag_age_session <- read_csv('DOB_W1W2_SessionDates.csv')
View(tag_age_session)

# Tidy into long format
tag_age_session_gathered <- gather(tag_age_session, wave_session, 
                                   date, -TAG_ID, -DOB)
View(tag_age_session_gathered)

tag_age_session_gathered$wave <- ifelse(tag_age_session_gathered$wave_session 
                                        == "W1S1_Date" | 
                                          tag_age_session_gathered$wave_session
                                        =="W1S2_Date", 1, 2)
tag_age_session_gathered$session <- ifelse(tag_age_session_gathered$wave_session 
                                        == "W1S1_Date" | 
                                          tag_age_session_gathered$wave_session
                                        =="W2S1_Date", 1, 2)
tag_age_session_gathered <- tag_age_session_gathered[ -c(3) ]

# Calculate age at each session

tag_age_session_gathered$DOB <- mdy(na.pass(tag_age_session_gathered$DOB))
tag_age_session_gathered$date <- mdy(na.pass(tag_age_session_gathered$date))

tag_age_session_gathered$age <- interval(start = 
                                            tag_age_session_gathered$DOB, 
                                            end = 
                                            tag_age_session_gathered$date) / 
                                            duration(num = 1, units = "years")

View(tag_age_session_gathered)
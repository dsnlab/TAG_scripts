# Some stuff to analyse TAG W1 CTQ and CRP data and stuff
# Questions: michelle.byrne@gmail.com


setwd("Z:/dsnlab/TAG/projects/W1_ctq_crp")
data <- read.csv("all_w1_ctq_crp.csv")

#truncate that ish
data <- data[-c(175:719), ]

# take out stuff that doesn't need to be imputed like notes and DOBs
w1ctqcrp <- data[ , -c(9,10,12,13,16,19,21,23,24)]


# Check missing data patterns and MCAR:

# Here is a way to test MCAR but limited to 50 vars:
# Check that ish is assumed missing completely at random using Little's test
library(BaylorEdPsych)
library(mvnmle)

Little.out <- LittleMCAR(w1ctqcrp)
MCAR.out <- capture.output(Little.out)
write.csv(MCAR.out, file = "MCARresults.csv")

# Here is another way that also runs both parametric and non-parametric tests, leaving here for nostalgic reasons.
#library(MissMech)
# Info re TestMCARNormality: http://www.inside-r.org/packages/cran/MissMech/docs/TestMCARNormality
#Missinginfo <- OrderMissing(data, del.lesscases = 0)
#summary(Missinginfo)
#write.csv (summary(Missinginfo), "Missinginfo_APQ.csv")
#data.nummat <- data.matrix(data, rownames.force = NA)
#data.out <- TestMCARNormality(data.nummat)
#print(data.out)
# NOTE: If your data matrix is singular, TestMCARNormality won't work. Try removing extra variables that may be colinear.


# Single Imputation using Amelia:

library("Amelia")

a.outEM <- amelia(w1ctqcrp, m = 1, idvars = c("TAG_ID"), bounds = rbind(c(2, 0, Inf), c(3, 0, Inf), 
                                                                        c(4, 0, Inf), c(5, 0, Inf), 
                                                                        c(6, 0, Inf), c(7, 0, Inf), 
                                                                        c(8, 0, Inf), c(9, 0, Inf), 
                                                                        c(10, 0, Inf), c(11, 0, Inf), 
                                                                        c(12, 0, Inf), c(13, 0, Inf),
                                                                        c(14, 0, Inf), c(15, 0, Inf),
                                                                        c(16, 0, Inf), c(17, 0, Inf)), 
                  noms = c("W1_re","taking_medication_1yes","participant_sick_1yes","gums_bleed_1yes",
                           "freelunch_1yes"), boot.type = "none")

write.amelia(obj=a.outEM, file.stem = "imputeddataEM")

EMdata <- read.csv("imputeddataEM1.csv")

# sum the CTQ subscales:
EMdata$CTQtotal <- EMdata$CTQ_emotionalabuse_total + EMdata$CTQ_emotionalneglect_total +
  EMdata$CTQ_physicalabuse_total + EMdata$CTQ_physicalneglect_total + EMdata$CTQ_sexualabuse_total

# Visualize your data to see normality and outiers

# Histograms for immune markers to visualize normality

hist(EMdata$crp_ngml)


#Boxplots to visualize outliers

library(ggplot2)

ggplot(EMdata, aes(x = "", y = crp_ngml)) +   
  geom_boxplot() +
  ylab("CRP (ng/ml)") +
  ggtitle("TAG W1 CRP") +
  geom_smooth(method='lm', color="black")


#  Calculate and report normality statistics (skew and kurtosis)
# Kurtosis and Skew should be -2/+2 (West, et al. 1995)

crp_summary <- describe(EMdata$crp_ngml)
crp_summary

# If necessary, transform data
#Report the type of transformation (e.g., ln, log10, etc.)
#Visualize boxplot again after transformation

# Transform 
# if skew or kurtosis is < -2 or > 2 then calculate the natural log of that variable

if (crp_summary$skew > 2 | crp_summary$skew < -2 | crp_summary$kurtosis > 2 | crp_summary$kurtosis < -2) {
  EMdata$ln_crp <- as.numeric(lapply(EMdata$crp_ngml, log))
}

# Check everything post transformation for any transformed variables (will need to copy this for any additional transformed variables - in this example, only SIgA was non normal). 

describe(EMdata$ln_crp)

hist(EMdata$ln_crp)

ggplot(EMdata, aes(x = "", y = ln_crp)) +   
  geom_boxplot() +
  ylab("log (CRP)") +
  ggtitle("TAG W1 CRP (log transformed)") +
  geom_smooth(method='lm', color="black")

# If transforming makes the skew and kurtosis worse, don't use the transformed data (i.e., comment this next line (which would replace the descriptive stats with the transformed ones for that variable) and make sure not to use transformed data from this point on). DO make a note that you MAY need to use non-parametric testing for this variable instead. BUT wait until you have fixed the outliers below and checked skew/kurtosis first.
# siga_summary <- describe(easeimm$ln_siga)

# For dealing with outliers, skip down to the bottom of this script. For this analysis, winsorizing the outliers
# that were +/- 3 SD (of which there were 84 out of 174!!) made the data worse and more skewed - the distribution
# without winsorizing was fine and so we decided not to winsorize (and made an addendum to the prereg for this)


# So now we did all that bloody tidying up, here's our actual regression

# First, without covariates:
CTQ_CRP <- lm(ln_crp ~ CTQtotal, data = EMdata)
summary(CTQ_CRP)
confint(CTQ_CRP, 'CTQtotal', level=0.95)

# check heteroscedasticity to see if we also need to transform CTQ
par(mfrow=c(2,2)) # init 4 charts in 1 panel
plot(CTQ_CRP) # based on the residuals vs fitted plot something is wrong
install.packages("lmtest")
library(lmtest)
lmtest::bptest(CTQ_CRP)  # Breusch-Pagan test - tells you if the heteroscedasticity is significant. In this case it's NS

# but, look at the kurtosis for CTQ:
ctq_summary <- describe(EMdata$CTQtotal)
ctq_summary

# transforming either ln or sqrt made the kurtosis worse, so after also visualizing the regression, 
# we decided not to transform or winsorize the CTQ

# first test covariates bivariate correlations with CTQ and CRP

race_CRP <- lm(ln_crp ~ W1_re, data = EMdata)
summary(race_CRP)
bmi_CRP <- lm(ln_crp ~ bmi, data = EMdata)
summary(bmi_CRP)
age_CRP <- lm(ln_crp ~ age, data = EMdata)
summary(age_CRP)
temp_CRP <- lm(ln_crp ~ avg_temp_f, data = EMdata)
summary(temp_CRP)
med_CRP <- lm(ln_crp ~ taking_medication_1yes, data = EMdata)
summary(med_CRP)
sick_CRP <- lm(ln_crp ~ participant_sick_1yes, data = EMdata)
summary(sick_CRP)
gums_CRP <- lm(ln_crp ~ gums_bleed_1yes, data = EMdata)
summary(gums_CRP)
freelunch_CRP <- lm(ln_crp ~ freelunch_1yes, data = EMdata)
summary(freelunch_CRP)
time_CRP <- lm(ln_crp ~ collection_time_int, data = EMdata)
summary(time_CRP)

race_CTQ <- lm(CTQtotal ~ W1_re, data = EMdata)
summary(race_CTQ)
bmi_CTQ <- lm(CTQtotal ~ bmi, data = EMdata)
summary(bmi_CTQ)
age_CTQ <- lm(CTQtotal ~ age, data = EMdata)
summary(age_CTQ)
temp_CTQ <- lm(CTQtotal ~ avg_temp_f, data = EMdata)
summary(temp_CTQ)
med_CTQ <- lm(CTQtotal ~ taking_medication_1yes, data = EMdata)
summary(med_CTQ)
sick_CTQ <- lm(CTQtotal ~ participant_sick_1yes, data = EMdata)
summary(sick_CTQ)
gums_CTQ <- lm(CTQtotal ~ gums_bleed_1yes, data = EMdata)
summary(gums_CTQ)
freelunch_CTQ <- lm(CTQtotal ~ freelunch_1yes, data = EMdata)
summary(freelunch_CTQ)
time_CTQ <- lm(CTQtotal ~ collection_time_int, data = EMdata)
summary(time_CTQ)

# In this data it looks like BMI, meds, being sick, and free lunch status are relevant to include in the model

CTQ_CRP_cov <- lm(ln_crp ~ CTQtotal + bmi + taking_medication_1yes + 
                    participant_sick_1yes + freelunch_1yes, data = EMdata)
summary(CTQ_CRP_cov)
confint(CTQ_CRP_cov, 'CTQtotal', level=0.95)

# The above shows no significant effect of CTQ on CRP with covariates

# Exploratory hypotheses were BMI x CTQ on CRP and free lunch x CTQ on CRP:

# Center the continuous IVs (i.e., not freelunch)
EMdata$bmi_cen <- EMdata$bmi - mean(EMdata$bmi)
EMdata$CTQtotal_cen <- EMdata$CTQtotal - mean (EMdata$CTQtotal)

# Interactions
CTQ_x_BMI_CRP <- lm(ln_crp ~ CTQtotal_cen * bmi_cen + taking_medication_1yes + 
                      participant_sick_1yes + freelunch_1yes, data = EMdata)
summary(CTQ_x_BMI_CRP)
confint(CTQ_x_BMI_CRP, 'CTQtotal', level=0.95)

CTQ_x_freelunch_CRP <- lm(ln_crp ~ CTQtotal_cen * freelunch_1yes + bmi + taking_medication_1yes + 
                            participant_sick_1yes, data = EMdata)
summary(CTQ_x_freelunch_CRP)
confint(CTQ_x_freelunch_CRP, 'CTQtotal', level=0.95)





   # -----------------------------------------
   # Leftover winsorizing stuff from here to end - commented out:

#  Dealing with outliers (includes previously OOR values) - remember this is for ln transformed so ok if low limit is negative

#crp_up_limit <- (crp_summary$mean + 3*(crp_summary$sd))
#crp_up_limit
#crp_lo_limit <- (crp_summary$mean - 3*(crp_summary$sd))
#crp_lo_limit

# in order to use the Winsorize FUN with set min/max vals, Winsorize must be capitalized :)
# original: easeimm$siga_frc
# cleaned:

#library(DescTools)
#EMdata$crp_w <- Winsorize(EMdata$ln_crp, minval = crp_lo_limit, maxval = crp_up_limit, na.rm = TRUE)

#Code from here to end of chunk thank you to Johnny
#Put both the original data and the cleaned data in the same df:

#df_crp <- data.frame(type=c(rep.int("easeimm$crp", length(easeimm$crp)),
#                           rep.int("easeimm$crp_w",  length(easeimm$crp_w))),
#                     data=c(easeimm$crp, easeimm$crp_w))

# This is to check it out but I'd probably change it to two boxplots:

#ggplot(df_crp, aes(x=data, y=as.numeric(type), color=type))+
#  geom_point(position=position_jitter(height=0.5))

# identify the points that were changed to the min and max
# (aka those points that are equal to the min and max but weren't before)

#cleaned_crp <- na.omit(easeimm$crp_w)
#original_crp <- na.omit(easeimm$crp)

#min_pts_crp <- which(cleaned_crp == min(cleaned_crp) & original_crp != min(cleaned_crp))
#max_pts_crp <- which(cleaned_crp == max(cleaned_crp) & original_crp != max(cleaned_crp))

# NOTE: I haven't tested anything below because I don't have a variable with more than one outlier...

# then rank them
# rank will give you smallest -> largest ranks, 
# so to get least-> most outlierish we just reverse min_ranks

#min_ranks_crp <- rank(original_crp[min_pts_crp])
#min_ranks_crp <- max(min_ranks_crp) - min_ranks_crp + 1
#max_ranks_crp <- rank(original_crp[max_pts_crp])

# now you can replace them with whatever you want

#rank_preserving_crp <- cleaned_crp
#rank_preserving_crp[min_pts_crp] <- rank_preserving_crp[min_pts_crp]-(increment * min_ranks_crp)
#rank_preserving_crp[max_pts_crp] <- rank_preserving_crp[max_pts_crp]+(increment * max_ranks_crp)

# check out what we did

#outliers_crp <- c(min_pts_crp, max_pts_crp)
#comparison_crp <- cbind(original_crp[outliers_crp],
#                        cleaned_crp[outliers_crp],
#                        rank_preserving_crp[outliers_crp])

# reorder by the first column

#comparison_crp <- comparison_crp[order(comparison_crp[,1]),]

 
# Report how many samples were outliers (may include previously OOR values)


# Count outliers and report these numbers
#siga_num_right_outliers <- length(na.omit(easeimm$siga_frc [easeimm$siga_frc > siga_up_limit])) 
#siga_num_left_outliers <- length(na.omit(easeimm$siga_frc [easeimm$siga_frc < siga_lo_limit])) 


# Visualize again after fixing outliers & double check skew, etc
#hist(easeimm$crp_w)

#ggplot(easeimm, aes(x = "", y = crp_w)) +   
#  geom_boxplot() +
#  ylab("CRP (pg/ml)") +
#  ggtitle("EASE CRP - winsorized") +
#  geom_smooth(method='lm', color="black")

#crp_w_summary <- describe(easeimm$crp_w)

#crp_w_summary

# If your skew/kurtosis are fine, no need to use non-parametric tests now.


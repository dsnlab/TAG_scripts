#author: john flournoy
#email: flournoy@uoregon.edu
#version: 0.1
#date: 2015-05-13
#
# This script takes the rp text files generated during realignment and calculates Euclidian composite scores for X,Y,Z 
# translation and pitch, yaw, roll rotation. It generates a .csv file with the following variables for each run: 
# mean and max translation and rotation, and proportion of volumes exceeding various translation and rotation thresholds
# (e.g. 0.5mm, 1mm, 1.5mm, 2mm, 1 degree, 2 degrees).

# To run the script, the main variables that need to be changed are:
# subjsDir, motionPDFdir, subject, and run

#If you don't have the following packages installed, use the install.packages("package") command for each one

osuRepo<-'http://ftp.osuosl.org/pub/cran/'

#####
if(!require(knitr)){
	install.packages('knitr',repos=osuRepo)
}
library(knitr)
if(!require(rmarkdown)){
	install.packages('rmarkdown',repos=osuRepo)
}
library(rmarkdown)
if(!require(dplyr)){
	install.packages('dplyr',repos=osuRepo)
}
library(dplyr) # Great help for this package at http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html
if(!require(tidyr)){
	install.packages('tidyr',repos=osuRepo)
}
library(tidyr)
if(!require(reshape2)){
	install.packages('reshape2',repos=osuRepo)
}
library(reshape2)
if(!require(ggplot2)){
	install.packages('ggplot2',repos=osuRepo)
}
library(ggplot2)
if(!require(pracma)){
	install.packages('pracma',repos=osuRepo)
}
library(pracma)
if(!require(stringr)){
	install.packages('stringr',repos=osuRepo)
}
library(stringr)
#
# Directories
#	!!: Make sure the directories below exist. This script will not make them.
#
# base directory for subjects
subjsDir<-'/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fmri/fx/motion/wave1/rawmotion' 
# requires trailing '/' - this is the path to prepend to output pdf filename. 
motionPDFdir<-'/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fmri/fx/motion/wave1/auto-motion-output/' 
# requires trailing '/' - this is where the augmented rp_*txt files go
motion_rp_txt_dir<-'/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fmri/fx/motion/wave1/auto-motion-output/rp_txt/'


#
# Extracting Subject and Run ids
#
# We need to extract subject id and run id from the path. To do so, 
# you need to set the regular expressions below to capture the correct 
# information. The expression needs to match the whole path -- for example:
# '^(t[0-9]{3})/.*txt' will match
# "t165/ppc/functionals/vid2/rp_vid2_0001.txt" in its entirety, but the 
# parentheses will allow us to pick out just the 't165'.
#
sid_regex<-'^([0-9]{3})/.*txt' #add regular expression for subject ID between the `()`
rid_regex<-'^[0-9]{3}/(\\w+)/.*txt' #add regular expression for run ID between `()`

#
# Document options
#
# can also be html_document
docType<-'pdf_document' 
# change according to docType
docTypeExtension<-'.pdf' 
figureWidth<-7.75
figureHeight<-10.25
dpi=300
dev='svg' #Can change to png or pdf if you prefer.

###
# rp_txt output options
#######################
#
# Do you want to export new rp_txt files into the above rp_txt_dir?
RP_EXPORT = TRUE
# These are the first 3 columns in the raw rp_*txt file output by SPM
# units: mm
raw_trans = FALSE
# These are the second 3 columns in the raw rp_*txt file output by SPM
# units: mm on a circle where r=50mm
raw_rot = FALSE
# These next two are the above two but with their lag-1 values subtracted - volume to volume change
# units: mm
raw_trans_deriv = FALSE
raw_rot_deriv = FALSE
# These next four are the same as the above 4 but detrended with `detrend`
# units: mm
dt_raw_trans = FALSE
dt_raw_rot = FALSE
dt_raw_trans_deriv = FALSE
dt_raw_rot_deriv = FALSE
# Absolute displacement, calc'd below
# units: mm
euclidian_trans = TRUE
# This is proportional to absolute rotation, calc'd below
# units: mm
euclidian_rot = TRUE
# These next two are the volume to volume differences in the above two
# units: mm
euclidian_trans_deriv = TRUE
euclidian_rot_deriv = TRUE
#
## Trash regressor options
#
TRASH_REGRESSOR = TRUE
#`trash_expression` is a logical expression using *only* the variable names above.
#For example `(raw_trans_deriv > 2)` would check each of the x, y, and z
#translational derivatives, and if any are over 2mm, would put a 1 in the
#trash regressor column, and a 0 otherwise.  
#trash_expression<-'(raw_trans_deriv > 2) & (raw_rot_deriv > 10) | (euclidian_rot_deriv > 1)'
trash_expression<-'(euclidian_trans_deriv < -1 ) | (euclidian_rot_deriv < -1) | (euclidian_trans_deriv > 1 ) | (euclidian_rot_deriv > 1)'
###################################


	

####################################
# Dragons Below          ######
##########################

# Programatic var definitions

VAR_TO_OPTION_TABLE<-data.frame(
	varname=c(
		'x', 'y', 'z',
		'pitch', 'roll', 'yaw',
		'x_d', 'y_d', 'z_d',
		'pitch_d', 'roll_d', 'yaw_d',
		'x_dt', 'y_dt', 'z_dt',
		'pitch_dt', 'roll_dt', 'yaw_dt',
		'x_d_dt', 'y_d_dt', 'z_d_dt',
		'pitch_d_dt', 'roll_d_dt', 'yaw_d_dt',
		'trans',
		'rot',
		'deriv_trans',
		'deriv_rot'),
	option_name=c(
			rep('raw_trans',3),
			rep('raw_rot',3),
			rep('raw_trans_deriv',3),
			rep('raw_rot_deriv',3),
			rep('dt_raw_trans',3),
			rep('dt_raw_rot',3),
			rep('dt_raw_trans_deriv',3),
			rep('dt_raw_rot_deriv',3),
			'euclidian_trans',
			'euclidian_rot',
			'euclidian_trans_deriv',
			'euclidian_rot_deriv'),
	include=c(
			rep(raw_trans,3),
			rep(raw_rot,3),
			rep(raw_trans_deriv,3),
			rep(raw_rot_deriv,3),
			rep(dt_raw_trans,3),
			rep(dt_raw_rot,3),
			rep(dt_raw_trans_deriv,3),
			rep(dt_raw_rot_deriv,3),
			euclidian_trans,
			euclidian_rot,
			euclidian_trans_deriv,
			euclidian_rot_deriv))


if(RP_EXPORT){
	param_names_for_rp_write<-VAR_TO_OPTION_TABLE %>%
		filter(include) %>% select(varname) %>% unlist %>% as.character
}

if(TRASH_REGRESSOR){
	trash_sub_table<-data.frame(
		raw=regmatches(
			trash_expression,
			gregexpr('\\w+ *[<=>]+ *[-0-9]+',trash_expression))[[1]]) %>%
		mutate(operator=sub('.*([<=>]).*','\\1',raw)) %>%
		separate(raw,c('var','num'),sep=' *[<=>] *',remove=F)

	if (!all(trash_sub_table$var %in% c(
		as.character(VAR_TO_OPTION_TABLE$option_name),
		as.character(VAR_TO_OPTION_TABLE$varname)))) stop("Trash expression not valid: can't find some variable name")
	subs<-trash_sub_table %>% group_by(raw) %>%
		do({
			var<-.$var
			operator<-.$operator
			num<-.$num
			expressions<-VAR_TO_OPTION_TABLE %>% 
				filter(option_name %in% var) %>%
				select(varname) %>% 
				unlist %>% 
				paste(operator,num)
				expressions_collapsed<-paste('(',paste(expressions,collapse=' | '),')')
			data_frame(expression=expressions_collapsed)
		})

	named_expressions<-subs$expression
	names(named_expressions)<-subs$raw

	tformd_trash_expression<-str_replace_all(trash_expression,named_expressions)
	cat(paste0("\n\nUsing this expression for trash regressor:\n",
		tformd_trash_expression,"\n\n"))

	param_names_for_rp_write<-c(param_names_for_rp_write,'trash')
}

# Functions

knit_a_bit<-function(aDF){
	aDF_m<-melt(aDF,id.vars=c('subject','run','vol_num'))
	filenamePrefix<-paste(aDF$subject[1],sep='_')
	fullFilePrefix<-paste(motionPDFdir,filenamePrefix,sep='')
	knit_template=paste("
```{r Trans, fig.width=",figureWidth,",fig.height=",figureHeight,",fig.path='figures/",filenamePrefix,"',echo=FALSE}
aDF_m %>%
filter(variable %in% c('x','y','z','trans','deriv_trans')) %>%
ggplot(aes(x=vol_num,y=value))+
	geom_line(aes(color=variable))+
	facet_wrap(~run,ncol=2)+
	labs(x='Volume',y='mm',title=paste(aDF_m$subject[1],sep=' '))+
	scale_color_manual(
		guide = guide_legend(),
		values=c('gray','gray','gray','blue','red'),
		labels=c('x','y','z','Translation\nfrom Origin','Derivative'))+
	theme(
		axis.text=element_text(size=8),
		strip.text = element_text(size = 8),
		legend.position='bottom',
		panel.background=element_rect(fill='white'))
```

```{r Rot, fig.width=",figureWidth,",fig.height=",figureHeight,",fig.path='figures/",filenamePrefix,"',echo=FALSE}
aDF_m %>%
filter(variable %in% c('pitch','roll','yaw','rot','deriv_rot')) %>%
ggplot(aes(x=vol_num,y=value))+
	geom_line(aes(color=variable))+
	facet_wrap(~run,ncol=2)+
	labs(x='Volume',y='Degrees',title=paste(aDF_m$subject[1],sep=' '))+
	scale_color_manual(
		guide = guide_legend(),
		values=c('gray','gray','gray','blue','red'),
		labels=c('pitch','roll','yaw','Rotation\nfrom Origin','Derivative'))+
	theme(
		axis.text=element_text(size=8),
		strip.text = element_text(size = 8),
		legend.position='bottom',
		panel.background=element_rect(fill='white'))
```

```{r echo=FALSE}
aDF %>% group_by(run) %>%
summarise(
	N_vols=n(),
	maxTransDeriv=max(deriv_trans),
	maxRotDeriv=max(deriv_rot),
	meanTransDeriv=mean(deriv_trans),
	meanRotDeriv=mean(deriv_rot),
	Prop_gt_p5mm=sum(deriv_trans>.5)/N_vols,
	Prop_gt_1mm=sum(deriv_trans>1)/N_vols,
	Prop_gt_1p5mm=sum(deriv_trans>1.5)/N_vols,
	Prop_gt_2mm=sum(deriv_trans>2)/N_vols) %>%
kable(
	col.names=c('Run','N','Max: Trans','Rot','Mean: Trans','Rot','Prop: > .5mm','> 1mm','> 1.5mm','> 2mm'),
	caption=paste('Motion Statistics for',aDF$subject[1],sep=' '),
	digits=2)
```",sep='')
	write(knit_template,paste(fullFilePrefix,'.Rmd',sep=''))
	render(
		paste(fullFilePrefix,'.Rmd',sep=''),
		output_format=docType,
		output_file=paste(fullFilePrefix,docTypeExtension,sep=''))
	RmdFile<-paste(fullFilePrefix,'.Rmd',sep='')
}

#### l2norm3ddf #####
#This takes three vectors and for each row calculates
# the L2 norm (also known as Euclidean distance).
# It returns a variable class according the default
# for `apply`
l2norm3ddf<-function(a,b,c){
	aDF<-data.frame(a,b,c)
	apply(aDF,1,function(vect) norm(matrix(vect),'f'))
}

# main

opts_chunk$set(dpi=dpi,dev=dev)

setwd(subjsDir)
rawmotion<-data.frame(rp_file=list.files(recursive=T,pattern='^.*\\.txt')) %>% # Make the directory listing into a data frame
	group_by(rp_file) %>% # Group by each rp_file
	# slice(1:2) %>% # for testing
	do( # For each rp_file, do:
		read.table( # read the text file as if it's a data table (which it is)
			file=as.character(.$rp_file[1]),
			col.names=c('x','y','z','pitch','roll','yaw'))
		) %>%  # name the columns of the data frame
	mutate(
	  subject=substring(rp_file, 4,6),
	  run=substring(rp_file, 8,11),
	  #For the radian to arc-length conversion, remember: "An angle of 1 radian 
	  #refers to a central angle whose subtending arc is equal in length to the 
	  #radius." http://www.themathpage.com/aTrig/arc-length.htm
	  #If we multiply the radian output of the rp text by the average head radius
	  #of 50mm, we get a rotational displacement from the origin at the outside of
	  #an average skull.
	  pitch=50*pitch,
	  roll=50*roll,
	  yaw=50*yaw,
	  x_d=c(0,diff(x)),
	  y_d=c(0,diff(y)),
	  z_d=c(0,diff(z)),
	  pitch_d=c(0,diff(pitch)),
	  roll_d=c(0,diff(roll)),
	  yaw_d=c(0,diff(yaw)),
	  x_dt=detrend(x),
	  y_dt=detrend(y),
	  z_dt=detrend(z),
	  pitch_dt=detrend(pitch),
	  roll_dt=detrend(roll),
	  yaw_dt=detrend(yaw),
	  x_d_dt=detrend(x_d),
	  y_d_dt=detrend(y_d),
	  z_d_dt=detrend(z_d),
	  pitch_d_dt=detrend(pitch_d),
	  roll_d_dt=detrend(roll_d),
	  yaw_d_dt=detrend(yaw_d),
	  trans=l2norm3ddf(x,y,z),
	  rot=l2norm3ddf(pitch,roll,yaw),
	  deriv_trans=c(0,diff(trans)),
	  deriv_rot=c(0,diff(rot))) %>%
	group_by(rp_file) %>%
	mutate(vol_num=1:n())

if(TRASH_REGRESSOR){
	rawmotion<-rawmotion %>%
		mutate_(trash=paste0('as.numeric(',tformd_trash_expression,')'))
}

if(RP_EXPORT){
	rp_files_written<-rawmotion %>% 
		arrange(subject,run,vol_num) %>% 
		group_by(subject,run) %>% 
		select_(.dots=param_names_for_rp_write) %>% #select with a '_' after, and .dots lets us give `select` a vector of characters instead of raw column names
		do({
			fname=paste(
				motion_rp_txt_dir,
				'rp_',.$subject[[1]],'_',.$run[[1]],'.txt',
				sep='')
			write.table(
				.[,c(-1,-2)],
				fname,
				quote=F,
				sep='   ',
				row.names=F,
				col.names=F)
			data.frame(rp_file_name=fname)
		})
}

someSummary<-rawmotion %>% 
  ungroup() %>%
  group_by(subject,run) %>%
  summarise(
    N_vols=n(),
    maxTransDeriv=max(deriv_trans),
    maxRotDeriv=max(deriv_rot),
    meanTransDeriv=mean(deriv_trans),
    meanRotDeriv=mean(deriv_rot),
    Prop_gt_p5mm=sum(deriv_trans>.5)/N_vols,
    Prop_gt_1mm=sum(deriv_trans>1)/N_vols,
    Prop_gt_1p5mm=sum(deriv_trans>1.5)/N_vols,
    Prop_gt_2mm=sum(deriv_trans>2)/N_vols,
    Prop_gt_1deg=sum(deriv_rot>1)/N_vols,
    Prop_gt_2deg=sum(deriv_rot>1)/N_vols)
write.csv(
  someSummary,
  file=paste(motionPDFdir,'summary_by_subject_by_run.csv',sep=''),
  row.names=F)



motionWrittenToFile<-rawmotion %>% 
ungroup() %>%
select(-rp_file) %>%
#filter(subject %in% c('t101','t102')) %>%
group_by(subject) %>%
do(
	RmdFile=knit_a_bit(.))

deriv_trans_plot<-rawmotion %>% ungroup %>%
	ggplot(aes(x=deriv_trans))+
	geom_histogram(binwidth=.075,fill='red',alpha=.6)+
	facet_grid(subject~run)+
	coord_cartesian(x=c(-1.5,1.5))+
	theme(
		panel.background=element_rect(fill='white'),
		axis.text=element_text(size=6),
		axis.text.x=element_text(angle=270))+
	labs(
		x='Volume-to-volume differences in absolute distance from first image (mm)',
		y='Count',
		title='Histograms of Between-Volume Motion by Participant and by Run')

ggsave(
	deriv_trans_plot,
	file=paste(motionPDFdir,'displacement_hist-all_subjs.pdf',sep=''),
	width=17,
	height=22,
	units="in")

#https://www.reportlab.com/docs/reportlab-userguide.pdf
#load libraries
import numpy as np
import pandas as pd
import glob
from reportlab.pdfgen import canvas    
from pathlib import path

#import the Subject and Multisubject classes from subject.py
from subject import Subject
from subject import Multisubject

#set variables to specify directories and contrasts or betas


#get subject id's
files=sorted(Path("Y:/dsnlab/TAG/nonbids_data/fMRI/fx/models/svc/wave1and2/event/").glob("sub-*/wave*"))
ids = ['/'.join([i.parts[-2],i.parts[-1]]) for i in files]


#load data
subjects = [Subject(id=id, path='/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1and2/event') for id in ids]

#get a list of the contrasts and betas (for 1st subject)
contrast_list = repr(subjects[1].contrasts)
beta_list = repr(subjects[1].betas)

#put this info into a pdf
def textobject_demo():
    my_canvas = canvas.Canvas("txt_obj.pdf")
    # Create textobject
    textobject = my_canvas.beginText()
    # Set text location (x, y)
    textobject.setTextOrigin(10, 730)
    # Set font face and size
    textobject.setFont('Times-Roman', 12)
    # Write a line of text + carriage return
    textobject.textLines(contrast_list)
    # Write  text
    textobject.textLines(beta_list)
    # Write text to the canvas
    my_canvas.drawText(textobject)
    my_canvas.save()


#plot maps
#contrasts
[sub.plot_data(pattern = "Contrast 12:", contrast = True) for sub in subjects]
#betas
[sub.plot_data(pattern = "Contrast 12:", contrast = False) for sub in subjects]

#put plots into pdf


#other way to plot contrasts or betas
#multisub = Multisubject(subjects=subjects)
#multisub.plot_data(pattern = "Contrast 1:", contrast = True)
#and for specific subjects
#multisub[0:2].plot_data(pattern = "Contrast 1:", contrast = True)
#multisub[['FP001', 'FP002']].plot_data(pattern = "Contrast 1:", contrast = True)
#multisub[['FP001', 'FP002']].plot_data(pattern = "Contrast 1:", contrast = False)

# Apply summary stats to every contrast specified
#Arugments are positional as follows: pattern, contrast (True/False), functions
pd.concat(multisub.apply_to_pattern("self > change", True, np.mean, np.std, np.min, np.max))
# Apply summary stats to every beta specified
pd.concat(multisub.apply_to_pattern("self > change", False, np.mean, np.std, np.min, np.max))

#put tables into pdf

#save

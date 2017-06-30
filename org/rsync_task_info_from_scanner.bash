#!/bin/bash
rsync -aiv -e ssh dsnlab@kashkaval:/Users/dsnlab/Studies/TAG/DRS/task/input/tag*_wave_1_info.mat /home/research/dsnlab/Studies/TAG/behavioral/raw/input/ 

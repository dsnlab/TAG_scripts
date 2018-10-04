#!/bin/bash
#--------------------------------------------------------------
#
#SBATCH --job-name=DSD_3dMEMA
#SBATCH --output=output/DSD_3dMEMA_valueDiff_MLmotion_AR_RT.log
#SBATCH --error=output/DSD_3dMEMA_valueDiff_MLmotion_AR_RT.log
#SBATCH --cpus-per-task=25
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH --partition=fat,short
#SBATCH --time=0-8:00:00

module load prl
module load afni

fxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/wave1/pmod/MLmotion_AR_RT
rxdir=/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/dsd/wave1/pmod/MLmotion_AR_RT

echo $fxdir

cd $rxdir/value_diff

3dMEMA -prefix value_aff_neut	 -jobs 2       		 \
-max_zeros 0.25						 \
-missing_data 0                        			 \
-HKtest 						 \
-model_outliers						 \
-residual_Z                 				 \
-set value_aff_neut					 \
sub-TAG001 $fxdir/sub-TAG001/con_0010.nii    $fxdir/sub-TAG001/spmT_0010.nii \
sub-TAG005 $fxdir/sub-TAG005/con_0010.nii    $fxdir/sub-TAG005/spmT_0010.nii \
sub-TAG010 $fxdir/sub-TAG010/con_0010.nii    $fxdir/sub-TAG010/spmT_0010.nii \
sub-TAG011 $fxdir/sub-TAG011/con_0010.nii    $fxdir/sub-TAG011/spmT_0010.nii \
sub-TAG012 $fxdir/sub-TAG012/con_0010.nii    $fxdir/sub-TAG012/spmT_0010.nii \
sub-TAG013 $fxdir/sub-TAG013/con_0010.nii    $fxdir/sub-TAG013/spmT_0010.nii \
sub-TAG014 $fxdir/sub-TAG014/con_0010.nii    $fxdir/sub-TAG014/spmT_0010.nii \
sub-TAG015 $fxdir/sub-TAG015/con_0010.nii    $fxdir/sub-TAG015/spmT_0010.nii \
sub-TAG016 $fxdir/sub-TAG016/con_0010.nii    $fxdir/sub-TAG016/spmT_0010.nii \
sub-TAG018 $fxdir/sub-TAG018/con_0010.nii    $fxdir/sub-TAG018/spmT_0010.nii \
sub-TAG019 $fxdir/sub-TAG019/con_0010.nii    $fxdir/sub-TAG019/spmT_0010.nii \
sub-TAG020 $fxdir/sub-TAG020/con_0010.nii    $fxdir/sub-TAG020/spmT_0010.nii \
sub-TAG022 $fxdir/sub-TAG022/con_0010.nii    $fxdir/sub-TAG022/spmT_0010.nii \
sub-TAG023 $fxdir/sub-TAG023/con_0010.nii    $fxdir/sub-TAG023/spmT_0010.nii \
sub-TAG026 $fxdir/sub-TAG026/con_0010.nii    $fxdir/sub-TAG026/spmT_0010.nii \
sub-TAG027 $fxdir/sub-TAG027/con_0010.nii    $fxdir/sub-TAG027/spmT_0010.nii \
sub-TAG030 $fxdir/sub-TAG030/con_0010.nii    $fxdir/sub-TAG030/spmT_0010.nii \
sub-TAG032 $fxdir/sub-TAG032/con_0010.nii    $fxdir/sub-TAG032/spmT_0010.nii \
sub-TAG033 $fxdir/sub-TAG033/con_0010.nii    $fxdir/sub-TAG033/spmT_0010.nii \
sub-TAG034 $fxdir/sub-TAG034/con_0010.nii    $fxdir/sub-TAG034/spmT_0010.nii \
sub-TAG035 $fxdir/sub-TAG035/con_0010.nii    $fxdir/sub-TAG035/spmT_0010.nii \
sub-TAG036 $fxdir/sub-TAG036/con_0010.nii    $fxdir/sub-TAG036/spmT_0010.nii \
sub-TAG037 $fxdir/sub-TAG037/con_0010.nii    $fxdir/sub-TAG037/spmT_0010.nii \
sub-TAG038 $fxdir/sub-TAG038/con_0010.nii    $fxdir/sub-TAG038/spmT_0010.nii \
sub-TAG040 $fxdir/sub-TAG040/con_0010.nii    $fxdir/sub-TAG040/spmT_0010.nii \
sub-TAG041 $fxdir/sub-TAG041/con_0010.nii    $fxdir/sub-TAG041/spmT_0010.nii \
sub-TAG042 $fxdir/sub-TAG042/con_0010.nii    $fxdir/sub-TAG042/spmT_0010.nii \
sub-TAG045 $fxdir/sub-TAG045/con_0010.nii    $fxdir/sub-TAG045/spmT_0010.nii \
sub-TAG046 $fxdir/sub-TAG046/con_0010.nii    $fxdir/sub-TAG046/spmT_0010.nii \
sub-TAG048 $fxdir/sub-TAG048/con_0010.nii    $fxdir/sub-TAG048/spmT_0010.nii \
sub-TAG049 $fxdir/sub-TAG049/con_0010.nii    $fxdir/sub-TAG049/spmT_0010.nii \
sub-TAG050 $fxdir/sub-TAG050/con_0010.nii    $fxdir/sub-TAG050/spmT_0010.nii \
sub-TAG051 $fxdir/sub-TAG051/con_0010.nii    $fxdir/sub-TAG051/spmT_0010.nii \
sub-TAG053 $fxdir/sub-TAG053/con_0010.nii    $fxdir/sub-TAG053/spmT_0010.nii \
sub-TAG054 $fxdir/sub-TAG054/con_0010.nii    $fxdir/sub-TAG054/spmT_0010.nii \
sub-TAG055 $fxdir/sub-TAG055/con_0010.nii    $fxdir/sub-TAG055/spmT_0010.nii \
sub-TAG056 $fxdir/sub-TAG056/con_0010.nii    $fxdir/sub-TAG056/spmT_0010.nii \
sub-TAG059 $fxdir/sub-TAG059/con_0010.nii    $fxdir/sub-TAG059/spmT_0010.nii \
sub-TAG060 $fxdir/sub-TAG060/con_0010.nii    $fxdir/sub-TAG060/spmT_0010.nii \
sub-TAG062 $fxdir/sub-TAG062/con_0010.nii    $fxdir/sub-TAG062/spmT_0010.nii \
sub-TAG065 $fxdir/sub-TAG065/con_0010.nii    $fxdir/sub-TAG065/spmT_0010.nii \
sub-TAG066 $fxdir/sub-TAG066/con_0010.nii    $fxdir/sub-TAG066/spmT_0010.nii \
sub-TAG067 $fxdir/sub-TAG067/con_0010.nii    $fxdir/sub-TAG067/spmT_0010.nii \
sub-TAG068 $fxdir/sub-TAG068/con_0010.nii    $fxdir/sub-TAG068/spmT_0010.nii \
sub-TAG069 $fxdir/sub-TAG069/con_0010.nii    $fxdir/sub-TAG069/spmT_0010.nii \
sub-TAG070 $fxdir/sub-TAG070/con_0010.nii    $fxdir/sub-TAG070/spmT_0010.nii \
sub-TAG071 $fxdir/sub-TAG071/con_0010.nii    $fxdir/sub-TAG071/spmT_0010.nii \
sub-TAG072 $fxdir/sub-TAG072/con_0010.nii    $fxdir/sub-TAG072/spmT_0010.nii \
sub-TAG074 $fxdir/sub-TAG074/con_0010.nii    $fxdir/sub-TAG074/spmT_0010.nii \
sub-TAG075 $fxdir/sub-TAG075/con_0010.nii    $fxdir/sub-TAG075/spmT_0010.nii \
sub-TAG076 $fxdir/sub-TAG076/con_0010.nii    $fxdir/sub-TAG076/spmT_0010.nii \
sub-TAG077 $fxdir/sub-TAG077/con_0010.nii    $fxdir/sub-TAG077/spmT_0010.nii \
sub-TAG078 $fxdir/sub-TAG078/con_0010.nii    $fxdir/sub-TAG078/spmT_0010.nii \
sub-TAG080 $fxdir/sub-TAG080/con_0010.nii    $fxdir/sub-TAG080/spmT_0010.nii \
sub-TAG081 $fxdir/sub-TAG081/con_0010.nii    $fxdir/sub-TAG081/spmT_0010.nii \
sub-TAG084 $fxdir/sub-TAG084/con_0010.nii    $fxdir/sub-TAG084/spmT_0010.nii \
sub-TAG085 $fxdir/sub-TAG085/con_0010.nii    $fxdir/sub-TAG085/spmT_0010.nii \
sub-TAG086 $fxdir/sub-TAG086/con_0010.nii    $fxdir/sub-TAG086/spmT_0010.nii \
sub-TAG087 $fxdir/sub-TAG087/con_0010.nii    $fxdir/sub-TAG087/spmT_0010.nii \
sub-TAG088 $fxdir/sub-TAG088/con_0010.nii    $fxdir/sub-TAG088/spmT_0010.nii \
sub-TAG090 $fxdir/sub-TAG090/con_0010.nii    $fxdir/sub-TAG090/spmT_0010.nii \
sub-TAG091 $fxdir/sub-TAG091/con_0010.nii    $fxdir/sub-TAG091/spmT_0010.nii \
sub-TAG094 $fxdir/sub-TAG094/con_0010.nii    $fxdir/sub-TAG094/spmT_0010.nii \
sub-TAG095 $fxdir/sub-TAG095/con_0010.nii    $fxdir/sub-TAG095/spmT_0010.nii \
sub-TAG099 $fxdir/sub-TAG099/con_0010.nii    $fxdir/sub-TAG099/spmT_0010.nii \
sub-TAG100 $fxdir/sub-TAG100/con_0010.nii    $fxdir/sub-TAG100/spmT_0010.nii \
sub-TAG101 $fxdir/sub-TAG101/con_0010.nii    $fxdir/sub-TAG101/spmT_0010.nii \
sub-TAG102 $fxdir/sub-TAG102/con_0010.nii    $fxdir/sub-TAG102/spmT_0010.nii \
sub-TAG103 $fxdir/sub-TAG103/con_0010.nii    $fxdir/sub-TAG103/spmT_0010.nii \
sub-TAG104 $fxdir/sub-TAG104/con_0010.nii    $fxdir/sub-TAG104/spmT_0010.nii \
sub-TAG106 $fxdir/sub-TAG106/con_0010.nii    $fxdir/sub-TAG106/spmT_0010.nii \
sub-TAG107 $fxdir/sub-TAG107/con_0010.nii    $fxdir/sub-TAG107/spmT_0010.nii \
sub-TAG109 $fxdir/sub-TAG109/con_0010.nii    $fxdir/sub-TAG109/spmT_0010.nii \
sub-TAG111 $fxdir/sub-TAG111/con_0010.nii    $fxdir/sub-TAG111/spmT_0010.nii \
sub-TAG112 $fxdir/sub-TAG112/con_0010.nii    $fxdir/sub-TAG112/spmT_0010.nii \
sub-TAG114 $fxdir/sub-TAG114/con_0010.nii    $fxdir/sub-TAG114/spmT_0010.nii \
sub-TAG116 $fxdir/sub-TAG116/con_0010.nii    $fxdir/sub-TAG116/spmT_0010.nii \
sub-TAG119 $fxdir/sub-TAG119/con_0010.nii    $fxdir/sub-TAG119/spmT_0010.nii \
sub-TAG120 $fxdir/sub-TAG120/con_0010.nii    $fxdir/sub-TAG120/spmT_0010.nii \
sub-TAG122 $fxdir/sub-TAG122/con_0010.nii    $fxdir/sub-TAG122/spmT_0010.nii \
sub-TAG124 $fxdir/sub-TAG124/con_0010.nii    $fxdir/sub-TAG124/spmT_0010.nii \
sub-TAG125 $fxdir/sub-TAG125/con_0010.nii    $fxdir/sub-TAG125/spmT_0010.nii \
sub-TAG127 $fxdir/sub-TAG127/con_0010.nii    $fxdir/sub-TAG127/spmT_0010.nii \
sub-TAG130 $fxdir/sub-TAG130/con_0010.nii    $fxdir/sub-TAG130/spmT_0010.nii \
sub-TAG132 $fxdir/sub-TAG132/con_0010.nii    $fxdir/sub-TAG132/spmT_0010.nii \
sub-TAG138 $fxdir/sub-TAG138/con_0010.nii    $fxdir/sub-TAG138/spmT_0010.nii \
sub-TAG141 $fxdir/sub-TAG141/con_0010.nii    $fxdir/sub-TAG141/spmT_0010.nii \
sub-TAG144 $fxdir/sub-TAG144/con_0010.nii    $fxdir/sub-TAG144/spmT_0010.nii \
sub-TAG145 $fxdir/sub-TAG145/con_0010.nii    $fxdir/sub-TAG145/spmT_0010.nii \
sub-TAG147 $fxdir/sub-TAG147/con_0010.nii    $fxdir/sub-TAG147/spmT_0010.nii \
sub-TAG149 $fxdir/sub-TAG149/con_0010.nii    $fxdir/sub-TAG149/spmT_0010.nii \
sub-TAG152 $fxdir/sub-TAG152/con_0010.nii    $fxdir/sub-TAG152/spmT_0010.nii \
sub-TAG155 $fxdir/sub-TAG155/con_0010.nii    $fxdir/sub-TAG155/spmT_0010.nii \
sub-TAG159 $fxdir/sub-TAG159/con_0010.nii    $fxdir/sub-TAG159/spmT_0010.nii \
sub-TAG160 $fxdir/sub-TAG160/con_0010.nii    $fxdir/sub-TAG160/spmT_0010.nii \
sub-TAG164 $fxdir/sub-TAG164/con_0010.nii    $fxdir/sub-TAG164/spmT_0010.nii \
sub-TAG166 $fxdir/sub-TAG166/con_0010.nii    $fxdir/sub-TAG166/spmT_0010.nii \
sub-TAG167 $fxdir/sub-TAG167/con_0010.nii    $fxdir/sub-TAG167/spmT_0010.nii \
sub-TAG169 $fxdir/sub-TAG169/con_0010.nii    $fxdir/sub-TAG169/spmT_0010.nii \
sub-TAG175 $fxdir/sub-TAG175/con_0010.nii    $fxdir/sub-TAG175/spmT_0010.nii \
sub-TAG179 $fxdir/sub-TAG179/con_0010.nii    $fxdir/sub-TAG179/spmT_0010.nii \
sub-TAG180 $fxdir/sub-TAG180/con_0010.nii    $fxdir/sub-TAG180/spmT_0010.nii \
sub-TAG181 $fxdir/sub-TAG181/con_0010.nii    $fxdir/sub-TAG181/spmT_0010.nii \
sub-TAG186 $fxdir/sub-TAG186/con_0010.nii    $fxdir/sub-TAG186/spmT_0010.nii \
sub-TAG200 $fxdir/sub-TAG200/con_0010.nii    $fxdir/sub-TAG200/spmT_0010.nii \
sub-TAG202 $fxdir/sub-TAG202/con_0010.nii    $fxdir/sub-TAG202/spmT_0010.nii \
sub-TAG203 $fxdir/sub-TAG203/con_0010.nii    $fxdir/sub-TAG203/spmT_0010.nii \
sub-TAG206 $fxdir/sub-TAG206/con_0010.nii    $fxdir/sub-TAG206/spmT_0010.nii \
sub-TAG207 $fxdir/sub-TAG207/con_0010.nii    $fxdir/sub-TAG207/spmT_0010.nii \
sub-TAG208 $fxdir/sub-TAG208/con_0010.nii    $fxdir/sub-TAG208/spmT_0010.nii \
sub-TAG209 $fxdir/sub-TAG209/con_0010.nii    $fxdir/sub-TAG209/spmT_0010.nii \
sub-TAG210 $fxdir/sub-TAG210/con_0010.nii    $fxdir/sub-TAG210/spmT_0010.nii \
sub-TAG211 $fxdir/sub-TAG211/con_0010.nii    $fxdir/sub-TAG211/spmT_0010.nii \
sub-TAG215 $fxdir/sub-TAG215/con_0010.nii    $fxdir/sub-TAG215/spmT_0010.nii \
sub-TAG220 $fxdir/sub-TAG220/con_0010.nii    $fxdir/sub-TAG220/spmT_0010.nii \
sub-TAG221 $fxdir/sub-TAG221/con_0010.nii    $fxdir/sub-TAG221/spmT_0010.nii \
sub-TAG223 $fxdir/sub-TAG223/con_0010.nii    $fxdir/sub-TAG223/spmT_0010.nii \
sub-TAG224 $fxdir/sub-TAG224/con_0010.nii    $fxdir/sub-TAG224/spmT_0010.nii \
sub-TAG225 $fxdir/sub-TAG225/con_0010.nii    $fxdir/sub-TAG225/spmT_0010.nii \
sub-TAG232 $fxdir/sub-TAG232/con_0010.nii    $fxdir/sub-TAG232/spmT_0010.nii \
sub-TAG238 $fxdir/sub-TAG238/con_0010.nii    $fxdir/sub-TAG238/spmT_0010.nii \
sub-TAG240 $fxdir/sub-TAG240/con_0010.nii    $fxdir/sub-TAG240/spmT_0010.nii \
sub-TAG243 $fxdir/sub-TAG243/con_0010.nii    $fxdir/sub-TAG243/spmT_0010.nii \
sub-TAG250 $fxdir/sub-TAG250/con_0010.nii    $fxdir/sub-TAG250/spmT_0010.nii \
sub-TAG253 $fxdir/sub-TAG253/con_0010.nii    $fxdir/sub-TAG253/spmT_0010.nii \
sub-TAG266 $fxdir/sub-TAG266/con_0010.nii    $fxdir/sub-TAG266/spmT_0010.nii \

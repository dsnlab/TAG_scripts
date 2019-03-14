% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
% spm_get_defaults('cmdline',true);

clear matlabbatch;
%--------------------------------------------------------------------------

matlabbatch{1}.spm.stats.factorial_design.dir = {'/projects/dsnlab/shared/tag/nonbids_data/fMRI/rx/svc_clinical_groups/anxiety_matched'};
%%
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = {'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG007/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG008/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG014/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG027/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG032/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG033/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG034/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG035/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG053/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG058/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG068/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG085/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG090/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG091/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG107/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG110/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG114/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG131/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG169/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG174/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG181/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG048/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG049/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG141/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG138/con_0012.nii,1'
                                                           };
%%
%%
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = {'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG144/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG173/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG026/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG180/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG019/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG103/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG208/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG041/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG140/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG084/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG211/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG057/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG190/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG088/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG067/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG106/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG051/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG101/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG001/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG075/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG186/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG160/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG040/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG173/con_0012.nii,1'
'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG105/con_0012.nii,1'                                                       
                                                           };
%%
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
%%

matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = 0;
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Clin>Contr';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Contr>Clin';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

spm_jobman('run',matlabbatch);
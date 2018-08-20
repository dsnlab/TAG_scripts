%-----------------------------------------------------------------------
% Job saved on 19-Aug-2018 23:52:36 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_est.spmmat = {'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc_flux_auto-motion/sub-TAG001/FD/SPM.mat'};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 1;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{2}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.con.consess{1}.tcon.name = 'SelfProPop';
matlabbatch{2}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0 0 0];
matlabbatch{2}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{2}.tcon.name = 'SelfUnpop';
matlabbatch{2}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0 0 0];
matlabbatch{2}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{3}.tcon.name = 'SelfAntiPop';
matlabbatch{2}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 0 0 0];
matlabbatch{2}.spm.stats.con.consess{3}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{4}.tcon.name = 'ChangeProPop';
matlabbatch{2}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 1 0 0];
matlabbatch{2}.spm.stats.con.consess{4}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{5}.tcon.name = 'ChangeUnpop';
matlabbatch{2}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 1 0];
matlabbatch{2}.spm.stats.con.consess{5}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{6}.tcon.name = 'ChangeAntiPop';
matlabbatch{2}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 0 1];
matlabbatch{2}.spm.stats.con.consess{6}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{7}.tcon.name = 'SelfChange';
matlabbatch{2}.spm.stats.con.consess{7}.tcon.weights = [0.33 0.33 0.33 -0.33 -0.33 -0.33];
matlabbatch{2}.spm.stats.con.consess{7}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.delete = 0;

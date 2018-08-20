%-----------------------------------------------------------------------
% Job saved on 01-Jul-2018 22:03:53 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 1;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
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
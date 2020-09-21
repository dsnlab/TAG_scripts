%-----------------------------------------------------------------------
% Job saved on 03-Nov-2018 18:50:14 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_est.spmmat = {'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1and2/block/sub-TAG001/wave1/SPM.mat'};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 1;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{2}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.con.consess{1}.tcon.name = 'Self > Rest';
matlabbatch{2}.spm.stats.con.consess{1}.tcon.weights = [1 0 0];
matlabbatch{2}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{2}.tcon.name = 'Change > Rest';
matlabbatch{2}.spm.stats.con.consess{2}.tcon.weights = [0 1 0];
matlabbatch{2}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{3}.tcon.name = 'Instructions > Rest';
matlabbatch{2}.spm.stats.con.consess{3}.tcon.weights = [0 0 1];
matlabbatch{2}.spm.stats.con.consess{3}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{4}.tcon.name = 'Self > Instructions';
matlabbatch{2}.spm.stats.con.consess{4}.tcon.weights = [1 0 -1];
matlabbatch{2}.spm.stats.con.consess{4}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{5}.tcon.name = 'Change > Instructions';
matlabbatch{2}.spm.stats.con.consess{5}.tcon.weights = [0 1 -1];
matlabbatch{2}.spm.stats.con.consess{5}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{6}.tcon.name = 'Self > Change';
matlabbatch{2}.spm.stats.con.consess{6}.tcon.weights = [1 -1 0];
matlabbatch{2}.spm.stats.con.consess{6}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.delete = 0;

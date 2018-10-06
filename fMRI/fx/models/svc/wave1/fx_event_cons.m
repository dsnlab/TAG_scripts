%-----------------------------------------------------------------------
% Job saved on 19-Aug-2018 23:52:55 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_est.spmmat = {'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/svc/wave1/event/sub-TAG001/SPM.mat'};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{2}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.con.consess{1}.tcon.name = 'Self Prosocial';
matlabbatch{2}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0 0 0];
matlabbatch{2}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{2}.tcon.name = 'Self Withdrawn';
matlabbatch{2}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0 0 0];
matlabbatch{2}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{3}.tcon.name = 'Self Antisocial';
matlabbatch{2}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 0 0 0];
matlabbatch{2}.spm.stats.con.consess{3}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{4}.tcon.name = 'Change Prosocial';
matlabbatch{2}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 1 0 0];
matlabbatch{2}.spm.stats.con.consess{4}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{5}.tcon.name = 'Change Withdrawn';
matlabbatch{2}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 1 0];
matlabbatch{2}.spm.stats.con.consess{5}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{6}.tcon.name = 'Change Antisocial';
matlabbatch{2}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 0 1];
matlabbatch{2}.spm.stats.con.consess{6}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{7}.tcon.name = 'Self > Change';
matlabbatch{2}.spm.stats.con.consess{7}.tcon.weights = [0.33 0.33 0.33 -0.33 -0.33 -0.33];
matlabbatch{2}.spm.stats.con.consess{7}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{8}.tcon.name = 'Self Prosocial > Change Prosocial';
matlabbatch{2}.spm.stats.con.consess{8}.tcon.weights = [1 0 0 -1 0 0];
matlabbatch{2}.spm.stats.con.consess{8}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{9}.tcon.name = 'Self Withdrawn > Change Withdrawn';
matlabbatch{2}.spm.stats.con.consess{9}.tcon.weights = [0 1 0 0 -1 0];
matlabbatch{2}.spm.stats.con.consess{9}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{10}.tcon.name = 'Self Antisocial > Change Antisocial';
matlabbatch{2}.spm.stats.con.consess{10}.tcon.weights = [0 0 1 0 0 -1];
matlabbatch{2}.spm.stats.con.consess{10}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{11}.tcon.name = 'Self Prosocial > Self Withdrawn + Antisocial';
matlabbatch{2}.spm.stats.con.consess{11}.tcon.weights = [1 -.5 -.5 0 0 0];
matlabbatch{2}.spm.stats.con.consess{11}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{12}.tcon.name = 'Self Withdrawn > Self Prosocial + Antisocial';
matlabbatch{2}.spm.stats.con.consess{12}.tcon.weights = [-.5 1 -.5 0 0 0];
matlabbatch{2}.spm.stats.con.consess{12}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{13}.tcon.name = 'Self Antisocial > Self Prosocial + Withdrawn';
matlabbatch{2}.spm.stats.con.consess{13}.tcon.weights = [-.5 -.5 1 0 0 0];
matlabbatch{2}.spm.stats.con.consess{13}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{14}.tcon.name = 'Change Prosocial > Change Withdrawn + Antisocial';
matlabbatch{2}.spm.stats.con.consess{14}.tcon.weights = [0 0 0 1 -.5 -.5 ];
matlabbatch{2}.spm.stats.con.consess{14}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{15}.tcon.name = 'Change Withdrawn > Change Prosocial + Antisocial';
matlabbatch{2}.spm.stats.con.consess{15}.tcon.weights = [0 0 0 -.5 1 -.5];
matlabbatch{2}.spm.stats.con.consess{15}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.consess{16}.tcon.name = 'Change Antisocial > Change Prosocial + Withdrawn';
matlabbatch{2}.spm.stats.con.consess{16}.tcon.weights = [0 0 0 -.5 -.5 1];
matlabbatch{2}.spm.stats.con.consess{16}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.delete = 0;

%-----------------------------------------------------------------------
% Job saved on 15-Jun-2018 22:11:36 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/psych-cog/dsnlab/TAG/bids_data/derivatives/fmriprep/sub-TAG001/ses-wave1/func'};
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'task-DSD_run-01_bold_space-MNI152NLin2009cAsym_preproc';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/psych-cog/dsnlab/TAG/bids_data/derivatives/fmriprep/sub-TAG001/ses-wave1/func'};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'task-DSD_run-02_bold_space-MNI152NLin2009cAsym_preproc';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{3}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fmri/fx/models/dsd/wave1/fd0.8_dv2.0_Neighbors'};
matlabbatch{3}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'sub-TAG001';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (task-DSD_run-01_bold_space-MNI152NLin2009cAsym_preproc)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_move.action.copyto(1) = cfg_dep('File Selector (Batch Mode): Subdirectories', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (task-DSD_run-02_bold_space-MNI152NLin2009cAsym_preproc)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.action.copyto(1) = cfg_dep('File Selector (Batch Mode): Subdirectories', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs'));
matlabbatch{6}.spm.util.exp_frames.files(1) = cfg_dep('Move/Delete Files: Moved/Copied Files', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{6}.spm.util.exp_frames.frames = Inf;
matlabbatch{7}.spm.util.exp_frames.files(1) = cfg_dep('Move/Delete Files: Moved/Copied Files', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{7}.spm.util.exp_frames.frames = Inf;
matlabbatch{8}.spm.spatial.smooth.data(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{8}.spm.spatial.smooth.dtype = 0;
matlabbatch{8}.spm.spatial.smooth.im = 0;
matlabbatch{8}.spm.spatial.smooth.prefix = 's';
matlabbatch{9}.spm.spatial.smooth.data(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{9}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{9}.spm.spatial.smooth.dtype = 0;
matlabbatch{9}.spm.spatial.smooth.im = 0;
matlabbatch{9}.spm.spatial.smooth.prefix = 's';
matlabbatch{10}.spm.stats.fmri_spec.dir = '<UNDEFINED>';
matlabbatch{10}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{10}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{10}.spm.stats.fmri_spec.timing.fmri_t = 72;
matlabbatch{10}.spm.stats.fmri_spec.timing.fmri_t0 = 36;
matlabbatch{10}.spm.stats.fmri_spec.sess(1).scans(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{10}.spm.stats.fmri_spec.sess(1).multi = {'/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fMRI/fx/multiconds/dsd/wave1/NOD/001_DSD1_NOD.mat'};
matlabbatch{10}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{10}.spm.stats.fmri_spec.sess(1).multi_reg = {'/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fMRI/fx/motion/wave1/auto-motion-fmriprep/rp_txt/fd0.8_dv2.0_Neighbors/rp_001_DSD1.txt'};
matlabbatch{10}.spm.stats.fmri_spec.sess(1).hpf = 128;
matlabbatch{10}.spm.stats.fmri_spec.sess(2).scans(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{10}.spm.stats.fmri_spec.sess(2).multi = {'/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fMRI/fx/multiconds/dsd/wave1/NOD/001_DSD2_NOD.mat'};
matlabbatch{10}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{10}.spm.stats.fmri_spec.sess(2).multi_reg = {'/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fMRI/fx/motion/wave1/auto-motion-fmriprep/rp_txt/fd0.8_dv2.0_Neighbors/rp_001_DSD2.txt'};
matlabbatch{10}.spm.stats.fmri_spec.sess(2).hpf = 128;
matlabbatch{10}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{10}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{10}.spm.stats.fmri_spec.volt = 1;
matlabbatch{10}.spm.stats.fmri_spec.global = 'None';
matlabbatch{10}.spm.stats.fmri_spec.mthresh = -Inf;
matlabbatch{10}.spm.stats.fmri_spec.mask = {'/projects/dsnlab/shared/tds/fMRI/analysis/masks/tds1_tds2/tds1_tds2_gw_smoothed_group_average_optthr.nii,1'};
matlabbatch{10}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{11}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{11}.spm.stats.fmri_est.write_residuals = 1;
matlabbatch{11}.spm.stats.fmri_est.method.Classical = 1;

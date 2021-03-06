%-----------------------------------------------------------------------
% Job saved on 31-May-2021 22:55:15 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.exp_frames.files = {'/projects/dsnlab/shared/tag/fmriprep_20.2.1/fmriprep/sub-TAG001w03/ses-wave3/func/s2_sub-TAG001w03_ses-wave3_task-DSD_run-1_space-MNI152NLin2009cAsym_desc-preproc_bold.nii,1'};
matlabbatch{1}.spm.util.exp_frames.frames = Inf;
matlabbatch{2}.spm.util.exp_frames.files = {'/projects/dsnlab/shared/tag/fmriprep_20.2.1/fmriprep/sub-TAG001w03/ses-wave3/func/s2_sub-TAG001w03_ses-wave3_task-DSD_run-2_space-MNI152NLin2009cAsym_desc-preproc_bold.nii,1'};
matlabbatch{2}.spm.util.exp_frames.frames = Inf;
matlabbatch{3}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files = {'/projects/dsnlab/shared/tag/fmriprep_20.2.1/fmriprep/sub-TAG001w03/ses-wave3/func/sub-TAG001w03_ses-wave3_task-DSD_run-1_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz'};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
matlabbatch{4}.spm.stats.fmri_spec.dir = {'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/models/dsd/waves123/betaseries/sub-TAG001w03'};
matlabbatch{4}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{4}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{4}.spm.stats.fmri_spec.timing.fmri_t = 72;
matlabbatch{4}.spm.stats.fmri_spec.timing.fmri_t0 = 36;
matlabbatch{4}.spm.stats.fmri_spec.sess(1).scans(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{4}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{4}.spm.stats.fmri_spec.sess(1).multi = {'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/multiconds/dsd/waves123/betaseries_full_trial/TAG001w03_DSD1_full_trial_NOD.mat'};
matlabbatch{4}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{4}.spm.stats.fmri_spec.sess(1).multi_reg = {'/projects/dsnlab/shared/tag/fmriprep_20.2.1/auto-motion-fmriprep/rp_txt/rp_sub-TAG001w03_DSD1.txt'};
matlabbatch{4}.spm.stats.fmri_spec.sess(1).hpf = 100;
matlabbatch{4}.spm.stats.fmri_spec.sess(2).scans(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{4}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{4}.spm.stats.fmri_spec.sess(2).multi = {'/projects/dsnlab/shared/tag/nonbids_data/fMRI/fx/multiconds/dsd/waves123/betaseries_full_trial/TAG001w03_DSD2_full_trial_NOD.mat'};
matlabbatch{4}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{4}.spm.stats.fmri_spec.sess(2).multi_reg = {'/projects/dsnlab/shared/tag/fmriprep_20.2.1/auto-motion-fmriprep/rp_txt/rp_sub-TAG001w03_DSD2.txt'};
matlabbatch{4}.spm.stats.fmri_spec.sess(2).hpf = 100;
matlabbatch{4}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{4}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{4}.spm.stats.fmri_spec.volt = 1;
matlabbatch{4}.spm.stats.fmri_spec.global = 'None';
matlabbatch{4}.spm.stats.fmri_spec.mthresh = -Inf;
matlabbatch{4}.spm.stats.fmri_spec.mask(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
matlabbatch{4}.spm.stats.fmri_spec.cvi = 'FAST';
matlabbatch{5}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{5}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{5}.spm.stats.fmri_est.method.Classical = 1;

%-----------------------------------------------------------------------
% Job saved on 31-May-2021 13:24:21 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/dsnlab/shared/tag/fmriprep_20.2.1/fmriprep/sub-TAG001w03/ses-wave3/func/'};
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^sub-TAG001w03_ses-wave3_task-DSD_run-2_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^sub-TAG001w03_ses-wave3_task-DSD_run-2_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {'/projects/dsnlab/shared/tag/fmriprep_20.2.1/fmriprep/sub-TAG001w03/ses-wave3/func'};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
matlabbatch{3}.spm.util.exp_frames.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
matlabbatch{3}.spm.util.exp_frames.frames = Inf;
matlabbatch{4}.spm.spatial.smooth.data(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{4}.spm.spatial.smooth.fwhm = [2 2 2];
matlabbatch{4}.spm.spatial.smooth.dtype = 0;
matlabbatch{4}.spm.spatial.smooth.im = 0;
matlabbatch{4}.spm.spatial.smooth.prefix = 's2_';
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.action.delete = false;

% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/projects/dsnlab/shared/tag/TAG_scripts/fMRI/ppc/smooth/smooth_DSD_fmriprep_20.2.1_s2_wave2_run2_only_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});

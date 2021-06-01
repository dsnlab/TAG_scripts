% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/gpfs/projects/dsnlab/shared/tag/TAG_scripts/fMRI/betaseries/dsd/waves123/fx_betaseries_wave1_both_runs_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});

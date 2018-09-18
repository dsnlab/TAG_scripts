% script to create fx results pdf jobs
% 10.06.2017

% define paths
jobDir = '/projects/dsnlab/tag/TAG_scripts/fMRI/fx/models/dsd/wave1/results_pdfs/';

addpath(jobDir)

% loop through subjects and replace subject ID, wave, reo parameters
for subCount = 1:300;
    
	if subCount < 10
		subID = ['sub-TAG00',num2str(subCount)];
    else if subCount < 100
		subID = ['sub-TAG0',num2str(subCount)];
    else
        subID = ['sub-TAG',num2str(subCount)];
    end
    end
    
        
    fn1 = ['/Volumes/psych-cog/dsnlab/tag/nonbids_data/fMRI/fx/models/dsd/wave1/MLmotion/pmod/',subID,'/SPM.mat'];
    if exist(fn1, 'file')
        matlabbatch{1}.spm.stats.results.spmmat = {['/Volumes/psych-cog/dsnlab/tag/nonbids_data/fMRI/fx/models/dsd/wave1/MLmotion/pmod/',subID,'/SPM.mat']};
        matlabbatch{1}.spm.stats.results.conspec.titlestr = 'statement';
        matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
        matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
        matlabbatch{1}.spm.stats.results.conspec.thresh = 0.005;
        matlabbatch{1}.spm.stats.results.conspec.extent = 20;
        matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
        matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
        matlabbatch{1}.spm.stats.results.units = 1;
        matlabbatch{1}.spm.stats.results.print = 'pdf';
        matlabbatch{1}.spm.stats.results.write.none = 1;
        
        saveJob = [jobDir,[subID,'_pmod_pdf.mat']];
		save(saveJob,'matlabbatch');
		clear matlabbatch; 
    end
    
    fn1 = ['/Volumes/psych-cog/dsnlab/tag/nonbids_data/fMRI/fx/models/dsd/wave1/MLmotion/2x2/',subID,'/SPM.mat'];
    if exist(fn1, 'file')
        matlabbatch{1}.spm.stats.results.spmmat = {['/Volumes/psych-cog/dsnlab/tag/nonbids_data/fMRI/fx/models/dsd/wave1/MLmotion/2x2/',subID,'/SPM.mat']};
        matlabbatch{1}.spm.stats.results.conspec.titlestr = 'statement';
        matlabbatch{1}.spm.stats.results.conspec.contrasts = [1 1];
        matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
        matlabbatch{1}.spm.stats.results.conspec.thresh = 0.005;
        matlabbatch{1}.spm.stats.results.conspec.extent = 20;
        matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
        matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
        matlabbatch{1}.spm.stats.results.units = 1;
        matlabbatch{1}.spm.stats.results.print = 'pdf';
        matlabbatch{1}.spm.stats.results.write.none = 1;
        
        saveJob = [jobDir,[subID,'_2x2_pdf.mat']];
		save(saveJob,'matlabbatch');
		clear matlabbatch; 
    end

end

% This script pulls onsets and durations from the subject output files for
% SVC to create FX multicond files
%
% D.Cos 8/2018

%% Load data and intialize variables
inputDir = '/Volumes/psych-cog/dsnlab/TAG/behavior/task/output';
runName = {'run1', 'run2'}; % add runs names here
writeDir = '/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fMRI/fx/multiconds/svc/wave1/flux_auto-motion';

% list files in input directory
files = dir(sprintf('%s/tag*_svc*.mat',inputDir));
filesCell = struct2cell(files);

% extract subject IDs
subjectID = unique(extractBetween(filesCell(1,:), 1,6));

% exclude test responses
subjectID = subjectID(~cellfun(@isempty,regexp(subjectID, 'tag[0-2]{1}[0-9]{2}')));

%% Loop through subjects and runs and save names, onsets, and durations as .mat files
for i = 1:numel(subjectID)
    for a = 1:numel(runName)
        %% Load text file
        sub = subjectID{i};
        run = runName{a};
        subFile = fullfile(inputDir, sprintf('%s_wave_1_svc_%s.mat', sub, run));
        if exist(subFile)
            load(subFile);

            %% Initialize names
            names = {'selfProPop', 'selfUnpop', 'selfAntiPop', 'changeProPop', 'changeUnpop', 'changeAntiPop'}; % condition names

            %% Pull onsets for subject and run  
            for b = 1:length(names)
                idxs = find(task.output.raw(:,2) == b);
                onsets(b)={task.output.raw(idxs,3)};
            end

            %% Create durations vector for subject and run
            for c = 1:length(names)
                idxs = find(task.output.raw(:,2) == c);
                durations(c)={task.output.raw(idxs,4)};
                durations{c}(isnan(durations{c})) = 4.7; % replacing non-responses with presentation length for flux; model separately in future analyses
            end

            %% Define output file name
            outputName = sprintf('%s_wave1_%s.mat', sub, run);

            %% Save as .mat file and clear
            if ~exist(writeDir); mkdir(writeDir); end

            save(fullfile(writeDir,outputName),'names','onsets','durations');

            clear names onsets durations b c ;
        else
            warning(sprintf('Unable to load %s', subFile));
        end
    end
end
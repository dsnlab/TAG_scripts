% This script pulls onsets and durations from the subject output files for
% SVC to create FX multicond files for the betaseries analysis
% adapted from Dani's script from FP
% Marjolein, April 2019

%% Load data and intialize variables
inputDir = 'Y:/dsnlab/TAG/behavior/task/output';
runName = {'run1', 'run2'}; % add runs names here
writeDir = 'Y:/dsnlab/TAG/nonbids_data/fMRI/fx/multiconds/svc/wave2/betaseries';

% list files in input directory
files = dir(sprintf('%s/tag*wave_2*svc*.mat',inputDir));
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
        subFile = fullfile(inputDir, sprintf('%s_wave_2_svc_%s.mat', sub, run));
        if exist(subFile)
            load(subFile);

            %% Initialize names
            for b = 1:length(task.output.raw)
                names{b} = strcat('trial',num2str(b));
            end
            
            %% Pull onsets for experimental conditions
            for b = 1:length(task.output.raw)
                onsets{b} = task.output.raw(b,3);
            end
            
            %% Create durations vector for experimental conditions
            for b = 1:length(task.output.raw)
                durations{b} = task.output.raw(b,4);
            end

            %% Pull names, onsets and durations for instructions
            % Every fifth trial - 4.7s
            names{length(task.output.raw)+1} = 'instructions';
            onsets{length(task.output.raw)+1} = (task.output.raw(1:5:50,3)-4.7);
            durations{length(task.output.raw)+1} = (repelem(4.7, length(1:5:50))');
            
            %% Define output file name
            outputName = sprintf('TAG%s_wave2_SVC%s.mat', sub(4:6), run(4));

            %% Save as .mat file and clear
            if ~exist(writeDir); mkdir(writeDir); end

            save(fullfile(writeDir,outputName),'names','onsets','durations');

            clear names onsets durations b c idxs colNum;
        else
            warning(sprintf('Unable to load %s', subFile));
        end
    end
end

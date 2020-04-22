
% This script pulls onsets and durations from the subject output files for
% SVC to create FX multicond files by valence
%
% Marjolein 6/2019

%% Load data and intialize variables
inputDir = 'Y:/dsnlab/TAG/behavior/task/output';
runName = {'run1', 'run2'}; % add runs names here
writeDir = 'Y:/dsnlab/TAG/nonbids_data/fMRI/fx/multiconds/svc/wave1/valence';

% list files in input directory
files = dir(sprintf('%s/tag*_wave_1*_svc*.mat',inputDir));
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
            names = {'selfPositive', 'selfNegative', 'changePositive', 'changeNegative', 'instructions'}; % condition names

            %% Pull onsets and durations for experimental conditions
            % Excludes trials where no response is given
            for b = 1
			    idxs = find(task.output.raw(:,2) == 1 & ~isnan(task.output.raw(:,4)) | task.output.raw(:,2) == 2 & task.output.raw(:,6) == 0 & ~isnan(task.output.raw(:,4)));
                onsets(b)={task.output.raw(idxs,3)};
                durations(b)={task.output.raw(idxs,4)};
            end
            for b = 2
			    idxs = find(task.output.raw(:,2) == 3 & ~isnan(task.output.raw(:,4)) | task.output.raw(:,2) == 2 & task.output.raw(:,6) == 1 & ~isnan(task.output.raw(:,4)));
                onsets(b)={task.output.raw(idxs,3)};
                durations(b)={task.output.raw(idxs,4)};
            end
            for b = 3
			    idxs = find(task.output.raw(:,2) == 4 & ~isnan(task.output.raw(:,4)) | task.output.raw(:,2) == 5 & task.output.raw(:,6) == 0 & ~isnan(task.output.raw(:,4)));
                onsets(b)={task.output.raw(idxs,3)};
                durations(b)={task.output.raw(idxs,4)};
            end
            for b = 4
			    idxs = find(task.output.raw(:,2) == 6 & ~isnan(task.output.raw(:,4)) | task.output.raw(:,2) == 5 & task.output.raw(:,6) == 1 & ~isnan(task.output.raw(:,4)));
                onsets(b)={task.output.raw(idxs,3)};
                durations(b)={task.output.raw(idxs,4)};
            end
           
            %% Pull onsets and durations for instructions
            % Every fifth trial - 4.7s
            onsets(5)={task.output.raw(1:5:50,3)-4.7};
            durations(5) = {repelem(4.7, length(1:5:50))};
            
            %% Pull onsets and durations for missed responses (if any)
            colNum = length(names) + 1;

            if(sum(isnan(task.output.raw(:,4))) > 0)
                names{colNum} = 'noResponse';
                idxs = find(isnan(task.output.raw(:,4)));
                onsets(colNum) = {task.output.raw(idxs,3)};
                durations(colNum) = {repelem(4.7, length(idxs))};
            end 
            
            %% Define output file name
            outputName = sprintf('TAG%s_wave1_SVC%s.mat', sub(4:6), run(4));

            %% Save as .mat file and clear
            if ~exist(writeDir); mkdir(writeDir); end

            save(fullfile(writeDir,outputName),'names','onsets','durations');

            clear names onsets durations b c idxs colNum;
        else
            warning(sprintf('Unable to load %s', subFile));
        end
    end
end
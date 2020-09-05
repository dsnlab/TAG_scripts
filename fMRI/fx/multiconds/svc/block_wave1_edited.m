% This script pulls onsets and durations from the subject output files for
% SVC to create FX multicond files
%
% Marjolein 6/2020

%% Load data and intialize variables
inputDir = 'Y:/dsnlab/TAG/behavior/task/output/edited';
runName = {'run1', 'run2'}; % add runs names here
writeDir = 'Y:/dsnlab/TAG/nonbids_data/fMRI/fx/multiconds/svc/wave1/block';

% list files in input directory
files = dir(sprintf('%s/tag*_svc*.mat',inputDir));
filesCell = struct2cell(files);

% extract subject IDs
subjectID = unique(extractBetween(filesCell(1,:), 1,6));

% exclude test responses
subjectID = subjectID(~cellfun(@isempty,regexp(subjectID, 'tag[0-2]{1}[0-9]{2}')));

% specify waves
waves = {'1'};


%% Loop through subjects and runs and save names, onsets, and durations as .mat files
for i = 1:numel(subjectID)
    
    for wave = 1:numel(waves)
        waveNum = waves{wave};
        
        for a = 1:numel(runName)
            %% Load text file
            sub = subjectID{i};
            run = runName{a};
            subFile = fullfile(inputDir, sprintf('%s_wave_%s_svc_%s.mat', sub, waveNum, run));
            if exist(subFile)
                load(subFile);

            %REMOVE EXISTING MULTICOND FILE
                incor_multicond = fullfile(writeDir, sprintf('TAG%s_wave%s_SVC%s_block.mat', sub(4:6), waveNum, run(4))) ;
                delete(incor_multicond) ;
                
                %% Initialize names
                names = {'self', 'change', 'instructions'}; % condition names

                %% Pull onsets for experimental conditions
                onsets(1)={task.output.raw([1,11,21,31,41],3)};
                onsets(2)={task.output.raw([6,16,26,36,46],3)};
                onsets(3)={task.output.raw(sort([1,11,21,31,41,6,16,26,36,46]),3)-4.7};
                %% Create durations vector for experimental conditions
                for c = 1:length(names)
                    idxs = find(task.output.raw(:,2) == c & ~isnan(task.output.raw(:,4)));
                    durations(c)={task.output.raw(idxs,4)};
                end

                durations(1)={task.output.raw([5,15,25,35,45],3) + 4.7 - task.output.raw([1,11,21,31,41],3)};
                durations(2)={task.output.raw([10,20,30,40,50],3) + 4.7 - task.output.raw([6,16,26,36,46],3)};
                durations(3)={repelem(4.7,10)'};

                %% Define output file name
                outputName = sprintf('TAG%s_wave%s_SVC%s_block.mat', sub(4:6), waveNum, run(4));

                %% Save as .mat file and clear
                if ~exist(writeDir); mkdir(writeDir); end

                save(fullfile(writeDir,outputName),'names','onsets','durations');

                clear names onsets durations b c idxs colNum;
            else
                warning(sprintf('Unable to load %s', subFile));
            end
        end
    end
end
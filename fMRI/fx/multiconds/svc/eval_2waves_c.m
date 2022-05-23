% This script pulls onsets and durations from the subject output files for
% SVC to create FX multicond files
% It separates trials into positive evaluation (yes to pos trait and no to
% neg trait) and negative evaluation (no to pos trait and yes to neg trait)
%
% MEAB 7/2020


%% Load data and intialize variables
inputDir = 'Y:/dsnlab/TAG/behavior/task/output';
runName = {'run1', 'run2'}; % add runs names here
w = 2; %indicates the wave
writeDir = sprintf('Y:/dsnlab/TAG/nonbids_data/fMRI/fx/multiconds/svc/wave%d/eval', w);

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
			subFile = fullfile(inputDir, sprintf('%s_wave_%d_svc_%s.mat', sub, w, run));
			orun = runName{strcmp(run, runName) == 0};
			orunFile = fullfile(inputDir, sprintf('%s_wave_%d_svc_%s.mat', sub, w, orun));
			if exist(subFile)&& exist(orunFile)
				load(subFile);
				otherrun = load(orunFile);
				
				%% Initialize names
				names = {'selfPosEval', 'selfNegEval', 'changePosEval', 'changeNegEval', 'instructions'}; % condition names
				
				%% create a new column with the new categories
				%%PosEval is yes to positive trait and no to negative trait
				%%NegEval is yes to negative trait and no to positive trait
				%%change trials are put in the pos or neg category depending on the SELF response (thus malleability response is ignored)
				for r = 1:length(task.output.raw)
					if task.output.raw(r,2) == 1 & task.output.raw(r,5) == 1
					task.output.raw(r,14) = 1;
					elseif task.output.raw(r,2) == 1 & task.output.raw(r,5) == 2
					task.output.raw(r,14) = 2;
					elseif task.output.raw(r,2) == 3 & task.output.raw(r,5) == 1
					task.output.raw(r,14) = 2;
					elseif task.output.raw(r,2) == 3 & task.output.raw(r,5) == 2
					task.output.raw(r,14) = 1;
					elseif task.output.raw(r,2) == 2 & task.output.raw(r,6) == 0 & task.output.raw(r,5) == 1
					task.output.raw(r,14) = 1;
					elseif task.output.raw(r,2) == 2 & task.output.raw(r,6) == 1 & task.output.raw(r,5) == 1
					task.output.raw(r,14) = 2;
					elseif task.output.raw(r,2) == 2 & task.output.raw(r,6) == 0 & task.output.raw(r,5) == 2
					task.output.raw(r,14) = 2;
					elseif task.output.raw(r,2) == 2 & task.output.raw(r,6) == 1 & task.output.raw(r,5) == 2
					task.output.raw(r,14) = 1;
					elseif task.output.raw(r,2) == 4 
					wordmatch = find(strcmp(otherrun.task.input.trait(:,1), task.input.trait(r,1)));
						if otherrun.task.output.raw(wordmatch,5) == 1
						task.output.raw(r,14) = 3;
                        elseif otherrun.task.output.raw(wordmatch,5) == 2
						task.output.raw(r,14) = 4;
                        else 
                        task.output.raw(r,14) = 0;
						end
					elseif task.output.raw(r,2) == 6 
					wordmatch = find(strcmp(otherrun.task.input.trait(:,1), task.input.trait(r,1)));
						if otherrun.task.output.raw(wordmatch,5) == 1
						task.output.raw(r,14) = 4;
						elseif otherrun.task.output.raw(wordmatch,5) == 2
						task.output.raw(r,14) = 3;
                        else 
                        task.output.raw(r,14) = 0;
						end
					elseif task.output.raw(r,2) == 5 
					wordmatch = find(strcmp(otherrun.task.input.trait(:,1), task.input.trait(r,1)));
						if otherrun.task.output.raw(wordmatch,6) == 0 & otherrun.task.output.raw(wordmatch,5) == 1
						task.output.raw(r,14) = 3;
						elseif otherrun.task.output.raw(wordmatch,6) == 1 & otherrun.task.output.raw(wordmatch,5) == 2
						task.output.raw(r,14) = 3;
                        elseif otherrun.task.output.raw(wordmatch,5) == 0
                        task.output.raw(r,14) = 0;
                        else
						task.output.raw(r,14) = 4;
						end
					else
					task.output.raw(r,14) = 0;
					end
				end	

				%% Pull onsets for experimental conditions
				% Exclude trials where no response is given
				for b = 1:length(names)
					idxs = find(task.output.raw(:,14) == b );
					onsets(b)={task.output.raw(idxs,3)};
				end
            
				%% Create durations vector for experimental conditions
				for c = 1:length(names)
					idxs = find(task.output.raw(:,14) == c );
					durations(c)={task.output.raw(idxs,4)};
				end

				%% Pull onsets and durations for instructions
				% Every fifth trial - 4.7s
				onsets(5)={task.output.raw(1:5:50,3)-4.7};
				durations(5) = {repelem(4.7, length(1:5:50))};
            
				%% Pull onsets and durations for missed responses (if any)
				colNum = length(names) + 1;

				if(sum(task.output.raw(:,14)==0) > 0)
					names{colNum} = 'noResponse';
					idxs = find(task.output.raw(:,14)==0);
					onsets(colNum) = {task.output.raw(idxs,3)};
					durations(colNum) = {repelem(4.7, length(idxs))}; 
				end 
            
				%% Define output file name
				outputName = sprintf('TAG%s_wave%d_SVC%s.mat', sub(4:6), w, run(4));

				%% Save as .mat file and clear
				if ~exist(writeDir); mkdir(writeDir); end

				save(fullfile(writeDir,outputName),'names','onsets','durations');

				clear names onsets durations b c idxs colNum wordmatch;
			else
				warning(sprintf('Unable to load %s', subFile));
			end
		end
	end

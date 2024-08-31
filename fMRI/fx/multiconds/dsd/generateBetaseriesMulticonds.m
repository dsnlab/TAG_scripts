% Theresa Cheng, adapted from Nandita Vijayakumar
% May 2021

% generate_multiconds

% This script generates .mat files containing names,
% onsets, durations based on summary.csv files 

% Model: betaseries

%% SET VARIABLES & FOLDERS 

clear all

% which wave?
wave_num = '1';

% which cond? disclosure or eval
cond = 'disclosure';

f = filesep();

% setting directory and listing csv files in matlab directory
input_dir = ['/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fMRI/fx/multiconds/dsd/betaseries/' cond '_summary/wave' wave_num];
output_dir = ['/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fMRI/fx/multiconds/dsd/betaseries/' cond '_nod'];
d = dir(fullfile(input_dir,'*summary.csv'));

%% READ RAW DATA 

% for each subject and run
%for k=1:length(d)

k = 289;
cd (input_dir)

filename = d(k).name;
fid=fopen(filename, 'r');
% disc and eval: 
%M = textscan(fid,'%s%s%s%s%f%f%s%f%f%s%s%s%f%f\n','delimiter',',','Headerlines',1); 
%M = textscan(fid,'%s%s%s%s%f%f%s%f%f%s%s%f%f%s%f%f\n','delimiter',',','Headerlines',1); 
%M = textscan(fid,'%s%s%s%s%f%f%s%f%f%s%s%f%f%s%f%f','delimiter',',','Headerlines',1); 
% new test on 20240827 for 210w01 only
M = textscan(fid,'%s%s%s%s%f%f%f%f%f%f%s%s%f%f','delimiter',',','Headerlines',1);
fclose(fid);

% SET NAMES BASED ON CONDITIONS THAT ARE PRESENT - NOTE FROM 20240824 -- I
% need to edit the indexes for 210w01

% simplify the format of the names vector (12 for disc and eval, 14 for
% % full trial)
M{12} = strrep(M{12},'"',''); 
M{12} = strrep(M{12},'{','');
M{12} = strrep(M{12},'}','');
% 
% M{14} = strrep(M{14},'"',''); 
% M{14} = strrep(M{14},'{','');
% M{14} = strrep(M{14},'}','');

% PREPARE ONSETS & DURATIONS
% changing durations from double to cell format (13 and 14 for disc, 15 and 16 for full trial)
M{15} = num2cell(M{13});
M{16} = num2cell(M{14});

names = transpose(M{12});
onsets = transpose(M{13});
durations= transpose(M{14});

% creating a dataframe of names, onsets, durations
% Mdata = [M{12} M{13} M{14}];
% 
% % create separate cell arrays for each event
% for i=1:length(Mdata)
%     %x=i,1});
%     E{i}(i,:)=Mdata(i,:);
% end
% 
% % remove empty rows
% E=E(~cellfun('isempty',E))  
% for j=1:length(names)
%     E{j}(all(cellfun('isempty',E{j}),2),:)=[];
% end  
% 
% % CREATE ONSETS
% onsets_2=cell(size(names));
% 
% for j=1:length(names)
%     onsets_2{1,j}=E{1,j}(:,2);
% end
% 
% onsets_2 = cellfun(@cell2mat, onsets_2, 'UniformOutput', false)
% 
% % CREATE DURATIONS
% durations_2=cell(size(names));
% 
% for j=1:length(names)
%     durations_2{1,j}=E{1,j}(:,3);
% end
% 
% durations_2 = cellfun(@cell2mat, durations_2, 'UniformOutput', false)
        
% SAVE
sid = strrep(M{1}(1), '"', '');
run = strrep(M{2}(1), '"','');
saveName=strcat(sprintf('%s', sid{1}),'_DSD', run, '_full_trial_NOD.mat') 
cd (output_dir) 
save(saveName{1},'names','onsets','durations')

clearvars -except input_dir output_dir d

end
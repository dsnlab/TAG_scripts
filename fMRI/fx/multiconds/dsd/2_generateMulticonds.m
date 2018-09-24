% Nandita Vijayakumar
% February 2018

% generate_multiconds

% This script generates .mat files containing names,
% onsets, durations based on summary.csv files 

% Model: 1=affect_statement,2=neutral_statement,
% 3=affect_share,4=neutral_share, 
% 5=affect_private, 6=neutral_private

%% SET VARIABLES & FOLDERS 

clear all

% save main models or pmod models?
save_pmods = true;

% setting directory and listing csv files in matlab directory
f = '/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fmri/fx/multiconds/dsd/wave1/Summary/pmod/';
g = '/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fmri/fx/multiconds/dsd/wave1/NOD/pmod_RT/';
d = dir(fullfile(f,'*summary.csv'));

%% READ RAW DATA 

% for each subject and run
for k=1:length(d)
    
cd (f)

filename = d(k).name;
fid=fopen(filename, 'r');
M = textscan(fid,'%s%s%s%f%f%s%s\n','delimiter',',','Headerlines',1); 
fclose(fid);

% SET NAMES BASED ON CONDITIONS THAT ARE PRESENT

multicond = str2double(M{7}(1));

if multicond ==1
    names = {'affect_statement','neutral_statement','affect_share',...
       'neutral_share','affect_private','neutral_private','disc_missing'};
else if multicond ==2
    names = {'affect_statement','neutral_statement','affect_share',...
       'neutral_share','affect_private','neutral_private'};
else if multicond ==3
    names = {'affect_statement','neutral_statement','affect_share',...
       'neutral_share','affect_private','disc_missing'};
else if multicond ==4
    names = {'affect_statement','neutral_statement','affect_share',...
       'neutral_share','affect_private'};
else if multicond ==5
    names = {'affect_statement','neutral_statement','affect_share',...
       'neutral_share','neutral_private','disc_missing'};
else if multicond ==6
    names = {'affect_statement','neutral_statement','affect_share',...
       'neutral_share','neutral_private'};
else if multicond ==7
    names = {'affect_statement','neutral_statement','affect_share',...
       'neutral_share','disc_missing'};
else if multicond ==8
    names = {'affect_statement','neutral_statement','affect_share',...
       'neutral_share'};  
else if multicond ==9
    names = {'affect_statement','neutral_statement','affect_share',...
       'affect_private','neutral_private','disc_missing'};
else if multicond ==10
    names = {'affect_statement','neutral_statement',...
       'neutral_share','affect_private','neutral_private','disc_missing'};
else if multicond ==11
    names = {'affect_statement','neutral_statement',...
       'neutral_share','affect_private','neutral_private','disc_missing'};
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
end

% PREPARE ONSETS & DURATIONS
% changing durations from double to cell format
M{5} = num2cell(M{5});
M{4} = num2cell(M{4});

% creating a dataframe of names, onsets, durations
Mdata = [M{3} M{4} M{5} M{6}];

% create separate cell arrays for each event
for i=1:length(Mdata)
    x=str2num(Mdata{i,1});
    E{x}(i,:)=Mdata(i,:);
end

% remove empty rows
E=E(~cellfun('isempty',E))  
for j=1:length(names)
    E{j}(all(cellfun('isempty',E{j}),2),:)=[];
end  

% CREATE ONSETS
onsets=cell(size(names));

for j=1:length(names)
    onsets{1,j}=E{1,j}(:,2);
end

onsets = cellfun(@cell2mat, onsets, 'UniformOutput', false)

% CREATE DURATIONS

durations=cell(size(names));

for j=1:length(names)
    durations{1,j}=E{1,j}(:,3);
end

durations = cellfun(@cell2mat, durations, 'UniformOutput', false)

%changing durations to 0
for j=1:length(names)
    durations{1,j}(:)=0 
end

% CREATE PMODS

pmod = struct('name',{''},'param', {}, 'poly', {});

for j=3:length(names)
    pmod(j).name{1}=names{j};
    X = E{1,j}(:,4);
    X = str2double(X);
    pmod(j).param{1}=X;
    pmod(j).poly{1}=1;
end

for j=3:length(pmod)
    if contains(pmod(j).name,'disc_missing')
        pmod(j)=[];
    end
end  

for j=3:length(pmod)
    if isnan(pmod(j).param{1,1}(1))
        pmod(j).name=[];
        pmod(j).param=[];
        pmod(j).poly=[];
    end
end
        
% SAVE

if save_pmods == 1
    sid=str2double(M{1}(1));
    saveName=strcat(sprintf('%03d',sid),'_DSD',M{2}(1),'_NOD.mat') 
    cd (g) 
    save(saveName{1},'names','onsets','durations','pmod')
else 
    sid=str2double(M{1}(1));
    saveName=strcat(sprintf('%03d',sid),'_DSD',M{2}(1),'_NOD.mat') 
    cd (g) 
    save(saveName{1},'names','onsets','durations')
end

clearvars -except f g d save_pmods

end


%% READ RAW DATA 

% for each subject and run
for k=244:length(d)
    
cd (f)

filename = d(k).name;
fid=fopen(filename, 'r');
M = textscan(fid,'%s%s%s%f%f%s%s%s\n','delimiter',',','Headerlines',1); 
fclose(fid);

missing = str2double(M{8}(1));

if missing == 0
    names = {'affect_statement','neutral_statement','affect_decision',...
       'neutral_decision'};
    else if missing ==1
    names = {'affect_statement','neutral_statement','affect_decision',...
       'neutral_decision','missing_decisions'};
    end
end


% PREPARE ONSETS & DURATIONS
% changing durations from double to cell format
M{5} = num2cell(M{5});
M{4} = num2cell(M{4});

% creating a dataframe of names, onsets, durations
Mdata = [M{3} M{4} M{5} M{6} M{7}];

% create separate cell arrays for each event
for i=1:length(Mdata)
    x=str2num(Mdata{i,1});
    E{x}(i,:)=Mdata(i,:);
end

% remove empty rows
E=E(~cellfun('isempty',E))  
for j=1:length(names)
    E{j}(all(cellfun('isempty',E{j}),2),:)=[];
end  

% CREATE ONSETS
onsets=cell(size(names));

for j=1:length(names)
    onsets{1,j}=E{1,j}(:,2);
end

onsets = cellfun(@cell2mat, onsets, 'UniformOutput', false)

% CREATE DURATIONS

durations=cell(size(names));

for j=1:length(names)
    durations{1,j}=E{1,j}(:,3);
end

durations = cellfun(@cell2mat, durations, 'UniformOutput', false)

%changing durations to 0
%for j=1:length(names)
%    durations{1,j}(:)=0 
%end

% CREATE OTRH

orth=cell(size(names));

for j=1:length(names)
    orth{j}=0;
end

% CREATE PMODS

pmod = struct('name',{''},'param', {}, 'poly', {});

for j=3:4
    X = E{1,j}(:,4);
    X = str2double(X);
    Y = E{1,j}(:,5);
    Y = str2double(Y);
    
    pmod(j).name{1}='value';
    pmod(j).param{1}=X;
    pmod(j).poly{1}=1;
    
    if ~isnan(Y(1,:))
        pmod(j).name{2}='decision';
        pmod(j).param{2}=Y;
        pmod(j).poly{2}=1;
    end
    
end 

% SAVE

if save_pmods == 1
    sid=str2double(M{1}(1));
    saveName=strcat(sprintf('%03d',sid),'_DSD',M{2}(1),'_NOD.mat') 
    cd (g) 
    save(saveName{1},'names','onsets','durations','orth','pmod')
else 
    sid=str2double(M{1}(1));
    saveName=strcat(sprintf('%03d',sid),'_DSD',M{2}(1),'_NOD.mat') 
    cd (g) 
    save(saveName{1},'names','onsets','durations')
end

clearvars -except f g d save_pmods

end
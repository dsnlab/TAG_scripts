% Nandita Vijayakumar
% February 2018

% generate_multiconds

% This script generates .mat files containing names,
% onsets, durations based on summary.csv files 

% Model: 1=affect_statement,2=neutral_statement,
% 3=affect_share,4=neutral_share, 
% 5=affect_private, 6=neutral_private, 7=disclosure_missing

%% 
clear all

%setting directory and listing csv files in matlab directory
f = '/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fmri/fx/multiconds/dsd/wave1/Summary/';
g = '/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fmri/fx/multiconds/dsd/wave1/NOD/';
d = dir(fullfile(f,'*summary.csv'));

for k=1:length(d)
    
cd (f)

filename = d(k).name;
fid=fopen(filename, 'r');
M = textscan(fid,'%s%s%s%f%f%s\n','delimiter',',','Headerlines',1); 
fclose(fid);

%changing durations from double to cell format
M{5} = num2cell(M{5});
M{4} = num2cell(M{4});

%creating a dataframe of names, onsets, durations
Mdata = [M{3} M{4} M{5} M{6}];

%create separate data arrays for each event
for i=1:length(Mdata) % for each row in Mdata
    if Mdata{i,1}==string('1') % if it matches event 1, write a new row 
        E1{i,1} = Mdata{i,1};
        E1{i,2} = Mdata{i,2};
        E1{i,3} = Mdata{i,3};
        E1{i,4} = Mdata{i,4};
    else if Mdata{i,1}==string('2') %ditto for event 2 
        E2{i,1} = Mdata{i,1};
        E2{i,2} = Mdata{i,2};
        E2{i,3} = Mdata{i,3};
        E2{i,4} = Mdata{i,4};
    else if Mdata{i,1}==string('3')%event 3 
        E3{i,1} = Mdata{i,1};
        E3{i,2} = Mdata{i,2};
        E3{i,3} = Mdata{i,3};
        E3{i,4} = Mdata{i,4};
    else if Mdata{i,1}==string('4')%event 4 
        E4{i,1} = Mdata{i,1};
        E4{i,2} = Mdata{i,2};
        E4{i,3} = Mdata{i,3};
        E4{i,4} = Mdata{i,4};
    else if Mdata{i,1}==string('5')%event 5
        E5{i,1} = Mdata{i,1};
        E5{i,2} = Mdata{i,2};
        E5{i,3} = Mdata{i,3};
        E5{i,4} = Mdata{i,4};
    else if Mdata{i,1}==string('6')%event 6
        E6{i,1} = Mdata{i,1};
        E6{i,2} = Mdata{i,2};
        E6{i,3} = Mdata{i,3};
        E6{i,4} = Mdata{i,4};
    else if Mdata{i,1}==string('7')%event 7
        E7{i,1} = Mdata{i,1};
        E7{i,2} = Mdata{i,2};
        E7{i,3} = Mdata{i,3};
        E7{i,4} = Mdata{i,4};
        end
        end
        end
        end
        end
        end
    end
end     

for j=1:7
    if exist(strcat('E',num2str(j))) == 1
        n = eval(strcat('E',num2str(j)));
        n(all(cellfun('isempty',n),2),:)=[];
        E{j}=n;
    end
end

%% NAMES

names = {'affect_statement','neutral_statement','affect_share',...
       'neutral_share','affect_private','neutral_private','disc_missing'};

%% ONSETS

%hacky way of creating arrays for onsets and durations that are same size
%as names, but replace values with []

onsets=names;

for i=1:7
  a=onsets{i};
    a=[]; 
    onsets{i}=a;
end

%input values from Mdata into onsets array

for j=1:7
    if exist(strcat('E',num2str(j))) == 1
        if isempty(E{1,j})
            onsets{1,j}=[];
        else onsets{1,j}=E{1,j}(:,2);
        end
    else onsets{1,j}=[];    
    end
end

onsets = cellfun(@cell2mat, onsets, 'UniformOutput', false)


%% DURATIONS

durations=onsets;

for j=1:7
    if exist(strcat('E',num2str(j))) == 1
        if isempty(E{1,j})
            durations{1,j}=[];
        else durations{1,j}=E{1,j}(:,3);
        end
    else  durations{1,j}=[];
    end
end

durations = cellfun(@cell2mat, durations, 'UniformOutput', false)

%% PMODS

pmod = struct('name',{''},'param', {}, 'poly', {});

for j=3:6
    if exist(strcat('E',num2str(j))) == 1
        X = E{1,j}(:,4);
        X = cellstr(X);
        X = str2double(X);
        if j==3
            name='AffSh_pmod';
        else if j==4
            name = 'NeuSh_pmod';
        else if j==5
            name = 'AffPr_pmod';
        else if j==6
            name = 'NeuPr_pmod';   
            end
            end
            end
        end
        pmod(j).name{1}=name;
        pmod(j).param{1}=X;
        pmod(j).poly{1}=1;
    end
end
 
%% SAVE

sid=str2double(M{1}(1));
saveName=strcat(sprintf('%03d',sid),'_DSD',M{2}(1),'_NOD.mat') 
cd (g) 
save(saveName{1},'names','onsets','durations','pmod')

clearvars -except f g d

end

% Nandita Vijayakumar
% February 2018

% generate_multiconds

% This script generates .mat files containing names,
% onsets, durations based on summary.csv files 

% Model: 1=affect_statement,2=neutral_statement,
% 3=affect_share,4=neutral_share, 
% 5=affect_private, 6=neutral_private

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

%create array of names based on conditions that are present
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

onsets=names;

for j=1:7
    if exist(strcat('E',num2str(j))) == 1
        onsets{1,j}=E{1,j}(:,2);
     end
end       



E1(all(cellfun('isempty',E1),2),:)=[];
E2(all(cellfun('isempty',E2),2),:)=[];
E3(all(cellfun('isempty',E3),2),:)=[];
E4(all(cellfun('isempty',E4),2),:)=[];
E5(all(cellfun('isempty',E5),2),:)=[];
E6(all(cellfun('isempty',E6),2),:)=[];

for j=1:7
    if length(E) == j
        E{j}(all(cellfun('isempty',E7),2),:)=[];
end



%hacky way of creating arrays for onsets and durations that are same size
%as names, but replace values with []

onsets=names;

for i=1:7
  a=onsets{i};
    a=[]; 
    onsets{i}=a;
end

%input values from Mdata into onsets array

for j=1:6
    if isempty(E{1,j})
        onsets{1,j}=[];
    else onsets{1,j}=E{1,j}(:,2);
    end
end

if length(E) == 7
    if isempty(E{1,7})
        onsets{1,7}=[];
    else onsets{1,7}=E{1,7}(:,2);
    end
end

onsets = cellfun(@cell2mat, onsets, 'UniformOutput', false)

%input values from Mdata into durations array

durations=onsets;

for j=1:6
    if isempty(E{1,j})
        durations{1,j}=[];
    else durations{1,j}=E{1,j}(:,3);
    end
end

if length(E) == 7
    if isempty(E{1,7})
        durations{1,7}=[];
    else durations{1,7}=E{1,7}(:,3);
    end
end

durations = cellfun(@cell2mat, durations, 'UniformOutput', false)


%% PMODS
x3 = E{1,3}(:,4);
x3 = cellstr(x3);
x3 = str2double(x3);

x4 = E{1,4}(:,4);
x4 = cellstr(x4);
x4 = str2double(x4);

x5 = E{1,5}(:,4);
x5 = cellstr(x5);
x5 = str2double(x5);

x6 = E{1,6}(:,4);
x6 = cellstr(x6);
x6 = str2double(x6);

pmod = struct('name',{''},'param', {}, 'poly', {});
pmod(3).name{1} = 'NeuPr_pmod';
pmod(3).param{1}=x3;
pmod(3).poly{1}=1;

pmod(4).name{1} = 'NeuSh_pmod';
pmod(4).param{1}=x4;
pmod(4).poly{1}=1;

pmod(5).name{1} = 'AffPr_pmod';
pmod(5).param{1}=x5;
pmod(5).poly{1}=1;

pmod(6).name{1} = 'AffSh_pmod';
pmod(6).param{1}=x6;
pmod(6).poly{1}=1;
 
%% SAVE

sid=str2double(M{1}(1));
saveName=strcat(sprintf('%03d',sid),'_DSD',M{2}(1),'_NOD.mat') 
cd (g) 
save(saveName{1},'names','onsets','durations','pmod')

clearvars -except f g d

end

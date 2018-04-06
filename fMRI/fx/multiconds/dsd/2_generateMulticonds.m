% Nandita Vijayakumar
% February 2018

% generate_multiconds

% This script generates .mat files containing names,
% onsets, durations based on summary.csv files 

clear all

%setting directory and listing csv files in matlab directory
f = '/Volumes/psych-cog/dsnlab/TAG/TAG_BIDS/derivatives/fMRI/fx/multiconds/DSD/ses-wave1/Summary/';
g = '/Volumes/psych-cog/dsnlab/TAG/TAG_BIDS/derivatives/fMRI/fx/multiconds/DSD/ses-wave1/';
d = dir(fullfile(f,'*summary.csv'));

for k=1:length(d)
    
cd (f)

filename = d(k).name;
fid=fopen(filename, 'r');
M = textscan(fid,'%s%s%s%s\n','delimiter',',','Headerlines',1);
fclose(fid);

%changing durations from double to cell format
M{4} = num2cell(M{4});

%creating a dataframe of names, onsets, durations
Mdata = [M{2} M{3} M{4}];

%create separate data arrays for each event
for i=1:length(Mdata) % for each row in Mdata
    if Mdata{i,1}==string('1') % if it matches event 1, write a new row 
        E1{i,1} = Mdata{i,1};
        E1{i,2} = Mdata{i,2};
        E1{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('2') %ditto for event 2 
        E2{i,1} = Mdata{i,1};
        E2{i,2} = Mdata{i,2};
        E2{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('3')%event 3 
        E3{i,1} = Mdata{i,1};
        E3{i,2} = Mdata{i,2};
        E3{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('4')%event 4 
        E4{i,1} = Mdata{i,1};
        E4{i,2} = Mdata{i,2};
        E4{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('5')%event 5
        E5{i,1} = Mdata{i,1};
        E5{i,2} = Mdata{i,2};
        E5{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('6')%event 5
        E6{i,1} = Mdata{i,1};
        E6{i,2} = Mdata{i,2};
        E6{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('7')%event 5
        E7{i,1} = Mdata{i,1};
        E7{i,2} = Mdata{i,2};
        E7{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('8')%event 5
        E8{i,1} = Mdata{i,1};
        E8{i,2} = Mdata{i,2};
        E8{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('9')%event 5
        E9{i,1} = Mdata{i,1};
        E9{i,2} = Mdata{i,2};        
        E9{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('10')%event 5
        E10{i,1} = Mdata{i,1};
        E10{i,2} = Mdata{i,2};
        E10{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('11')%event 5
        E11{i,1} = Mdata{i,1};
        E11{i,2} = Mdata{i,2};
        E11{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('12')%event 5
        E12{i,1} = Mdata{i,1};
        E12{i,2} = Mdata{i,2};
        E12{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('13')%event 5
        E13{i,1} = Mdata{i,1};
        E13{i,2} = Mdata{i,2};
        E13{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('14')%event 5
        E14{i,1} = Mdata{i,1};
        E14{i,2} = Mdata{i,2};
        E14{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('15')%event 5
        E15{i,1} = Mdata{i,1};
        E15{i,2} = Mdata{i,2};
        E15{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('16')%event 5
        E16{i,1} = Mdata{i,1};
        E16{i,2} = Mdata{i,2};
        E16{i,3} = Mdata{i,3};
    else if Mdata{i,1}==string('17')%event 5
        E17{i,1} = Mdata{i,1};
        E17{i,2} = Mdata{i,2};
        E17{i,3} = Mdata{i,3};        
    else if Mdata{i,1}==string('18')%event 5
        E18{i,1} = Mdata{i,1};
        E18{i,2} = Mdata{i,2};
        E18{i,3} = Mdata{i,3};   
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
        end
        end
        end
        end
        end
        end
    end
end

for j=1:18
    if exist(strcat('E',num2str(j))) == 1
        n = eval(strcat('E',num2str(j)));
        n(all(cellfun('isempty',n),2),:)=[];
        E{j}=n;
    end
end


%create array of names
names={'affect_true','affect_false','neutral_true','neutral_false',...
       'affect_share_loss','affect_share_gain','affect_share_none',...
       'affect_private_loss','affect_private_gain','affect_private_none',...
       'neutral_share_loss','neutral_share_gain','neutral_share_none',...
       'neutral_private_loss','neutral_private_gain','neutral_private_none',...
       'statement_missing','disclosure_missing'}; %generate names

%hacky way of creating arrays for onsets and durations that are same size
%as names, but replace values with []

onsets=names;

for i=1:18
  a=onsets{i};
    a=[]    
    onsets{i}=a;
end

%input values from Mdata into onsets array

for j=1:length(E)
    if isempty(E{1,j})
        onsets{1,j}=[];
    else onsets{1,j}=E{1,j}(:,2);
         onsets{1,j}=str2double(onsets{1,j});
         
    end
end

%input values from Mdata into onsets array

durations=onsets;

for i=1:18
    if isempty(durations{i})
        durations{1,i}=[];
    else durations{1,i}=E{1,i}(:,3);
         durations{1,i}=cellfun(@str2double, durations{1,i});
    end
end


%% SAVE
%sub ID
saveName=strcat(M{1}(1),'_NOD.mat') % 
cd (g) %need to change this to the output folder
%save(saveName{1},'names','onsets','durations')
save(saveName{1},'names','onsets','durations')

clearvars -except f g d

end

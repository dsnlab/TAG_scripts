% Sam Chavez
% Last Modified: 13-May-2018

% This script generates slice specification files to be used with FSL's eddy.

clear all

% setting directory and listing csv files in matlab directory
f = '/home/schavez6/TAG001/';

cd (f)

fp = fopen('diff_mb2_g2_64dirs_2mm_rl_20160206094444_17.json','r');
fcont = fread(fp);
fclose(fp);
cfcont = char(fcont');
i1 = strfind(cfcont,'SliceTiming');
i2 = strfind(cfcont(i1:end),'[');
i3 = strfind(cfcont((i1+i2):end),']');
cslicetimes = cfcont((i1+i2+1):(i1+i2+i3-2));
slicetimes = textscan(cslicetimes,'%f','Delimiter',',');
[sortedslicetimes,sindx] = sort(slicetimes{1});
mb = length(sortedslicetimes)/(sum(diff(sortedslicetimes)~=0)+1);
slspec = reshape(sindx,[mb length(sindx)/mb])'-1;
dlmwrite('my_slspec.txt',slspec,'delimiter',' ','precision','%3d');

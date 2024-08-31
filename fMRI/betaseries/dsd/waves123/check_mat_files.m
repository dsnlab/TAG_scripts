% which cond? disclosure or eval
cond = 'disclosure';

f = filesep();

dir = ['/Volumes/psych-cog/dsnlab/TAG/nonbids_data/fMRI/fx/multiconds/dsd/betaseries/' cond '_nod'];

cd(dir);

%for k=1:length(d)

filename = d(k).name;
print(d(k));
fid=fopen(filename, 'r');
% disc and eval: 
%M = textscan(fid,'%s%s%s%s%f%f%s%f%f%s%s%s%f%f\n','delimiter',',','Headerlines',1); 
%M = textscan(fid,'%s%s%s%s%f%f%s%f%f%s%s%f%f%s%f%f\n','delimiter',',','Headerlines',1); 
%M = textscan(fid,'%s%s%s%s%f%f%s%f%f%s%s%f%f%s%f%f','delimiter',',','Headerlines',1); 
% new test on 20240827 for 210w01 only
M = textscan(fid,'%s%s%s%s%f%f%f%f%f%f%s%s%f%f','delimiter',',','Headerlines',1);
fclose(fid);

dim(M)
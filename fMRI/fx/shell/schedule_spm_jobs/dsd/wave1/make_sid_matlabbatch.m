fileID=fopen(script_file);
textstuffcell=textscan(fileID, '%[^\n]');
fclose(fileID);

regexp=['(''.*)',num2str(replacesid),'(.*'')'];
replaceexpr=['$1',num2str(sub),'$2'];
newtextcell=cellfun(@(x) regexprep(x, regexp, replaceexpr), textstuffcell{1}, 'UniformOutput', false);

newtext=strjoin(newtextcell, '\n');

eval(newtext);

[outdir, outfile] = fileparts(script_file);

outdirfull = fullfile(outdir,'sid_batches',outfile);

if ~exist(outdirfull, 'dir')
  mkdir(outdirfull);
end

save(fullfile(outdirfull,strcat(num2str(sub),'_',outfile,'.mat')),'matlabbatch');

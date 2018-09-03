function filename = setupcounttextdata()
% USAGE: filename = setupcounttextdata;

currentfolder = pwd;
[filenames,pathname,filterindex] = uigetfile('*.txt','Please select text documents...','MultiSelect','On');
cd(pathname);
if ischar(filenames),
    filelist{1} = filenames;
    nrfilenames = 1;
else
    filelist = filenames;
    nrfilenames = length(filelist);
end;

outputtextdata = '';
for i = 1:nrfilenames,
    thetext = readtext(filelist{i});
    filenamedisplay = strrep(filelist{i},' ','_');
    docheader = ['<TITLE>',filenamedisplay,'</TITLE>'];
    outputtextdata = strvcat(outputtextdata,docheader);
    outputtextdata = strvcat(outputtextdata,thetext);
end;

cd(currentfolder);
fid = fopen('docdata.txt','w');
[nrlines,dum] = size(outputtextdata);
for i = 1:nrlines,
    fprintf(fid,'%s\n',outputtextdata(i,:));
end;
fclose(fid);



    
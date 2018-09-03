function [countmx,wordlist,doclist] = makecountmx(pathname,filename)
% USAGE: [countmx,wordlist,doclist] = makecountmx(pathname,filename) 
currentfolder = pwd;
cd(pathname);
dataline = perl('makecounttable.pl',filename);
[countmx,wordlist,doclist] = decodedataline(dataline);
cd(currentfolder);
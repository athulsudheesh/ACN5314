function [countmx,wordlist,doclist] = decodedataline(dataline)
% USAGE  [countmx,wordlist,doclist] = decodedataline(dataline)

wordlist = ''; doclist = '';
commalocs = findstr(dataline,',');
nrcommalocs = length(commalocs);
nrentries = nrcommalocs/3;
if (nrentries ~= round(nrcommalocs/3)),
    disp('WARNING!!! BAD FILE FORMAT!!!');
end;
for i = 1:nrentries,
    j = (i-1)*3;
    if (i==1),
        beginentry = 1;
    else
        beginentry = thirdcomma+1;
    end;
    firstcomma = commalocs(j+1);
    secondcomma =commalocs(j+2);
    thirdcomma = commalocs(j+3);
    docname = strtrim(dataline(beginentry:firstcomma-1));
    wordname = strtrim(dataline(firstcomma+1:secondcomma-1));
    countname = strtrim(dataline(secondcomma+1:thirdcomma-1));
    wordnameid = strmatch(wordname,wordlist,'exact');
    docnameid = strmatch(docname,doclist,'exact');
    if isempty(wordnameid),
        wordlist = strvcat(wordlist,wordname);
        [wordlistdim,dum] = size(wordlist);
        wordnameid = wordlistdim;
    end;
    if isempty(docnameid),
        doclist = strvcat(doclist,docname);
        [doclistdim,dum] = size(doclist);
        docnameid = doclistdim;
    end;
    countmx(wordnameid,docnameid) = str2num(countname);
end;
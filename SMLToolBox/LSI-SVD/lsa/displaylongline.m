function displayedline = displaylongline(wordtokenlist,linelength)
% USAGE: displayedline = displaylongline(wordtokenlist,'linelength');

endoflist = 0; maxlinelength = 80; displayedline = '';
leftover = wordtokenlist; currentline = '';
while ~endoflist,
    endofline = 0;
    while ~endofline,
        [wordtoken,leftover] = strtok(leftover);
        currentline = [currentline ' ' wordtoken];
        endofline = length(currentline) > maxlinelength;
    end;
    displayedline = strvcat(displayedline,currentline);
    currentline = '';
    endoflist = isempty(leftover);
end;
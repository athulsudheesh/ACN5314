function thetext = readtext(filename)
% Usage: thetext = readtext(filename)
[fid,mess] = fopen(filename,'r');
if (fid == -1),
   disp(['Could not find the file: ',filename]);
else
   thetext = [];
   nextstring = 1;
   while (nextstring ~= -1),
     nextstring = fgetl(fid);
     if ischar(nextstring),
        thetext = strvcat(thetext,nextstring);
      %  thetext = [thetext; pad_blanks(nextstring,80)];
     end;
   end;
   [rdim,cdim] = size(thetext);
%    thetext = thetext(1:(rdim-1),:);  % commented out 4/2/05
end;
fclose(fid);      

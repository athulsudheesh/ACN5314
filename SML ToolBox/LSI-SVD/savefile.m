function savefile(filename,thetext,mode)
% USAGE: savefile(filename,thetext,mode)
% mode = 'w'  means "write" while mode = 'a' means "append"

[nrlines,dum] = size(thetext);
fid = fopen(filename,mode);
for i = 1:nrlines,
   fprintf(fid,'%s \n',thetext(i,:));
end;
fclose(fid);
function savefile(filename,thetext,mode)
% USAGE: savefile(filename,thetext,mode)
% mode = 'w'  means "write" while mode = 'a' means "append"

% FUNCTIONAL DESCRIPTION: This function takes the input "filename" and saves it 
% in  write or append mode depending on the input "mode"

% 
%
% INPUTS:
% NAME              RANGE                 DESCRIPTION
% filename        char string          name of the file to be saved
% thetext         char array           contents of the file 
% mode            {'w','a'}           write/append mode
%
%
% OUTPUTS:
% NAME       RANGE              DESCRIPTION
%
%

[nrlines,dum] = size(thetext);
%filename = getfilenickname(filename);
fid = fopen(filename,mode);
if fid == (-1),
    warnhandle = warndlg(['The filename "',filename,'" is not valid. Save Operation Failed.']);
    waitfor(warnhandle);
else
    for i = 1:nrlines,
        fprintf(fid,'%s \n',thetext(i,:));
    end;
    fclose(fid);
end;
%disp(['Output written to file: "',filename,'".']);
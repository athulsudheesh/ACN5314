function [originaldata,predictorlabels] = loaddatafile(filename);
% function [originaldata,predictorlabels] = loaddatafile(filename)

% Display Prompt to User
% NOTE: The data file is structured such that the left-most
% columns are the targets and the final right-most column is the intercept
prompt={'Datafilename:',};
numlines=1;
defaultanswer={'irisdata3.xlsx'};
options.Resize='on';
options.WindowStyle='normal';
answer=inputdlg(prompt,'Data File',numlines,defaultanswer,options);
thedatafilename = answer{1};

% Load Data file
[originaldata,originalheader,originalraw] = xlsread(thedatafilename);
[nrstim,nrvars] = size(originaldata);
nrvarsm1 = nrvars-1;
for i = 2:nrvarsm1,
    predictorlabels{i-1} = originalheader{i};
end


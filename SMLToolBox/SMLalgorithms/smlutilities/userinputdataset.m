function thedata = userinputdataset(menutitle,datafileprompt);
% USAGE: thedata = userinputdataset(menutitle,datafileprompt);

% USER ENTERS PARAMETER VALUES
[thedatafilename, pathname] = uigetfile({'*.xls;*.xlsx;*.csv'},datafileprompt);

prompt={'Number of Targets in Left-Most Columns:'};
name = menutitle;
numlines=1;
defaultanswer={'1'};
options.Resize='on';
options.WindowStyle='normal';
%options.Interpreter='tex';
answer=inputdlg(prompt,name,numlines,defaultanswer,options);
numberoftargets = str2num(answer{1});

% Setup Data Set Constants
% Note that first row of spreadsheet is the names of the variables
% Each additional row is a training stimulus
% The first M columns are the "targets" (desired responses)
thedata.datafilename = thedatafilename; 
waithandle = waitbar(0,['Loading Data File "',thedatafilename,'". Please wait...']);
pause(0.5);
waitbar(0.1,waithandle);
pause(1.0);
waitbar(0.7,waithandle);
[eventhistory, varnames, alldata] = xlsread(thedatafilename);
thedata.eventhistory = eventhistory;
thedata.varnames = varnames;
thedata.nrtargets = numberoftargets; 
[nrevents,nrvars] = size(eventhistory);
nrtargets = thedata.nrtargets;
thedata.nrvars = nrvars;
thedata.inputvectordim = (nrvars - nrtargets);
thedata.inputvectors = eventhistory(:,(nrtargets+1):nrvars);
thedata.targetvectors = eventhistory(:,(1:nrtargets));
thedata.nrrecords = nrevents;
close(waithandle);
disp(['Datafile: "',thedatafilename,'" has been loaded!']);
end


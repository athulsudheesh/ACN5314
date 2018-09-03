function [constants,thedata] = setupmlogitconstants;


% Set Default Constants
constants = sazwdefaultconstants;
constants.optimizemethod.adaptivelearning = 'Batch (off-line)';
constants.model.penaltytermweight = 0.0001; % regularization helps results!!!

% Define Relevant Files
constants.model.funkfilename = 'objfunction';
constants.model.gradfilename = 'gradobjfunction';
constants.model.hessfilename = 'hessobjfunction';

prompt={'Datafilename:','Number of Targets:','Interpretation Threshold:','Maximum Iterations:',...
    'Number of Bootstraps:'};
name='Linear Machine';
numlines=1;
defaultanswer={'irisdata3.xlsx','3','0.1','200','100'};
options.Resize='on';
options.WindowStyle='normal';
%options.Interpreter='tex';
answer=inputdlg(prompt,name,numlines,defaultanswer,options);
thedatafilename = answer{1};
numberoftargets = str2num(answer{2});
interpretationthreshold = str2num(answer{3});
maxiterations = str2num(answer{4});
constants.stoppingcriteria.maxiterations = maxiterations;
constants.nrbootstraps = str2num(answer{5});

% Setup Data Set Constants
% Note that first row of spreadsheet is the names of the variables
% Each additional row is a training stimulus
% The first M columns are the "targets" (desired responses)
thedata.datafilename = thedatafilename;  
[eventhistory, varnames, alldata] = xlsread(thedatafilename);
thedata.eventhistory = eventhistory;
thedata.varnames = varnames;
thedata.nrtargets = numberoftargets;  
[nrevents,nrvars] = size(eventhistory);
nrtargets = thedata.nrtargets;

% originaleventhistory = eventhistory;
% nrtargets = nrvars;
% eventhistory = [originaleventhistory originaleventhistory];
% [nrevents,nrvars] = size(eventhistory);
% thedata.eventhistory = eventhistory;
% thedata.nrtargets = nrtargets;
% thedata.varnames = [varnames varnames];

% Start Descent Algorithm
usehessian = input('Use Hessian for learning (0=no,1=yes)?:');
if usehessian,
    constants.optimizemethod.searchdirection = 'levenbergmarquardt';
    disp('Using Levenberg Marquardt Update...');
else
    constants.optimizemethod.searchdirection = 'Lbfgs';
    disp('Using L-BFGS Update...');
end;


end


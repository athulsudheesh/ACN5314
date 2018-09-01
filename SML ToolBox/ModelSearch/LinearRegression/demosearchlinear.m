function demosearch()
% USAGE: demosearch;

diary(['COMMAND-OUTPUT-LOG-',datestr(now,30),'.txt']);

usesimulateddata = input('Use simulated data? (0=no, 1 = yes):');

% Set Default Constants
constants = defaultconstants;


% FUNCTION DEFINITIONS
doexhaustive = 0;
constants.objectivefunctionfile = 'getmodelfitness';
userchoice = input('0) Metropolis Random Search, 1) Gibbs Sampler with Random Visits, 2) stepwise search:');
switch userchoice,
    case 0, constants.proposalfile = 'randommetrobinary';
    case 1, constants.proposalfile = 'gibbsamplebinary';
    case 2, constants.proposalfile = 'stepwisesearchproposal';
end;

% LOAD DATA FILE
[originaldata,varnames,originalraw] = xlsread('lowbwtrmg2');
    %------SET FINAL MODEL FOR SIMULATED DATA CASE
    % VARNAMES: target normage normlwt race1 race2 smoke ptL ht ui normbwt intercept
    correctmodelselector = [1 3 10 6 11];
    tempvarnames{1} = 'TARGET';
    tempvarnames{2} = 'NORMLWT';
    tempvarnames{3} = 'NORMBWT'
    tempvarnames{4} = 'SMOKE';
    tempvarnames{5} = 'INTERCEPT';
    %---------------------------------------------------
[nrstim,nrvars] = size(originaldata);
nrpredictors = nrvars-1;
for i = 1:nrpredictors,
    predictorlabels{i} = varnames{i+1};
end;
nrpredictors = length(predictorlabels);
constants.model.dictionary.varnames = varnames;

if usesimulateddata,
    % Generate Simulated Data From Original Data File

    thedataset = originaldata(:,correctmodelselector);
    dodisplay = 1; estimationonly = 1;
    perform = linearreg(dodisplay,estimationonly,tempvarnames,thedataset,constants);
    betatrue = perform.betavector;
    predictors = thedataset(:,2:length(correctmodelselector));
    predictedavgresponse = predictors*betatrue;
    originaltargets = thedataset(:,1);
    responsevar = mean((originaltargets-predictedavgresponse).^2);
    targets = predictedavgresponse + sqrt(responsevar)*randn(nrstim,1);
    %simulateddata = [targets originaldata(:,[2:nrvars])];
    nrvars = 8; nrpredictors = nrvars-1;
    simulateddata = [targets thedataset(:,2:4) randn(nrstim,(nrvars-5)) thedataset(:,5)];
    varnames = tempvarnames;
    for i = 5:(nrvars-1),
        varnames{i} = ['DECOY',num2str(i-4)];
    end;
    varnames{nrvars} = 'INTERCEPT';
    constants.data.eventhistory = simulateddata;
    constants.data.varnames = varnames;
    constants.model.dictionary.varnames = varnames;
    
    % Unclamp all predictors
    constants.clampedvector = zeros(nrpredictors,1);
    constants.clampedvector(nrpredictors) = 1;
else
    % DO NOT USE SIMULATED DATA
    constants.data.eventhistory = originaldata;
    constants.data.varnames = varnames;
    constants.model.dictionary.varnames = varnames;
    
    % Unclamp all predictors
    constants.clampedvector = zeros(nrpredictors,1);
    constants.clampedvector(nrpredictors) = 1;
end;



% DISPLAY INITIAL MODEL PERFORMANCE
disp('************************ PERFORMANCE OF MODEL USING ALL PREDICTORS **********');
datamx = constants.data.eventhistory;
originaldatanew = datamx;
originalheader = constants.model.dictionary.varnames;
estimationonly = 0; % computes model fits (this really slows things down)
dodisplay = 1;
perform = linearreg(dodisplay,estimationonly,originalheader,originaldatanew,constants);

keepgoing = input('Initial Parameter Estimation on all parameters. Hit any key to continue.','s');

% Setup Figure Window
DisplayPositionVector = constants.displayprogress.PositionVector;
fighandle = figure;
set(fighandle,'Position',DisplayPositionVector);

disp(' ');
disp(' ');
% START Metropolis-Hastings Descent Algorithm
disp('*************************BEGIN MODEL SEARCH ALGORITHM *****************************');
starttime = tic;
statedim = nrpredictors;
%constants.initialstate = rand(1,statedim) > 1-(1/nrpredictors);
constants.initialstate = rand(1,statedim) > 0.5;
constants.initialstate(nrpredictors) = 1;
[currentstate,performancehistory] = mhdescent(constants);
finaltime = toc(starttime);
disp('*********************** MODEL SEARCH ALGORITHM COMPLETED! ***************************');
disp(' ');
disp(' ');

% DISPLAY FINAL MODEL PERFORMANCE
disp('************************ PERFORMANCE OF FINAL MODEL USING SELECTED PREDICTORS **********');
datamx = constants.data.eventhistory;
[nrrecords,nrvars] = size(datamx);
statevector = currentstate(:);
selectedvarlocs = find(statevector == 1);
selectedvars = [1 selectedvarlocs']';
originaldatanew = datamx(:,selectedvars);
originalheader = constants.model.dictionary.varnames;
estimationonly = 0; % computes model fits (this really slows things down)
dodisplay = 1;
perform = linearreg(dodisplay,estimationonly,originalheader,originaldatanew,constants);
diary('off');

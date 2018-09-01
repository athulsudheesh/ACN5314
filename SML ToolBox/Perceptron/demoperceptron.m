function demoperceptron;
% USAGE: demoperceptron;

% Set random number generator to random initial starting seed
%rng('shuffle');

% Set random number generator to generate a predictable random sequence
disp('WARNING! Using random seed which makes sequence predictable!!!');
rng(123);

% Set Default Constants based upon local
% data file "constantvalues.mat"
% if exist('constantvalues.mat'),
%      ButtonName = questdlg('DELETE existing default constants?:', ...
%                          'Default Constants', ...
%                          'Yes', 'No', 'No');
%     if strcmp(ButtonName,'Yes'),
%         delete('constantvalues.mat');
%         disp('"constantvalues.mat" has been deleted.');
%     end;
% end;
constants = updatesazwconstants;

% Now load the training data file
trainingdata = userinputdataset('Training Data','Training Data Filename?:');

% Now load the test data file
testingdata = userinputdataset('Test Data','Test Data Filename?:');

% Initialize Parameters to Random Values
nrhidden = constants.model.nrhidden;
nrtargets = trainingdata.nrtargets
inputvectordim = trainingdata.inputvectordim;
nrvars = trainingdata.nrvars;
initialwtmag = constants.initialconditions.wtsdev;
weightdensity = constants.model.weightdensity;
hunittype = constants.model.hunittype;
vmatrix = initialwtmag * randn(nrtargets,nrhidden+1);
wmatrix = initialwtmag * randn(nrhidden,(nrvars-nrtargets));
wmatrixT = wmatrix';
vmatrixT = vmatrix';
parameters = [vmatrixT(:); wmatrixT(:)];

% Construct Random Connectivity Matrix and Update Parameter Values
paramdim = length(parameters);
constants.model.connectmask = rand(paramdim,1) > 1 - constants.model.weightdensity;
parameters = parameters .* constants.model.connectmask;

% Start Descent Algorithm
performancehistory = [];

[parameters,performancehistory] = sazwdescent(trainingdata,parameters,performancehistory,constants);

% TRAINING DATA (Final Pass)
disp(' ');
disp('**********************************************************');
disp('TRAINING DATA RESULTS:');
trainsazout = computesazwoutputstats(parameters,constants,trainingdata);
displaysazwresults(trainsazout);

% TEST DATA (Final Pass)
disp('  ');
disp('TEST DATA RESULTS:');
testsazout = computesazwoutputstats(parameters,constants,testingdata);
displaysazwresults(testsazout);


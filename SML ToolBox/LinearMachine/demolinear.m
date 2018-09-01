function demolinear
% USAGE: demolinear;

% Set random number generator to random initial starting seed
rng('shuffle');

% Set Default Constants based upon local
% data file "constantvalues.mat"
if exist('constantvalues.mat'),
     ButtonName = questdlg('DELETE existing default constants?:', ...
                         'Default Constants', ...
                         'Yes', 'No', 'No');
    if strcmp(ButtonName,'Yes'),
        delete('constantvalues.mat');
        disp('"constantvalues.mat" has been deleted.');
    end;
end;
constants = updatesazwconstants;

% Now load the training data file
trainingdata = userinputdataset('Training Data','Training Data Filename?:');

% Now load the test data file
testingdata = userinputdataset('Test Data','Test Data Filename?:');

% Initialize Parameters to Random Values
nrtargets = trainingdata.nrtargets
inputvectordim = trainingdata.inputvectordim;
nrvars = trainingdata.nrvars;
initialwtmag = constants.initialconditions.wtsdev;
wmatrix = initialwtmag * randn(nrtargets,nrvars-nrtargets);
parameters = wmatrix(:);

% Start Descent Algorithm
performancehistory = [];

[parameters,performancehistory] = sazwdescent(trainingdata,parameters,performancehistory,constants);
disp('-------------------------------------------');

% TRAINING DATA (Final Pass)
disp('TRAINING DATA RESULTS:');
trainingsazout = computesazwoutputstats(parameters,constants,trainingdata);
displaysazwresults(trainingsazout);

% TEST DATA (Final Pass)
disp(' ');
disp('TEST DATA RESULTS:');
testingsazout = computesazwoutputstats(parameters,constants,testingdata);
displaysazwresults(testingsazout);



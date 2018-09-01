function constants = defaultconstants;
% USAGE: constants = defaultconstants;

% Display Copyright Info
copyrightinfo;

% Setup Stepsize Search Constants
constants.stepsizesearch.checkwolfe.alpha = 1e-8; % choose to be close to 0
constants.stepsizesearch.checkwolfe.beta = 0.99; % choose to be close to 1
constants.stepsizesearch.scaleddecreasefactor = 0.5; % number between 0 and 1 (larger means more function evaluations)
constants.stepsizesearch.useminstepsize = 0; % if this is zero then we use quadratic-chosen stepsize that fails Wolfe (riskier stepsize choice)
constants.stepsizesearch.alpha = constants.stepsizesearch.checkwolfe.alpha/1000;
constants.stepsizesearch.minstepsize = 0.001; % used when you cant find a good stepsize
% ----Keep the maximum number of stepsize iterations large and adjust number of
% ----stepsize iterations indirectly by modified "scaleddecreasefactor"
constants.stepsizesearch.maxiterations = 100; 
constants.stepsizesearch.manualstepsize = 0.1;
constants.stepsizesearch.autostepsizemode = 1; % 1=on, 0=off
constants.stepsizesearch.displaydiagnostics = 0;  % DISPLAY STEPSIZE DIAGNOSTICS 0=off, 1= on

% Setup Stochastic Approximation Constants
constants.sa.on = 0; % 0=turn off stochastic approximation; 1 = turn on;
constants.sa.eventsperupdate = 40; % size of random sample ranges from 1 to nrevents
constants.sa.initialstepsize =constants.stepsizesearch.manualstepsize; % initial value of stepsize
constants.sa.initialconstanttimeperiod = 2; % Stepsize is constant for this initial time period
constants.sa.searchstepsizehalflife = 5; % Double Stepsize in this many iterations initially
constants.sa.convergestepsizehalflife = 80; % Stepsize Halflife should be order of magnitude of number of exemplars

% Inference Assumptions
constants.inference.maxcondnum = 1e+12;

% Stopping Criteria
constants.stoppingcriteria.maxiterations = 5000; 

% Setup SAZWDESCENT Stopping Criteria Constants
constants.stoppingcriteria.gradmax = 1e-6;
constants.stoppingcriteria.diffxmax = 1e-12;

% Setup MetropolisHastings Stopping Criteria Constants
constants.stoppingcriteria.moveavgtime = 30; % iterations
constants.stoppingcriteria.maxmoveavgdiff = 0.001;
constants.stoppingcriteria.miniterations = 500;

% Setup MetropolisHastings Temperature Control
constants.temperature.initial = 1.0;
constants.temperature.scaleddecrease = 0.9; % when set to 1.0 temperature doesnt decrease
constants.temperature.final = 0.10;

% SELECT SAZWDESCENT SEARCH DIRECTION STRATEGY
% "gradient","newton","levenbergmarquardt","polakribiere","fletcherreeves","Lbfgs"
constants.searchdirection.levenbergmarquardt.mineigvalue = 1e-3;
constants.searchdirection.bfgs.innercycles = 5; % Should be number of parameters or less
constants.searchdirection.mincosinesearchangle = cosd(88); % 88 degrees minimum angle
constants.searchdirection.searchoption = 'gradient';

% SETUP DISPLAY PROGRESS SCREEN CONSTANTS
% ---Set Display Window Size ('small','medium','large')
constants = resizedisplay('medium',constants);
% ---Helps graphics display keep up with processor and helps control-c break
constants.displayprogress.displaytime = 0.05; 
% ---Set minimum and maximum values for the color legend in the color plots
constants.displayprogress.predictionerror.colorrange = [-0.5 0.5];
constants.displayprogress.statevector.colorrange = [-2 +2];
constants.displayprogress.AxisFontSize = 9;
constants.displayprogress.DisplayBinaryStates = 1;

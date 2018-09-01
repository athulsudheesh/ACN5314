function constants = defaultconstants;
% USAGE: constants = defaultconstants;

% Display Copyright Info
copyrightinfo;

% Select Adaptive or Batch mode
constants.sa.on = 1; % Stochastic Approximation ON
%constants.sa.on = 0; % Stochastic Approximation OFF
    
% Constants initial weight magnitude
constants.initialwtmag = 1;

% Stopping Criteria Number of iterations
constants.stoppingcriteria.maxiterations = 1000;

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
constants.stepsizesearch.manualstepsize = 1;
constants.stepsizesearch.autostepsizemode = 1; % 1=on, 0=off
constants.stepsizesearch.displaydiagnostics = 0;  % DISPLAY STEPSIZE DIAGNOSTICS 0=off, 1= on

% Setup Stochastic Approximation Constants
% constants.sa.on = 1; % 0=turn off stochastic approximation; 1 = turn on;
% constants.sa.eventsperupdate = 50; % size of random sample ranges from 1 to nrevents
constants.sa.initialstepsize =0.01*constants.stepsizesearch.manualstepsize; % initial value of stepsize
constants.sa.initialconstanttimeperiod = 2; % Stepsize is constant for this initial time period
maxiterations = constants.stoppingcriteria.maxiterations;
constants.sa.searchstepsizehalflife = maxiterations/2; % Double Stepsize in this many iterations initially
constants.sa.convergestepsizehalflife = maxiterations; % Stepsize Halflife should be at least order of magnitude of number of exemplars
constants.sa.eventsperupdate = 5;

% Setup SAZWDESCENT-SPECIFIC Stopping Criteria Constants
constants.stoppingcriteria.gradmax = 1e-6;
constants.stoppingcriteria.diffxmax = 1e-12;

% Setup MetropolisHastings-SPECIFIC Stopping Criteria Constants
constants.stoppingcriteria.moveavgtime = 10; % iterations
constants.stoppingcriteria.maxmoveavgdiff = 0.001;
constants.stoppingcriteria.miniterations = 100;

% Setup MetropolisHastings Temperature Control
constants.temperature.initial = 1.0;
constants.temperature.scaleddecrease = 0.5;
constants.temperature.final = 0.10;

% SELECT SAZWDESCENT SEARCH DIRECTION STRATEGY
%SEARCH DIRECTION OPTIONS: 
%   "gradient","newton","levenbergmarquardt","polakribiere","fletcherreeves","Lbfgs","momentumbound","momentumgrad","momentumdirection"
constants.searchdirection.levenbergmarquardt.mineigvalue = 1e-9;
constants.searchdirection.bfgs.innercycles = 5;
constants.searchdirection.mincosinesearchangle = cosd(88) % 88 degrees minimum angle
constants.searchdirection.searchoption = 'gradient';
constants.searchdirection.momentumconstant = 0.6;
constants.searchdirection.searchdirectionmaxval = 1.0;

% SETUP DISPLAY PROGRESS SCREEN CONSTANTS
% Set Display Window Size ('small','medium','large')
constants = resizedisplay('medium',constants);

% seconds program pauses before screen is displayed
constants.displayprogress.displaytime = 0.01; 
% Helps graphics display keep up with processor and helps control-c break

% INFERENCE TOOLBOX CONSTANTS
constants.inference.maxcondnum = 1e+15;

% Set the minimum and maximum values for the color legend in the color plots
% FOR SAZW DISPLAY
constants.displayprogress.predictionerror.colorrange = [-0.5 0.5];
constants.displayprogress.statevector.colorrange = [-2 +2];

% METROPOLIS DISPLAY CONSTANTS
constants.displayprogress.DisplayBinaryStates = 1;

end


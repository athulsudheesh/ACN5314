function constants = sazwdefaultconstants;
% USAGE: constants = sazwdefaultconstants;

% Display Copyright Info
copyrightinfo;

% Setup Constants for Initial Weights
constants.initialconditions.wtsdev = 0.001;

% Setup Stepsize Search Constants
constants.wolfestep.alpha = 1e-8; % choose to be close to 0
constants.wolfestep.beta = 0.99; % choose to be close to 1
constants.wolfestep.decreasefactor = 0.5; % number between 0 and 1 (larger means more function evaluations)
constants.wolfestep.useminstepsize = 'Use Minimum Stepsize'; % if this is zero then we use quadratic-chosen stepsize that fails Wolfe (riskier stepsize choice)
constants.wolfestep.minstepsize = 0.001; % used when you cant find a good stepsize
% ----Keep the maximum number of stepsize iterations large and adjust number of
% ----stepsize iterations indirectly by modified "scaleddecreasefactor"
constants.wolfestep.maxiterations = 100; 
constants.wolfestep.initialstepsize = 0.01;
constants.wolfestep.displaydiagnostics = 0;  % DISPLAY STEPSIZE DIAGNOSTICS 0=off, 1= on

% Setup Stochastic Approximation Constants
constants.optimizemethod.adaptivelearning = 'Adaptive (on-line)'; % 0=turn off stochastic approximation; 1 = turn on;
constants.optimizemethod.percenteventsperupdate = 40; % percentage of full data set for mini-batch sample size
constants.adaptivestep.initialstepsize =0.5; % initial value of stepsize
constants.adaptivestep.initialconstanttime = 2; % Stepsize is constant for this initial time period
constants.adaptivestep.searchhalflife = 5; % Double Stepsize in this many iterations initially
constants.adaptivestep.convergehalflife = 80; % Stepsize Halflife should be order of magnitude of number of exemplars

% Stopping Criteria
constants.stoppingcriteria.maxiterations = 500; 

% Setup SAZWDESCENT Stopping Criteria Constants
constants.stoppingcriteria.gradmax = 1e-4;
constants.stoppingcriteria.diffmax = 1e-12;

% SELECT SAZWDESCENT SEARCH DIRECTION STRATEGY
% "gradient","newton","levenbergmarquardt","polakribiere","fletcherreeves","Lbfgs","momentumbound","momentumgrad"
constants.optimizemethod.levenmarqeigvalue = 1e-3;
constants.optimizemethod.innercycles = 5; % Should be number of parameters or less
constants.optimizemethod.maxsearchdev = cosd(88) % 88 degrees minimum angle
%constants.optimizemethod.searchdirection = 'levenbergmarquardt';
constants.optimizemethod.momentumconstant = 0.5; % momentum constant;
constants.optimizemethod.searchdirectionmaxnorm = 10; 

% SETUP DISPLAY PROGRESS SCREEN CONSTANTS
% Set Display Window Size ('small','medium','large')
constants = resizedisplay('medium',constants);

% seconds program pauses before screen is displayed
constants.displayprogress.displaytime = 0.05; 
% Helps graphics display keep up with processor and helps control-c break
constants.displayprogress.displayon = 'Display Off';

% Set the minimum and maximum values for the color legend in the color plots
constants.displayprogress.predictionerror.colorrange = [-0.5 0.5];
constants.displayprogress.statevector.colorrange = [-2 +2];

end


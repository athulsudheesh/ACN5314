function constants = updatesazwconstants;
% USAGE: constants = updatesazwconstants;

if exist('constantvalues.mat'),
    load('constantvalues.mat');
    setdefaultvalues = 0;
    disp('File "constantvalues.mat" not found. Using Default Values.');
else
    setdefaultvalues = 1;
    disp('File "constantvalues.mat" found. Loading Current Values.');
end;

% Model Structure
varprompt.model.targettype = 'Response Function?:';
varprompt.model.penaltytermweight = 'Regularization Term Weighting Factor?:';
varprompt.model.elasticweightL2percent = 'Percent L2 for Elastic Net? (0-100):';
varprompt.model.nrhidden = 'Number of Hidden Units?:';
varprompt.model.weightdensity = 'Percent Non-Zero Connections?:';
varprompt.model.temperature = 'Temperature?:';
varprompt.model.funkfilename = 'Objective Function Filename (.m file)?:';
varprompt.model.gradfilename = 'Gradient Function Filename (.m file)?:';
varprompt.model.hessfilename = 'Hessian Function Filename (.m file)?:';
varprompt.model.hunittype = 'Hidden Unit Type?:';
varprompt.model.regularizetype = 'Regularization Term Type?:';
varprompt.model.SoftL1epsilon = 'Epsilon for Soft L1 Regularization?:';

%vartype.model.targettype = {'Logistic','Linear','Softmax'};
vartype.model.targettype = {'Logistic','Linear'};
vartype.model.hunittype = {'Sigmoidal','Softplus','Linear'};
vartype.model.regularizetype = {'None','SoftL1','L2','Elastic'};
vartype.model.SoftL1epsilon = {[0,1]};
vartype.model.elasticweightL2percent = {[0,100]};
vartype.model.penaltytermweight ={[0,inf]};
vartype.model.nrhidden = {[0,inf]};
vartype.model.weightdensity = {[0,100]};
vartype.model.temperature = {[0,inf]};
vartype.model.funkfilename = {};
vartype.model.gradfilename = {};
vartype.model.hessfilename = {};

if setdefaultvalues,
    constants.model.targettype = 'Logistic';
    constants.model.hunittype = 'Softplus';
    constants.model.penaltytermweight = 0.001;
    constants.model.nrhidden = 50;
    constants.model.weightdensity = 10;
    constants.model.temperature = 1.0;
    constants.model.funkfilename = 'objfunction';
    constants.model.gradfilename = 'gradobjfunction';
    constants.model.hessfilename = 'hessobjfunction';
    constants.model.regularizetype = 'SoftL1';
    constants.model.SoftL1epsilon = 1e-3;
    constants.model.elasticweightL2percent = 50;
end;

% Update Model Constants Structure
constants.model = userinputconstants('MODEL',constants.model,vartype.model,varprompt.model);

% Initial Conditions
vartype.initialconditions.wtsdev = {[0,inf]};
varprompt.initialconditions.wtsdev = 'Initial Weight Standard Deviation:?';
constants.initialconditions.wtsdev = 0.1;
constants.initialconditions = ...
    userinputconstants('Initialization',constants.initialconditions,vartype.initialconditions,varprompt.initialconditions);

% Optimization Strategy
varprompt.optimizemethod.adaptivelearning = 'Learning Mode?:';
varprompt.optimizemethod.searchdirection = 'Search Direction?:';
varprompt.optimizemethod.innercycles = 'Number of Inner Cycles?:';
varprompt.optimizemethod.maxsearchdev = 'Angular Deviation from Gradient?:';
varprompt.optimizemethod.momentumconstant = 'Momentum Constant?:';
varprompt.optimizemethod.searchdirectionmaxnorm = 'Maximum Search Direction Norm?:';
varprompt.optimizemethod.percenteventsperupdate = 'Mini-Batch Size Percentage?:';
%varprompt.optimizemethod.autostepsizemode = 'Automatic Stepsize Adjustment?:';
varprompt.optimizemethod.levenmarqeigvalue = 'Minimum Eigenvalue (Levenberg-Marquardt)?:';

vartype.optimizemethod.adaptivelearning = {'Adaptive (on-line)','Batch (off-line)'};
vartype.optimizemethod.searchdirection = ...
    {'gradient','momentumbound','momentum2direction','momentumdirection',...
    'newton','levenbergmarquardt','Lbfgs','polakribiere',...
    'fletchereeves'};
vartype.optimizemethod.innercycles = {[1,inf]};
vartype.optimizemethod.maxsearchdev = {[-1,1]};
vartype.optimizemethod.momentumconstant = {[0,inf]};
vartype.optimizemethod.searchdirectionmaxnorm = {[0,inf]};
vartype.optimizemethod.percenteventsperupdate = {[0,100]};
%vartype.optimizemethod.autostepsizemode = {'Auto-Stepsize','Constant-Stepsize'};
vartype.optimizemethod.levenmarqeigvalue = {[0,inf]};

if setdefaultvalues,
    constants.optimizemethod.adaptivelearning = 'Adaptive (on-line)';
    constants.optimizemethod.searchdirection = 'momentumdirection';
    constants.optimizemethod.innercycles = 5;
    constants.optimizemethod.maxsearchdev = cosd(88); %% 88 degrees
    constants.optimizemethod.momentumconstant = 0.6;
    constants.optimizemethod.searchdirectionmaxnorm = 1.0;
    constants.optimizemethod.percenteventsperupdate = 80;
%    constants.optimizemethod.autostepsizemode = 'Auto-Stepsize';
    constants.optimizemethod.levenmarqeigvalue = 1e-4;
end;

constants.optimizemethod = ...
    userinputconstants('Optimize Method',constants.optimizemethod,vartype.optimizemethod,varprompt.optimizemethod);

% Wolfe Stepsize
vartype.wolfestep.initialstepsize = {[0,inf]};
vartype.wolfestep.maxiterations = {[0,inf]};
vartype.wolfestep.alpha = {[0,1]};
vartype.wolfestep.beta = {[0,1]};
vartype.wolfestep.decreasefactor = {[0,1]};
vartype.wolfestep.useminstepsize = {'Use Minimum Stepsize','Dont Use Minimum Stepsize'};
vartype.wolfestep.minstepsize = {[0,inf]};

varprompt.wolfestep.initialstepsize = 'Wolfe Initial Stepsize?:';
varprompt.wolfestep.maxiterations = 'Wolfe Maximum Stepsize Iterations?:';
varprompt.wolfestep.alpha = 'Wolfe ALPHA?:';
varprompt.wolfestep.beta = 'Wolfe BETA?:';
varprompt.wolfestep.decreasefactor = 'Wolfe Decrease?:';
varprompt.wolfestep.useminstepsize = 'Minimum Stepsize?:';
varprompt.wolfestep.minstepsize = 'Minimum Stepsize Value?:';

if setdefaultvalues,
    constants.wolfestep.initialstepsize = 0.1;
    constants.wolfestep.maxiterations = 100;
    constants.wolfestep.alpha = 1e-8; % choose close to 0
    constants.wolfestep.beta = 0.99; % choose close to 1
    constants.wolfestep.decreasefactor = 0.5; % larger means more function evals
    constants.wolfestep.useminstepsize = 'Use Minimum Stepsize';
    constants.wolfestep.minstepsize = 1e-5;
end;

constants.wolfestep = userinputconstants('WOLFE STEP',constants.wolfestep,vartype.wolfestep,varprompt.wolfestep);


% Stochastic Approximation Stepsize
vartype.adaptivestep.maxiterations = {[0,inf]};
vartype.adaptivestep.initialstepsize = {[0,1]};
vartype.adaptivestep.initialconstanttime = {[0,inf]};
vartype.adaptivestep.searchhalflife = {[0,inf]};
vartype.adaptivestep.convergehalflife = {[0,inf]};

varprompt.adaptivestep.maxiterations = 'Maximum Number of Learning Trials?:';
varprompt.adaptivestep.initialstepsize = 'Adaptive Initial Stepsize?:';
varprompt.adaptivestep.initialconstanttime = 'Constant Stepsize Period?:';
varprompt.adaptivestep.searchhalflife = 'Search Stepsize Period (half-life)?:';
varprompt.adaptivestep.convergehalflife = 'Converge Stepsize Period (half-life)?:';

if setdefaultvalues,
    constants.adaptivestep.maxiterations = 300;
    constants.adaptivestep.initialstepsize = 0.01;
    constants.adaptivestep.initialconstanttime = 20;
    constants.adaptivestep.searchhalflife = constants.adaptivestep.maxiterations/4;
    constants.adaptivestep.convergehalflife = constants.adaptivestep.maxiterations/2;
end;

constants.adaptivestep = userinputconstants('ADAPTIVE STEP',constants.adaptivestep,vartype.adaptivestep,varprompt.adaptivestep);

% Stopping Criteria
vartype.stoppingcriteria.maxiterations = {[0,inf]};
vartype.stoppingcriteria.gradmax = {[0,inf]};
vartype.stoppingcriteria.diffmax = {[0,inf]};

varprompt.stoppingcriteria.maxiterations = 'Maximum Iterations (Parameter Updates)?:';
varprompt.stoppingcriteria.gradmax = 'Infinity Gradient Norm (Stopping Criteria)?:';
varprompt.stoppingcriteria.diffmax = 'Change in Parameter Values (Stopping Criteria)?:';

if setdefaultvalues,
    constants.stoppingcriteria.maxiterations = 300;
    constants.stoppingcriteria.gradmax = 1e-4;
    constants.stoppingcriteria.diffmax = 1e-12;
end;

constants.stoppingcriteria = ...
    userinputconstants('STOPPING CRITERIA',constants.stoppingcriteria,vartype.stoppingcriteria,varprompt.stoppingcriteria);

% Display Constants
vartype.displayprogress.displaysize = {'small','medium','large'};
vartype.displayprogress.displaytime = {[0,inf]};
vartype.displayprogress.interprethreshold = {[0,inf]};
vartype.displayprogress.predictionerrorcolor = {[]};
vartype.displayprogress.statevectorcolor = {[]};
vartype.displayprogress.displayon = {'Display On','Display Off'};
% vartype.displayprogress.positionvector = {[]};

varprompt.displayprogress.displaysize = 'Display Screen Size?:';
varprompt.displayprogress.displaytime = 'Display Delay Time?:';
varprompt.displayprogress.interprethreshold = 'Interpretation Threshold?:';
varprompt.displayprogress.predictionerrorcolor = 'Color Scheme (Predict)?:';
varprompt.displayprogress.statevectorcolor = 'Color Scheme (State Vector)?:';
varprompt.displayprogress.displayon = 'Turn off Display?:';

if setdefaultvalues,
    constants.displayprogress.displaysize = 'large';
    constants.displayprogress.displaytime = 0.10;
    constants.displayprogress.interprethreshold = 0.1;
    constants.displayprogress.predictionerrorcolor = [-0.5 0.5];
    constants.displayprogress.statevectorcolor = [-2 +2];
    constants.displayprogress.displayon = 'Display-On';
end;

constants.displayprogress = ...
    userinputconstants('DISPLAY',constants.displayprogress,vartype.displayprogress,varprompt.displayprogress);

displaychoice = constants.displayprogress.displaysize;
constants = resizedisplay(displaychoice,constants);

save('constantvalues.mat','constants');
disp('Updated Constants Saved to "constantvalues.mat"');


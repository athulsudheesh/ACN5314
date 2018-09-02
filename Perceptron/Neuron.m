classdef Neuron
    % Linear Regression Class
    properties
        constants;
    end
    
    methods (Static)
        function constants = Initialize(StepSize, SearchDirection,StepSizeMode,...
                hidden_units, output_response_function, hidden_unit_function)
%           Model Structure 
            constants.model.targettype = output_response_function;
            constants.model.hunittype = hidden_unit_function;
            constants.model.penaltytermweight = 0.001;
            constants.model.nrhidden = hidden_units;
            constants.model.weightdensity = 10;
            constants.model.temperature = 1;
            constants.model.funkfilename = 'objfunction';
            constants.model.gradfilename = 'gradobjfunction';
            constants.model.hessfilename = 'hessobjfunction';
            constants.model.regularizetype = 'SoftL1';
            constants.model.SoftL1epsilon = 1e-3;
            constants.model.elasticweightL2percent = 50;
            
%           Initial Weight Condition 
            constants.initialconditions.wtsdev = 0.1;
            
%           Optimization Strategy 
            constants.optimizemethod.adaptivelearning = 'Batch (off-line)';         % Learning Mode
            constants.optimizemethod.searchdirection = SearchDirection;          % Search Method
            constants.optimizemethod.innercycles = 5;       % No. of inner cycles
            constants.optimizemethod.maxsearchdev = cosd(88); %% 88 degrees         Angular Deviation from Gradient?
            constants.optimizemethod.momentumconstant = 0.6;
            constants.optimizemethod.searchdirectionmaxnorm = 1.0;                  % Maximum Search Direction Norm
            constants.optimizemethod.percenteventsperupdate = 80;

            constants.optimizemethod.autostepsizemode = StepSizeMode;
            constants.optimizemethod.levenmarqeigvalue = 1e-4;
    
%            Step-size for Batch Learning
            constants.wolfestep.initialstepsize = StepSize;
            constants.wolfestep.maxiterations = 100;
            constants.wolfestep.alpha = 1e-8; % choose close to 0
            constants.wolfestep.beta = 0.99; % choose close to 1
            constants.wolfestep.decreasefactor = 0.5; % larger means more function evals
            constants.wolfestep.useminstepsize = 'Use Minimum Stepsize';
            constants.wolfestep.minstepsize = 1e-5;
    
%           Stepsize for Adaptive Learning
            constants.adaptivestep.maxiterations = 300;
            constants.adaptivestep.initialstepsize = 0.01;
            constants.adaptivestep.initialconstanttime = 20;
            constants.adaptivestep.searchhalflife = constants.adaptivestep.maxiterations/4;
            constants.adaptivestep.convergehalflife = constants.adaptivestep.maxiterations/2;

%           Stopping Criteria
            constants.stoppingcriteria.maxiterations = 300;
            constants.stoppingcriteria.gradmax = 1e-4;
            constants.stoppingcriteria.diffmax = 1e-12;
            
%           Display Options
            constants.displayprogress.displaysize = "medium";
            constants.displayprogress.displaytime = 0.10;
            constants.displayprogress.interprethreshold = 0.1;
            constants.displayprogress.predictionerrorcolor = [-0.5 0.5];
            constants.displayprogress.statevectorcolor = [-2 +2];
            constants.displayprogress.displayon = "Display On";
            
            constants.displayprogress.TitleFontSize = 14 ;
            constants.displayprogress.AxisFontSize = 13 ;
            constants.displayprogress.MarkerSizeValue = 4;
            constants.displayprogress.BigMarkerSizeValue = 7;
            constants.displayprogress.LineWidthValue = 2;
            constants.displayprogress.BigLineWidthValue = 5 ;
            constants.displayprogress.PositionVector = [600,152,1169,889];
            
            
        end
        % Function to initiate model training
        function [parameters,performancehistory, sazout, varnames] = train(trainingdata, constants)
            performancehistory = [];
            [parameters,constants] = w_update(trainingdata,constants);
            [parameters,performancehistory, sazout, varnames] = sazwdescent_Perceptron(trainingdata,parameters,performancehistory,constants);
        end
        % Function to display Model Statistics 
        function display_statistics(performancehistory, sazout)
            usermessage = strvcat(...
    ['Number of iterations = ',num2str(performancehistory.numberiterations)],...
    ['Objective Function Value = ',num2str(performancehistory.finalobjfunctionval)],...
    ['Gradient Infinity Norm (convergence criteria) = ',num2str(performancehistory.finalgradval)]);
    if ~isnan(sazout.condnumhessian),
        usermessage = strvcat(usermessage,...
        ['Hessian Condition Number (local minimum test) = ',num2str(sazout.condnumhessian)],...
         ['Largest Eigenvalue = ',num2str(sazout.maxhesseig)]);
    end;
    disp('----------------------------Model Statistics------------------------------');
    disp('  ');
    disp(usermessage);
    disp('  ');
    disp('  ');
    disp('----------------------Model Misspecification Check------------------------');
    disp('  ');
    disp(['Information Matrix Scores:']);
    disp(['OPG Condition Number = ',num2str(sazout.condnumopg)])
      disp(['Hessian Condition Number = ',num2str(sazout.condnumhessian)]);
    disp(['tr(inv(a)b) = ',num2str(performancehistory.traceainvb),', ',...
            'tr(inv(b)a) = ',num2str(performancehistory.tracebinva),', ',...
            'det(inv(a)b) = ',num2str(performancehistory.detainvb)]);
        disp(' ');
    disp('--------------------------------------------------------------------------');
        end
        % Function to Display Parameter estimates
        function parameter_estimates(sazout, varnames, parameters)
            disp(' ');
    nrbetas = length(sazout.stderrors);
    betavector = parameters;
    betaerrors = sazout.stderrors;
    nrpredictorlabels = length(varnames) - sazout.nrtargets;
    for betaindex = 1:nrpredictorlabels,
        betalabel = varnames{betaindex+sazout.nrtargets};
        betazscore = betavector(betaindex)/(betaerrors(betaindex) + eps);
        thepvalue = 1 - gammainc((betazscore)^2/2,1/2); %2-sided confidence interval
        disp([betalabel,' Beta = ',num2str(betavector(betaindex)),...
           ', Z=',num2str(betazscore),', p=',num2str(thepvalue)]);
    end;
        end
        function predict(parameters,constants,trainingdata)
            finalsazout = computesazwoutputstats(parameters,constants,trainingdata);
            displaysazwresults(finalsazout);
        end 
    end
end



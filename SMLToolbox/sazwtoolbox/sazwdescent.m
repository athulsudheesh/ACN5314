function [xt,performancehistory] = sazwdescent(thedata,parameters,performancehistory,constants);
% USAGE: [xt,performancehistory] = sazwdescent(thedata,parameters,performancehistory,constants);

%-----------------------------------------------------------------------------
% STATISTICAL MACHINE LEARNING TOOLKIT
%
%Copyright 2013-2017  RMG Consulting, Incorporated
%
%Licensed under the Apache License, Version 2.0 (the "License");
%you may not use this file except in compliance with the License.
%You may obtain a copy of the License at
%
%       http://www.apache.org/licenses/LICENSE-2.0
%
%Unless required by applicable law or agreed to in writing, software
%distributed under the License is distributed on an "AS IS" BASIS,
%WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%See the License for the specific language governing permissions and
%limitations under the License.
%
% This License refers to all software located in the current directory
% which includes the directories: "SMLalgorithms", "Perceptron",
% "LinearMachine", "LSI-SVD", "ModelSearch", "npbootgaic", "pbootgbic".
% The directory "SMLalgorithms" includes the directories:
% "smlutilities", "inferencetoolbox", "mhtoolbox", "modelselectbox", and "sazwtoolbox".
% The directory "sazwtoolbox" includes the programs:
%  autosearchdirection,autostepsize,checkwolfe,sazwdescent,sazwdisplayprogress,
%  as well as the other directories: "fsmlutilities", "inferencetoolbox", "mhtoolbox".
%
%Please see the unpublished book manuscript entitled
%"Statistical Machine Learning"
%by Richard M. Golden (Ph.D., M.S.E.E.,B.S.E.E.) for details regarding the
%design and analysis of the algorithms in this software package.
%
% "RMG Consulting, Incorporated" is located in Allen, TX 75013
% Email: rmgconsult2010@gmail.com
%
% Tutorial videos, software updates, and software bug fixes located at: 
% www.learningmachines101.com
%-------------------------------------------------------------------------------


% Display Copyright Information
%copyrightinfo;

% Setup Figure Window
displayon = strcmp(constants.displayprogress.displayon,'Display On');
if displayon,
    fighandle = figure;
%     DisplayPositionVector = constants.displayprogress.PositionVector;
%     set(fighandle,'Position',DisplayPositionVector);
    set(fighandle,'numbertitle','off');
end;

% Calculate Display Constants
isadaptivelearning = strcmp(constants.optimizemethod.adaptivelearning,'Adaptive (on-line)'); 
if isadaptivelearning,
    descentalgorithmtypedisplay = 'Stochastic Approximation';
else
    descentalgorithmtypedisplay = 'Zoutendijk-Wolfe';
end;

% Function DEFINITIONS
hessfilename = ''; 
funkfilename = constants.model.funkfilename;
gradfilename = constants.model.gradfilename;
if isfield(constants.model,'hessfilename'),
    hessfilename = constants.model.hessfilename;
end;

% opmethod structure
opmethod = constants.optimizemethod;

% DATA SET
eventhistory = thedata.eventhistory;
[nrevents,nrvars] = size(eventhistory);
varnames = thedata.varnames; % RMG 6/12/2018
nrtargets = thedata.nrtargets; % RMG 6/12/2018

% SEARCH 
maxsearchdev = opmethod.maxsearchdev;
searchdirectionmaxnorm = opmethod.searchdirectionmaxnorm;
maxinnercycles = opmethod.innercycles;
searchdirection = opmethod.searchdirection;

% STOPPING CRITERIA
maxiterations = constants.stoppingcriteria.maxiterations;
gradmax =  constants.stoppingcriteria.gradmax;
diffxmax = constants.stoppingcriteria.diffmax;
NUMERICALZERO = 1e-5*gradmax*gradmax;

% AUTOSTEPSIZE CONTROLS
adaptivestep = constants.adaptivestep;
adaptiveinitialstep = adaptivestep.initialstepsize;
initialconstanttime = adaptivestep.initialconstanttime;
searchhalflife = adaptivestep.searchhalflife;
convergehalflife = adaptivestep.convergehalflife;

% INITIAL PARAMETER VALUE GUESS
initialstate = parameters;

% INITIALIZE PERFORMANCE HISTORY
if ~isempty(performancehistory),
    angulardeviationhistory = performancehistory.angulardeviationhistory;
    wolfestepsizehistory.suffdecreaseError = performancehistory.wolfestepsizehistory.suffdecreaseError;
    wolfestepsizehistory.suffdecreaseSlope = performancehistory.wolfestepsizehistory.suffdecreaseSlope;
    gradvalhistory = performancehistory.gradvalhistory;
    objfunctionhistory = performancehistory.objfunctionhistory;
    predicterrormx = performancehistory.predicterrormx;
    stepsizehistory = performancehistory.stepsizehistory;
else
    angulardeviationhistory = [];
    wolfestepsizehistory.suffdecreaseError = [];
    wolfestepsizehistory.suffdecreaseSlope = [];
    gradvalhistory = [];
    objfunctionhistory = [];
    predicterrormx = [];
    stepsizehistory = [];
end;
iteration = length(gradvalhistory);
maxiterations = maxiterations + iteration;

% Start Descent Algorithm
keepgoing = 1; fighandle = []; xt = initialstate;
dt = []; gtlast = []; dtlast = []; stepsizelast = []; 
percenteventsupdate = constants.optimizemethod.percenteventsperupdate;
eventsperupdate = max([1,round(percenteventsupdate * nrevents/100)]);
searchdirection = constants.optimizemethod.searchdirection;
innercycleid = 0; stepsize = 1;
while keepgoing,
    % If stochastic approximation mode is on, then 
    % take a random subsample of the data set
    getnewrandomsample = isadaptivelearning & (innercycleid == 0);
    if getnewrandomsample,
        permutedeventids = randperm(nrevents);
        selectedeventids = permutedeventids(1:eventsperupdate);
        sampleeventhistory = eventhistory(selectedeventids,:);
        constants.data.eventhistory = sampleeventhistory;
    end;
    
    % Compute Current Gradient gt if necessary
    if (iteration == length(gradvalhistory) | getnewrandomsample),
        [gt,gmx] = feval(gradfilename,xt,constants,thedata);
    end;
    
    % Update Iteration 
    iteration = iteration + 1;
    
    % Compute Hessian if Necessary
    hesst = [];
    if ismember(searchdirection,{'newton','levenbergmarquardt'}),
        if ~exist('hessobjfunction.m'),
            warnmessage = warndlg(['Aborting! The file "',hessfilename,'" can not be found!']);
            waitfor(warnhandle);
            quit;
        end;
        hesst = feval(hessfilename,xt,constants,thedata);
    end;
    
    % Compute Search Direction
    [dt,innercycleid] = autosearchdirection(innercycleid,xt,dtlast,gt,gtlast,hesst,stepsizelast,constants);
    
    % Compute Angular Deviation from Current Gradient
    % and RESET SEARCH DIRECTION if necessary
    cosineangle = 0;
    directionnorm = norm(dt);
    gradnorm = norm(gt);
    cosineangle = -(gt/(gradnorm+NUMERICALZERO))'*(dt/(directionnorm+NUMERICALZERO));
    if (cosineangle <= maxsearchdev) & ~isadaptivelearning, % RESET SEARCH DIRECTION
        dt = -gt; cosineangle = 1;
    end;
    angulardeviation = real(acosd(cosineangle));

    % Compute Stepsize
    stepsizelast = stepsize;
    if ~isadaptivelearning;
        stepsize = constants.wolfestep.initialstepsize;
        [stepsize,Vbest,stepcycles] = autostepsize(xt,dt,constants,thedata);
    else
        stepsize = constants.adaptivestep.initialstepsize;
        stepcycles = 1; % number of stepsize cycles is one
        if ~isadaptivelearning, stepsize = constants.wolfe.initialstepsize;
        else % --- Begin stepsize adjustment for stochastic approximation
            if (iteration <= initialconstanttime),
                stepsize = constants.adaptivestep.initialstepsize;
            else
                tau1 = searchhalflife;
                tau2 = convergehalflife;
                stepsize0 = adaptivestep.initialstepsize;
                iter = round(iteration/maxinnercycles)*maxinnercycles;  % NEEDS TO BE RE-EXAMINED THIS STEP!!!!
                stepsize = stepsize0 * (1+(iter/tau1))/(1+(iter/tau2)^2);
            end;
            %------- End of Stepsize Adjustment for Stochastic
            %Approximation
        end;
    end;
    
    % Check Wolfe conditions if not stochastic approximation mode
    if ~isadaptivelearning,
        stepsizestatus = checkwolfe(xt,dt,stepsize,constants,thedata);
    end;
    
    % Update System State
    lastxt = xt;
    xt = xt + stepsize*dt;
    
    % Decide Whether to Keep Iterating or to Stop Algorithm
    if (iteration == 1),
        diffx = inf;
    else
        diffx = max(abs(lastxt - xt));
    end;
    
    % Save current search statistics in case we 
    % need them
    gtlast = gt;
    dtlast = dt;
    stepsizelast = stepsize;
    
    % Re-evaluate the Gradient for stopping criteria at NEW STATE
    % using CURRENT RANDOM SAMPLE
    [gt,gmx] = feval(gradfilename,xt, constants,thedata);
    gradval = max(abs(gt));
    smallstatechange = (diffx <= diffxmax);
    smallgradval = (gradval <= gradmax);
    if ~isadaptivelearning,
        hasconverged = smallstatechange | smallgradval;
    else
        hasconverged = smallgradval;
    end;
    
    % Report Wolfe Stepsize Status if Necessary
    if ~isadaptivelearning & displayon,
        if ~stepsizestatus.wolfestepsize, 
            disp(['Iteration #',num2str(iteration),', Wolfe Test Failed!',...
                ', Sufficient Error Decrease = ',num2str(stepsizestatus.suffdecreaseError),...
                ', Sufficient Slope Decrease = ',num2str(stepsizestatus.suffdecreaseSlope)]);
        end;
    end;
    
    % Display Error and Gradmax
    [objfunctionval,predicterrormx,predictedresponses] = feval(funkfilename,xt, constants,thedata);
    if isadaptivelearning, samode = 'SA-'; else samode = ''; end;
    if displayon,
        searchoptiondisplay = [samode,searchdirection];
        disp(['Iteration (',searchoptiondisplay,') #',num2str(iteration),...
        ', Inner-Cycle = ',num2str(innercycleid),...
        ', Stepsize-Cycle = ',num2str(stepcycles),...
        ', Stepsize = ',num2str(stepsize),...
        ', Error = ',num2str(objfunctionval),', |grad| = ',num2str(gradval),...
        ', Angle = ',num2str(angulardeviation),' degrees']);
    end;
    
    % Collect Historical Data
    if ~isadaptivelearning,
        wolfestepsizehistory.suffdecreaseError = [wolfestepsizehistory.suffdecreaseError; stepsizestatus.suffdecreaseError];
        wolfestepsizehistory.suffdecreaseSlope = [wolfestepsizehistory.suffdecreaseSlope; stepsizestatus.suffdecreaseSlope];
    end;
    gradvalhistory = [gradvalhistory; gradval];
    stepsizehistory = [stepsizehistory; stepsize];
    objfunctionhistory = [objfunctionhistory; objfunctionval];
    angulardeviationhistory = [angulardeviationhistory; angulardeviation];
    performancehistory.angulardeviationhistory = angulardeviationhistory;
    performancehistory.wolfestepsizehistory = wolfestepsizehistory;
    performancehistory.gradvalhistory = gradvalhistory;
    performancehistory.objfunctionhistory = objfunctionhistory;
    performancehistory.stepsizehistory = stepsizehistory;
    performancehistory.predicterrormx = predicterrormx; % just keep current errorsignalmx
    
    % PAUSE FOR GRAPHICS TO KEEP UP WITH COMPUTATIONS
    if displayon,
        pause(constants.displayprogress.displaytime);
    
    % DISPLAY PROGRESS UPDATE IN FIGURE
        figuretitle = ['SML-TOOLKIT: ',descentalgorithmtypedisplay,' Descent Algorithm Progress'];
        figuretitle = [figuretitle, ' (',searchoptiondisplay,' search direction)'];
        set(gcf,'name',figuretitle);
        fighandle = sazwdisplayprogress(fighandle, figuretitle, xt, constants, performancehistory);
    end;
    
    % Compute Keep Going Flag
    toomanyiterations = (iteration >= maxiterations);
    nancase = isnan(gradval) | isnan(objfunctionval);
    keepgoing = ~toomanyiterations & ~hasconverged & ~nancase;
end; % end while loop

% Compute Final Statistics.
constants.stoppingcriteria.maxiterations = 1;
constants.optimizemethod.adaptivelearning = 0;
thedata.nrrecords = nrevents; % RMG 11/14/2014
thedata.eventhistory = eventhistory;
performancehistory.predicterrormx = predicterrormx;
performancehistory.predictedresponses = predictedresponses;

sazout = computesazwoutputstats(  xt,constants,thedata);

qdim = length(xt);
performancehistory.ahat = sazout.ahat;
performancehistory.bhat = sazout.bhat;
performancehistory.traceainvb =sazout.traceainvb;
performancehistory.tracebinva = sazout.tracebinva;
performancehistory.logdetainvb = sazout.logdetainvb;
performancehistory.detainvb = sazout.detainvb;
performancehistory.traceainvbnorm = sazout.traceainvbnorm;
performancehistory.tracebinvanorm = sazout.tracebinvanorm;
performancehistory.logdetainvbnorm = sazout.logdetainvbnorm;
performancehistory.specificationscore = sazout.specificationscore;
performancehistory.numberiterations = iteration;
performancehistory.finalgradval = sazout.gradvalmax;  % rmg 2/6/2018
performancehistory.finalobjfunctionval = sazout.insamplerror;
finalobjfunctionval = sazout.insamplerror;
finalgradval = sazout.gradvalmax; % rmg 2/6/2018
performancehistory.objfunctionhistory = [performancehistory.objfunctionhistory; finalobjfunctionval];
performancehistory.gradvalhistory = [performancehistory.gradvalhistory; finalgradval];
performancehistory.insamplerror = sazout.insamplerror;
performancehistory.outofsamplerror = sazout.outofsamplerror; % GAIC generalization
performancehistory.finalcondnumhessian = sazout.condnumhessian; % rmg 2/6/2018
performancehistory.stderrors = sazout.stderrors;

% Print out convergence results.
if isadaptivelearning & displayon,
      % DISPLAY PROGRESS UPDATE IN FIGURE
        figuretitle = ['SML-TOOLKIT: ',descentalgorithmtypedisplay,' Descent Algorithm Progress'];
        figuretitle = [figuretitle, ' (',searchoptiondisplay,' search direction)'];
        fighandle = sazwdisplayprogress(fighandle, figuretitle, xt, constants, performancehistory);
end;

% Final Output
%if displayon,
    usermessage = strvcat(...
    [descentalgorithmtypedisplay,' Descent Algorithm has completed processing.'],...
    ['Number of iterations = ',num2str(performancehistory.numberiterations)],...
    ['Objective Function Value = ',num2str(performancehistory.finalobjfunctionval)],...
    ['Gradient Infinity Norm (convergence criteria) = ',num2str(finalgradval)]);
    if ~isnan(sazout.condnumhessian),
        usermessage = strvcat(usermessage,...
        ['Hessian Condition Number (local minimum test) = ',num2str(sazout.condnumhessian),...
         ', Largest Eigenvalue = ',num2str(sazout.maxhesseig),', OPG Condition Number = ',num2str(sazout.condnumopg)]);
    end;
    disp('----------------------------------------------------------');
    disp(usermessage);
    disp('----------------------------------------------------------');
    disp('MISSPECIFICATION ANALYSES:');
    disp('Misspecification indicated if magnitude of any IM discrepancy measure is large:');
    ahat = performancehistory.ahat; bhat = performancehistory.bhat;
    traceahat = trace(ahat); tracebhat = trace(bhat); detahat = det(ahat); detbhat = det(bhat);
    qdim = length(ahat);
    if ~isnan(ahat) & ~isnan(bhat),
        if (min(eig(ahat)) > eps) & (min(eig(bhat)) > eps),
            ainvb = pinv(ahat)*bhat; binva = pinv(bhat)*ahat;
            if ainvb < eps, ainvb = eps; end;
            if binva < eps, binva = eps; end;
            condahat = cond(ahat); condbhat = cond(bhat);
            logdetab = abs(log(det(ainvb))); 
            %logdetba = log(det(binva));
            rloggaicab = abs(log((1/qdim)*trace(ainvb))); 
            rloggaicba = abs(log((1/qdim)*trace(binva)));
            disp(['GAIC IM Discrepancy  =',num2str(rloggaicab),', Inverted GAIC IM Discrepancy = ',num2str(rloggaicba),...
                  ', Determinant IM Discrepancy = ',num2str(logdetab)]);
        end;
    end;
    disp('-----------------------------------------------------------');
    disp(' ');
    nrbetas = length(sazout.stderrors);
    betavector = xt;
    betaerrors = sazout.stderrors;
    nrpredictorlabels = length(varnames) - nrtargets;
    for betaindex = 1:nrpredictorlabels,
        betalabel = varnames{betaindex+nrtargets};
        if ~isnan(betaerrors),
            betazscore = betavector(betaindex)/(betaerrors(betaindex) + eps);
            thepvalue = 1 - gammainc((betazscore)^2/2,1/2); %2-sided confidence interval
            disp([betalabel,' Beta = ',num2str(betavector(betaindex)),...
                    ', Z=',num2str(betazscore),', p=',num2str(thepvalue)]);
        else
            disp([betalabel,' Beta = ',num2str(betavector(betaindex))]);
        end;
    end;
%end;




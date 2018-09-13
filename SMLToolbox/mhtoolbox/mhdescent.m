function [currentstate,performancehistory] = mhdescent(constants);
% USAGE: [currentstate,performancehistory] = mhdescent(constants);

%===========================================================================
% WARNING NOTE: Explicitly computing the energy at the current and candidate
% states can be computationally inefficient. If one can obtain a
% analytic formula for the difference in the energies between these two
% states then one can avoid calculating the entire energy function
% twice. The energy difference can be a much less computationally
% demanding calculation if the neighborhoods of the MRF are small.
%
% I have tried to mark where the computational efficiency of the routine
% could be improved by computing energy differences.
%
% In addition, the number of evaluations of the energy function are
% excessive.
%
% This routine is intended mainly for pedagogical purposes. It has the
% advantage that it is relatively easy to read and modify. Once the basic
% idea is understood, the student should design a more computationally
% efficient version of this routine for specific applications.
%
% Finally, we should really be computing "time averages" than "maxima"
% to take advantage of the geometric convergence properties...

% Also we don't have "semantic inhibitory connections" because of the
% poor learning algorithm and data sample.

%===========================================================================

%-----------------------------------------------------------------------------
%FOUNDATIONS OF STATISTICAL MACHINE LEARNING TOOLKIT
% (located in the directory "FSMLtoolkit")
%
%Copyright 2013-2015  RMG Consulting, Incorporated
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
% This License refers to all software located in the directory "FSMLtoolkit"
% which includes the directories:
%  fsmlutilities,inferencetoolbox,mhtoolbox,sazwtoolbox,
%  FSMLalgorithms,modelfolder.
%
% The directory "FSMLtoolkit" includes the software computer programs:
%  autosearchdirection,autostepsize,checkwolfe,sazwdescent,sazwdisplayprogress,
%  mhdescent,mhdisplayprogress, as well as other software computer programs.
%
%Please see the unpublished book manuscript entitled
%"Foundations of Statistical Machine Learning"
%by Richard M. Golden (Ph.D., M.S.E.E.,B.S.E.E.) for details regarding the
%design and analysis of the algorithms in this software package.
%
% "RMG Consulting, Incorporated" is located in Allen, TX 75013
%
% Tutorial videos, software updates, and software bug fixes located at: 
% www.learningmachines101.com
%-------------------------------------------------------------------------------

% warnmess{1} = 'This pedagogical routine is computationally inefficient.';
% warnmess{2} = 'Please see notes in "mhdescent.m"';
% WarningMessageHandle = warndlg(warnmess);
% waitfor(WarningMessageHandle);


% Setup Figure Window
DisplayPositionVector = constants.displayprogress.PositionVector;
fighandle = figure;
set(fighandle,'Position',DisplayPositionVector);

% Function Definitions
funkfile = constants.objectivefunctionfile;
proposalfile = constants.proposalfile;

% STOPPING CRITERIA
moveavgtime = constants.stoppingcriteria.moveavgtime;
maxmoveavgdiff = constants.stoppingcriteria.maxmoveavgdiff;
maxiterations = constants.stoppingcriteria.maxiterations;
miniterations = constants.stoppingcriteria.miniterations;

% INITIAL STATE VECTOR
currentstate = constants.initialstate;
averagestate = 0*currentstate(:);
beststate = currentstate(:);

% Initialize Temperature
temperature = constants.temperature.initial;

% Start Metropolis-Hastings Descent Algorithm
deterministicdescent = 0;  currentmoveavg = NaN; lastmoveavg = NaN;
avgEchange = NaN; 
keepgoing = 1; iteration = 0; bestfunkval = inf;
while keepgoing,
    % Generate a Candidate State
    energyX = feval(funkfile,currentstate,constants);
    currentfunkval = energyX;
    dosample = 1; candstate = [];
    [candstate,probcand]= feval(proposalfile,dosample,funkfile,candstate,currentstate,temperature,constants);
    candstate = candstate(:);
    energyC = feval(funkfile,candstate,constants);
    energydiffCgivenX = energyC - energyX;
    
    % Metropolis-Hastings Descent Algorithm 
    %(This is the guts of the algorithm)
    iteration = iteration + 1;
    if energydiffCgivenX < 0, 
        currentstate = candstate;
        currentfunkval = energyC;
    else
        dosample = 0;
        [currentstate,probcurrent]= feval(proposalfile,dosample,funkfile,currentstate,candstate,temperature,constants);
        currentstate = currentstate(:);
        acceptprob = (probcurrent/probcand)*exp(-energydiffCgivenX/temperature);
        arandomnumber = rand(1,1);
        if arandomnumber < acceptprob,
            currentstate = candstate;
            currentfunkval = energyC;
        end;
    end;
    
    % Record the history of objective value changes and 
    % keep track of the "best state"
    if currentfunkval < bestfunkval,  % keep track of best state
        bestfunkval = currentfunkval;
        beststate = currentstate;
    end;
    objfunkvals(iteration) = currentfunkval;
    bestfunkvalhistory(iteration) = bestfunkval;
    
    % Check Stopping Criteria and compute moving averages
    equilibriumstate = 0;
    averagestate = averagestate*(1-(1/iteration)) + currentstate/iteration;
    if (iteration > (2*moveavgtime+1)),
        currentmoveavgperiod = (iteration-moveavgtime+1):iteration;
        lastmoveavgperiod = (iteration-2*moveavgtime+1):(iteration-moveavgtime);
        currentmoveavg = mean(objfunkvals(currentmoveavgperiod));
        lastmoveavg = mean(objfunkvals(lastmoveavgperiod));
        avgEchange = abs(lastmoveavg - currentmoveavg);
        
        % Check for equilibrium state only after minimum number of iterations
        if (iteration > miniterations),
            equilibriumstate = abs(lastmoveavg - currentmoveavg) < maxmoveavgdiff;
        end;
     end;
    keepgoing = (iteration < maxiterations);
    
    % update average state
%     averagestate
%     currentstate
%     iteration
   
    disp(['Iteration #',num2str(iteration),', Temp. = ',num2str(temperature),...
        ', Current Energy =',num2str(currentfunkval),', Best Energy = ',num2str(bestfunkval),', Avg. Energy Change:',num2str(avgEchange)]);
        
    % Adjust Temperature Parameter; At Equilibrium, Re-initialize system
    % with "best state".
    if equilibriumstate,
        equilibriumstate = 0;
        currentstate = beststate;
        currentfunkval = bestfunkval;
        temperature = temperature * constants.temperature.scaleddecrease;
        if deterministicdescent, 
            keepgoing = 0; 
            disp('*******************  END DETERMINISTIC DESCENT ************************');
        else
            pause(1.0);
            if temperature < constants.temperature.final,
                temperature = eps;
                disp('******************** START DETERMINISTIC DESCENT ***********************');
                deterministicdescent = 1;
            end;
        end;
    end;
    
    % Plot Results and save results in performance history
    performancehistory.bestfunkvalhistory = bestfunkvalhistory;
    performancehistory.objfunctionhistory = objfunkvals;
    performancehistory.temperaturehistory(iteration) = temperature;
    performancehistory.beststate = beststate;
    performancehistory.bestfunkval = bestfunkval;
    performancehistory.currentfunkval = currentfunkval;
    performancehistory.averagestate = averagestate;
    performancehistory.currentstate = currentstate;
    
    % Display Graphics
    fighandle = mhdisplay(fighandle, constants, performancehistory);
end; % end of keepgoing while loop


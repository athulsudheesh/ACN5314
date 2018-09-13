function [stepsize,Vbest,iteration] = autostepsize(xt,dt,constants,thedata);
% USAGE: [stepsize,Vbest,iteration] = autostepsize(xt,dt,constants,thedata)

% Last Revision Date: January 15, 2015
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


%------------------------------------------------------------------

% Load Function Names and Constants
funkfilename =  constants.model.funkfilename;
gradfilename =  constants.model.gradfilename;
useminstepsize =   constants.wolfestep.useminstepsize; % true or false
minstepsize = constants.wolfestep.minstepsize;
maxiterations = constants.wolfestep.maxiterations; % This should not be a big number
alpha         = constants.wolfestep.alpha; % This corresponds to the ALPHA in the wolfe stepsize criteria
beta = constants.wolfestep.beta; %wolfe stepsize beta
scaleddecreasefactor = constants.wolfestep.decreasefactor;
%display_diagnostics = constants.wolfestep.displaydiagnostics; % default = 0;
display_diagnostics = 0;
%------------------------------------------------------------------

% This routine is a "back-tracking routine" which uses quadratic approximations
% to make improved guesses.

% Get curvature information regarding error at initial point
Vt = feval(funkfilename,xt,constants,thedata);
gt = feval(gradfilename,xt,constants,thedata);
slope0 = dt'*gt;  
if (slope0 > 0),
   disp('"WARNING! ("autostepsize.m"): BAD SEARCH DIRECTION FOR AUTOSTEPSIZE! Search direction uphill!');
end;

keepgoing = 1; iteration = 1; 
s1 = 1; % Try a BIG stepsize initially
while keepgoing,
    % Compute Objective Function at current test stepsize s1
    V1 = feval(funkfilename,xt+s1*dt,constants,thedata);
   
    % Check for Sufficient Decrease of Objective Function
    suffdecrease = V1 <= (Vt + s1*alpha*slope0);
   
    % If current test stepsize s1 did not decrease error sufficiently, try
    % quadratic approximation; If ok, then terminate.
    if ~suffdecrease,
        % Compute Quadratic Approximation Stepsize
        s2 = -slope0/(2*(V1 - Vt - slope0));
        
        % Evaluate Objective Function at Quadratic approximation stepsize
        V2 = feval(funkfilename,xt+s2*alpha*slope0,constants,thedata);
        
        % Check for Sufficient Decrease of Objective Function
        suffdecrease2 = V2 <= (Vt + s2*alpha*slope0);
   
        % If not sufficient decrease, try an initial guess
        % which is closer to the original starting point
        % to improve quality of quadratic approximation
        % by scaling down the initial stepsize guess.
        % If it is ok, then terminate.
        if ~suffdecrease2,
            s1 = scaleddecreasefactor * s1;
            iteration = iteration + 1;
            keepgoing = (iteration < maxiterations);
            if ~keepgoing,
                if useminstepsize,
                    stepsize = rand(1,1)*(1 - minstepsize) + minstepsize; % this is presumably a bad step but we are out of time
                    Vbest = feval(funkfilename,xt+stepsize*dt,constants,thedata);
                else
                    stepsize = s2; % this is presumably a bad step but we are out of time
                    Vbest = V2;
                end;
            end;
        else
            stepsize = s2;
            Vbest = V2;
            keepgoing = 0;
        end;
    else % if ~suffdecrease
        stepsize = s1;
        Vbest = V1;
        keepgoing = 0;
    end; % if ~suffdecrease
end; % end of while loop

% SET STEPSIZE = EPS if it is less than ZERO!   Added 1/15/2015
if (stepsize < 0),
    stepsize = eps;
end;
        
% DISPLAY DIAGNOSTICS
if display_diagnostics,
      fighandle = figure;
      set(fighandle,'Name','AutoStepsize Display');
      stepsizeincrement = 0.01;
      nrsteps = round(1/stepsizeincrement);
      for i = 1:nrsteps,
         stepsizes(i) = stepsizeincrement*(i-1);
         Vplot(i) = feval(funkfilename,xt+stepsizes(i)*dt,constants,thedata);
      end;
      plot(stepsizes,Vplot);
      ylabel('Objective Function');
      xlabel('Stepsize');
      hold on;
      plot(stepsize,Vbest,'rx','MarkerSize',10,'Linewidth',5);
      pause(2);
end;



   


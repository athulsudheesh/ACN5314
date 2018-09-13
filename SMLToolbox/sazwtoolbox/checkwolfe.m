function stepsizestatus = checkwolfe(xt,dt,stepsize,constants,thedata)
% USAGE: stepsizestatus = checkwolfe(xt,dt,stepsize,constants,thedata)
% stepsizestatus.suffdecreaseError
% stepsizestatus.suffdecreaseSlope
% stepsizestatus.boundedsuffdecreaseSlope
% stepsizestatus.wolfestepsize
% stepsizestatus.strongwolfestepsize

%-----------------------------------------------------------------------------
%FOUNDATIONS OF STATISTICAL MACHINE LEARNING TOOLKIT
% (located in the directory "FSMLtoolkit")
%
%Copyright 2013-2014  RMG Consulting, Incorporated
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

% Load Function Names and Constants
funkfilename =  constants.model.funkfilename;
gradfilename =  constants.model.gradfilename;
alpha         = constants.wolfestep.alpha; % close to zero
beta          = constants.wolfestep.beta;  % close to one

%-----------------------------------------------------------------------

% Check for Sufficient Decrease in Error Function
E0 = feval(funkfilename,xt,constants,thedata);
g0 = feval(gradfilename,xt,constants,thedata);
xTEST = xt + stepsize * dt;
eTEST = feval(funkfilename,xTEST,constants,thedata);
slope0 = g0'*dt;
stepsizestatus.suffdecreaseError = eTEST <= E0 + alpha*stepsize*slope0;

% Check for Sufficient Decrease in Error Function Slope
gTEST = feval(gradfilename,xTEST,constants,thedata);
slopeTEST = gTEST'*dt;
stepsizestatus.suffdecreaseSlope = slopeTEST >= beta * slope0;
%slopeTEST
%slope0

% Check for Bounded Decrease in Error Function Slope
stepsizestatus.boundedsuffdecreaseSlope = abs(slopeTEST) <= beta * abs(slope0);

% Compute Wolfe Stepsize Flags
stepsizestatus.wolfestepsize = stepsizestatus.suffdecreaseError & stepsizestatus.suffdecreaseSlope;
stepsizestatus.strongwolfestepsize = stepsizestatus.suffdecreaseError & stepsizestatus.suffdecreaseSlope;

end


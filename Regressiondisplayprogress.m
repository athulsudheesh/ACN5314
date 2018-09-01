function fighandle = Regressiondisplayprogress(fighandle, figuretitle, systemstate, constants, performancehistory)
% USAGE: fighandle = sazwdisplayprogress(fighandle, figuretitle, systemstate, constants, performancehistory)

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

isadaptive = strcmp(constants.optimizemethod.adaptivelearning,'Adaptive (on-line)');

% Load Performance Data
angulardeviationhistory = performancehistory.angulardeviationhistory;
wolfestepsizehistoryError = performancehistory.wolfestepsizehistory.suffdecreaseError;
wolfestepsizehistorySlope = performancehistory.wolfestepsizehistory.suffdecreaseSlope;
gradvalhistory = performancehistory.gradvalhistory;
objfhistory = performancehistory.objfunctionhistory;
stepsizehistory = performancehistory.stepsizehistory;

% PLOT CONSTANTS
TitleFontSize = constants.displayprogress.TitleFontSize;
AxisFontSize =  constants.displayprogress.AxisFontSize;
MarkerSizeValue = constants.displayprogress.MarkerSizeValue;
BigMarkerSizeValue = constants.displayprogress.BigMarkerSizeValue;
LineWidthValue = constants.displayprogress.LineWidthValue;
BigLineWidthValue = constants.displayprogress.BigLineWidthValue;
DisplayPositionVector = constants.displayprogress.PositionVector;
errorcolorrange = constants.displayprogress.predictionerrorcolor;
statecolorrange = constants.displayprogress.statevectorcolor;

%-----------OBJECTIVE FUNCTION HISTORY PLOT WINDOW---------------------
subplot(1,3,1);
plot(objfhistory,'Markersize',MarkerSizeValue,'LineWidth',LineWidthValue);
title('Objective Function History','FontSize',TitleFontSize,'FontWeight','Bold');
ylabel('Objective Function','FontSize',AxisFontSize,'FontWeight','Bold');
xlabel('Iteration Number','FontSize',AxisFontSize,'FontWeight','Bold');

%---------GRADVAL HISTORY PLOT WINDOW----------------------------------
subplot(1,3,2);
semilogy(gradvalhistory,'Markersize',4,'LineWidth',2);
title('Objective Function Gradient History','FontSize',TitleFontSize,'FontWeight','Bold');
ylabel('Gradient Infinity Norm','FontSize',AxisFontSize,'FontWeight','Bold');
xlabel('Iteration Number','FontSize',AxisFontSize,'FontWeight','Bold');



%---------PREDICTION ERROR PLOT WINDOW---------------------------------
subplothandle236 = subplot(1,3,3);
subplot236position = get(subplothandle236,'Position');
set(subplothandle236,'Position',subplot236position');
colormap('jet');
errormx = performancehistory.predicterrormx;
imagesc(errormx);
title('Prediction Errors','FontSize',TitleFontSize,'FontWeight','Bold');
ylabel('Response Variable ID','FontSize',AxisFontSize,'FontWeight','Bold');
if isadaptive,
    xlabeldisplay = 'Randomly Sampled Event IDs';
else
    xlabeldisplay = 'Event IDs';
end;
xlabel(xlabeldisplay,'FontSize',AxisFontSize,'FontWeight','Bold');
% hold on;
colorbar;
caxis(errorcolorrange);

% hold off;
%keyboard;


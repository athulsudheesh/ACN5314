function fighandle = gibbsdisplay(fighandle, constants, performancehistory)
% USAGE: fighandle = gibbsdisplay(fighandle, constants, performancehistory)

%---------------------------------------------------------------
% WARNING! This routine assumes binary states! 
% Also this routine is computationally inefficient!!
%---------------------------------------------------------------

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

% PAUSE FOR GRAPHICS TO KEEP UP WITH COMPUTATIONS
pause(constants.displayprogress.displaytime);
    
% DISPLAY PROGRESS UPDATE IN FIGURE
set(fighandle,'numbertitle','off');
figuretitle = ['FSML-TOOLKIT: Metropolis-Hastings Descent Algorithm Progress'];
set(gcf,'name',figuretitle);

% Load Performance Data
bestfunkvalhistory = performancehistory.bestfunkvalhistory;
objfhistory = performancehistory.objfunctionhistory;
temphistory = performancehistory.temperaturehistory;

% Load States
beststate = performancehistory.beststate;
currentstate = performancehistory.currentstate;
averagestate = performancehistory.averagestate;

% PLOT CONSTANTS
TitleFontSize = constants.displayprogress.TitleFontSize;
AxisFontSize =  constants.displayprogress.AxisFontSize;
MarkerSizeValue = constants.displayprogress.MarkerSizeValue;
BigMarkerSizeValue = constants.displayprogress.BigMarkerSizeValue;
LineWidthValue = constants.displayprogress.LineWidthValue;
BigLineWidthValue = constants.displayprogress.BigLineWidthValue;
DisplayPositionVector = constants.displayprogress.PositionVector;
DisplayBinaryStates = constants.displayprogress.DisplayBinaryStates;

%-----------OBJECTIVE FUNCTION HISTORY PLOT WINDOW---------------------
if DisplayBinaryStates,
    nrrowplots = 2;
    nrcolplots = 2;
else
    nrrowplots = 2;
    nrcolplots = 1;
end;
subplot(nrrowplots,nrcolplots,1);
iterationnumber = 1:length(objfhistory);
subplot221handle = semilogy(iterationnumber,objfhistory,'bx-',...
         iterationnumber,bestfunkvalhistory,'ro--',...
    'Markersize',MarkerSizeValue,'LineWidth',LineWidthValue);
title('Objective Function Value (Energy) History','FontSize',TitleFontSize,'FontWeight','Bold');
ylabel('Energy','FontSize',AxisFontSize,'FontWeight','Bold');
xlabel('Iteration Number','FontSize',AxisFontSize,'FontWeight','Bold');
% objfhistory
% bestfunkvalhistory
legend(subplot221handle,'Current Energy Value','Best Energy Value','Location','NorthWest');

%------- TEMPERATURE HISTORY WINDOW ---------------
subplot222handle = subplot(nrrowplots,nrcolplots,2);
plot(1:length(temphistory),temphistory,'r-','Markersize',MarkerSizeValue,'LineWidth',LineWidthValue);
title('Temperature History','FontSize',TitleFontSize,'FontWeight','Bold');
ylabel('Temperature','FontSize',AxisFontSize,'FontWeight','Bold');
xlabel('Iteration Number','FontSize',AxisFontSize,'FontWeight','Bold');
maxiterationsplot = length(temphistory) + 1;
maxtempplot = constants.temperature.initial + 1;
axis(subplot222handle,[1 maxiterationsplot 0 maxtempplot]);

if DisplayBinaryStates,
    %------- STATE of MRF with Local Probabilities -----------------------------
    subplot223handle = subplot(2,2,3);
    statedim = length(currentstate);
    x = 1:statedim;
    statelistvector = decodevector(currentstate,constants);
    %barh(x,currentstate,'r'); % 6/11/2018
    barh(categorical(statelistvector),currentstate,'r');  % 6/11/2018
    hold on;
    unclampedlocs = find(constants.clampedvector == 0);
    currentstateunclamped = 0*currentstate;
    currentstateunclamped(unclampedlocs) = currentstate(unclampedlocs);
    %barh(x, currentstateunclamped,'g'); % 6/11/2018
    barh(categorical(statelistvector),currentstateunclamped,'g'); % 6/11/2018
    hold off;
    set(subplot223handle,'FontSize',AxisFontSize);
    %set(subplot223handle,'FontWeight','Bold');
    %set(subplot223handle,'YTickLabel',statelistvector); % 6/11/2018
    %set(subplot223handle,'YTick',x); % 6/11/2018
    xlabel(subplot223handle,'Current State');
    %set(subplot223handle,'YTickMode','Manual'); % 6/11/2018
    titleinfo = ['CURRENT State (Energy = ',num2str(performancehistory.currentfunkval),')'];
    title(titleinfo,'FontSize',TitleFontSize,'FontWeight','Bold');
    plot223position = get(subplot223handle,'position');
    set(subplot223handle,'position',plot223position);
    legend(subplot223handle,'Clamped','Unclamped', 'Location','SouthOutside');


    %------- BEST STATE of MRF with Local Probabilities -----------------------------
    subplot224handle = subplot(2,2,4);
    statedim = length(beststate);
    x = 1:statedim;
    statelistvector = decodevector(beststate,constants);
    %barh(x,averagestate,'r'); % 6/11/2018
    barh(categorical(statelistvector),averagestate,'r'); % 6/11/2018
    hold on;
    unclampedlocs = find(constants.clampedvector == 0);
    averagestategreen = 0*currentstate;
    averagestategreen(unclampedlocs) = averagestate(unclampedlocs);
    %barh(x, averagestategreen,'g'); % 6/11/2018
    barh(categorical(statelistvector),averagestategreen,'g'); % 6/11/2018
    hold off;
    set(subplot224handle,'FontSize',AxisFontSize);
    %set(subplot224handle,'FontWeight','Bold');
    %set(subplot224handle,'YTickLabel',statelistvector); % 6/11/2018
    %set(subplot224handle,'YTick',x); % 6/11/2018
    xlabel(subplot224handle,'Confidence Level');
    %set(subplot224handle,'YTickMode','Manual'); % 6/11/2018
    titleinfo = ['BEST State (Energy = ',num2str(performancehistory.bestfunkval),')'];
    title(titleinfo,'FontSize',TitleFontSize,'FontWeight','Bold');
    plot224position = get(subplot224handle,'position');
    set(subplot224handle,'position',plot224position);
    legend(subplot224handle,'Clamped','Unclamped', 'Location','SouthOutside');
end;




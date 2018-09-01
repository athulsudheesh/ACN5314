function [traindatasheet,testdatasheet] = splitdata(datafilename,percenttrain)
% USAGE: [traindatasheet,testdatasheet] = splitdata(datafilename,percenttrain)

% This function takes as input a filename "datafilename" which refers to a
% spreadsheet and a number between 0 and 100 called "percenttrain".
% The program reads the spreadsheet and then randomly selects the
% percentage "percenttrain" of the rows as training data and leaves
% remainder as the test data.

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

[numdata,datalabels,spreadsheetdata] = xlsread(datafilename);
[nrevents,nrvars] = size(numdata);
permutedlocs = randperm(nrevents);
nrtrain = max([1,round(nrevents*percenttrain/100)]);
selecttrain = permutedlocs(1:nrtrain);
selecttest = permutedlocs((nrtrain+1):nrevents);
traindata = numdata(selecttrain,:);
testdata = numdata(selecttest,:);

% Write training data to spreadsheet
[nreventsnew,nrvarsnew] = size(traindata);
for i = 1:(nreventsnew+1),
    for j = 1:nrvarsnew,
        if (i == 1),
            traindatasheet{i,j} = datalabels{j};
        else
            thenumberij = traindata(i-1,j);
            traindatasheet{i,j} = thenumberij;
        end;
    end;
end;
xlswrite(['train_',datafilename],traindatasheet);

% Write test data to spreadsheet
[nreventsnew,nrvarsnew] = size(testdata);
for i = 1:(nreventsnew+1),
    for j = 1:nrvarsnew,
        if (i == 1),
            testdatasheet{i,j} = datalabels{j};
        else
            thenumberij = testdata(i-1,j);
            testdatasheet{i,j} = thenumberij;
        end;
    end;
end;
xlswrite(['test_',datafilename],testdatasheet);




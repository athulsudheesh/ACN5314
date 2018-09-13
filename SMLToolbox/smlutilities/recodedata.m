function [newspreadsheet,recodeddata,recodeddatalabels,datatransforms] = recodedata(datafilename,codingplan)
% USAGE: [newspreadsheet,recodeddata,recodeddatalabels,datatransforms] = recodedata(datafilename,codingplan)

% INPUTS:
% datafilename is the name of spreadsheet data file.
% codingplan is a structure with dimension equal to the number of variables


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

[numdata,datalabels,spreadsheetdata] = xlsread(datafilename);
recodeddata = []; 
[nrevents,nrvars] = size(numdata);
j = 0;
for i = 1:nrvars,
    datacolumni = numdata(:,i);
    datalabeli = datalabels{i};
    switch codingplan{i},
        case 'binary',
            disp(['Binary Variable "',datalabeli,'" mapped to Binary Variable with values 0 and 1.']);
            j = j + 1;
            maxval = max(datacolumni);
            minval = min(datacolumni);
            onelocs = find(datacolumni == maxval);
            zerolocs = find(datacolumni == minval);
            recodeddatalabels{j} = [datalabeli,'_Binary'];
            outputdata = zeros(nrevents,1);
            outputdata(onelocs) = 1;
            outputdata(zerolocs) = 0;
            datatransforms{i}.type = codingplan{i};
            datatransforms{i}.maxval = maxval;
            datatransforms{i}.minval = minval;
            recodeddata = [recodeddata outputdata];
        case 'numeric',
            disp(['Variable "',datalabeli,'" was rescaled as zero mean with unit variance.']);
            j = j + 1;
            meanvalue = mean(datacolumni);
            outputdata = datacolumni - meanvalue;
            stdvalue = std(datacolumni);
            if (stdvalue > eps),
                outputdata = outputdata/stdvalue;
            end;
            recodeddatalabels{j} = [datalabeli,'_Scaled'];
            datatransforms{i}.type = codingplan{i};
            datatransforms{i}.meanvalue = meanvalue;
            datatransforms{i}.stdvalue = stdvalue;
            recodeddata = [recodeddata outputdata];
        case {'categorical','reference-cell'},
            disp(['Variable "',datalabeli,'" coded as type "',codingplan{i},'"']);
            uniquevalues = unique(datacolumni);
            nruniquevalues = length(uniquevalues);
            if strcmp(codingplan{i},'reference-cell'),
                disp(['--The Variable Value "',num2str(uniquevalues(nruniquevalues)),'" is the reference value.']);
                originaluniquevalues = uniquevalues;
                uniquevalues = originaluniquevalues(1:(nruniquevalues-1));
                nruniquevalues = length(uniquevalues);
            end;
            disp(['--',num2str(nruniquevalues),' detected for variable "',datalabeli,'"']);
            for k = 1:nruniquevalues,
                j = j + 1;
                valuelocsij = find(datacolumni == uniquevalues(k));
                outputdata = zeros(nrevents,1);
                outputdata(valuelocsij) = 1;
                recodeddatalabels{j} = [datalabeli,'_group',num2str(uniquevalues(k))];
                datatransforms{i}.type = codingplan{i};
                recodeddata = [recodeddata outputdata];
            end;
        otherwise,
            j = j + 1;
            disp(['Variable "',datalabeli,'" was not recoded.']);
            outputdata = datacolumni;
            datatransforms{i}.type = codingplan{i};
            recodeddatalabels{j} = datalabeli;
            recodeddata = [recodeddata outputdata];
    end;
end;

% Write output data to spreadsheet
[nreventsnew,nrvarsnew] = size(recodeddata);
for i = 1:(nreventsnew+1),
    for j = 1:nrvarsnew,
        if (i == 1),
            newspreadsheet{i,j} = recodeddatalabels{j};
        else
            thenumberij = recodeddata(i-1,j);
            newspreadsheet{i,j} = thenumberij;
        end;
    end;
end;
xlswrite(['recoded_',datafilename],newspreadsheet);


end


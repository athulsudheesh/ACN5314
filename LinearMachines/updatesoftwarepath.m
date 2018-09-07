function updatesoftwarepath;

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

softwarefolder = pwd;
if (ispc == 1) % computer is windows use the following for directories
   % path(path,[softwarefolder,'\LinearMachines']);
    path(path,[softwarefolder,'\lmutilities']);
    path(path,[softwarefolder,'\data']);

else
   % path(path,[softwarefolder,'/LinearMachines']);
    path(path,[softwarefolder,'/lmutilities']);
    path(path,[softwarefolder,'/data']);
end
path
%copyrightinfo;
end





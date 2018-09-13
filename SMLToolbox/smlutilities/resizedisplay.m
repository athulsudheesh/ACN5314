function constants = resizedisplay(displaychoice,constants);
% USAGE: constants = resizedisplay(displaychoice,constants);

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


switch displaychoice,
    case 'small',
        constants.displayprogress.TitleFontSize = 12;
        constants.displayprogress.AxisFontSize = 11;
        constants.displayprogress.MarkerSizeValue = 4;
        constants.displayprogress.BigMarkerSizeValue = 7;
        constants.displayprogress.LineWidthValue = 2;
        constants.displayprogress.BigLineWidthValue = 5;
        constants.displayprogress.PositionVector =   [21          75        1006         580];
    case 'medium',
        constants.displayprogress.TitleFontSize = 13;
        constants.displayprogress.AxisFontSize = 11;
        constants.displayprogress.MarkerSizeValue = 4;
        constants.displayprogress.BigMarkerSizeValue = 7;
        constants.displayprogress.LineWidthValue = 2;
        constants.displayprogress.BigLineWidthValue = 5;
        constants.displayprogress.PositionVector =   [107         -89        1233         735];
    case 'large',
        constants.displayprogress.TitleFontSize = 14;
        constants.displayprogress.AxisFontSize = 13;
        constants.displayprogress.MarkerSizeValue = 4;
        constants.displayprogress.BigMarkerSizeValue = 7;
        constants.displayprogress.LineWidthValue = 2;
        constants.displayprogress.BigLineWidthValue = 5;
        constants.displayprogress.PositionVector =   [600  152  1169 889];
end;

end


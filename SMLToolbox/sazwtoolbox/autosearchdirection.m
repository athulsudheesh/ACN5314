function [dt,innercycleid] = autosearchdirection(innercycleid,xt,dtlast,gt,gtlast,hesst,stepsizelast,constants);
% USAGE: [dt,innercycleid] = autosearchdirection(innercycleid,xt,dtlast,gt,gtlast,hesst,stepsizelast,constants);

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


% Load Function Names and Constants
gradfilename = constants.model.gradfilename;
hessfilename = constants.model.hessfilename;
searchoption = constants.optimizemethod.searchdirection;
gradmax = constants.stoppingcriteria.gradmax;
mincosinesearchangle = constants.optimizemethod.maxsearchdev;
mineigvalue = constants.optimizemethod.levenmarqeigvalue;
maxinnercycles = constants.optimizemethod.innercycles;
%autostepsizemode = constants.optimizemethod.autostepsizemode;
stochasticmode = strcmp(constants.optimizemethod.adaptivelearning,'Adaptive (on-line)');
momentumconstant = constants.optimizemethod.momentumconstant;
dtmaxval = constants.optimizemethod.searchdirectionmaxnorm;
NUMERICALZERO = 0.001*gradmax*gradmax;

% Compute Search Direction
switch searchoption,
    case 'gradient',
        dt = -gt;
        innercycleid = 0;
    case 'momentumbound',
        if ~isequal(size(gt),size(dtlast)), % fix initialization if necessary
                dtlast = 0*gt;
        end;
        normgt = norm(gt); xdim = length(gt);
        momentumvariable = momentumconstant * normgt /(dtmaxval*sqrt(xdim));
        dt = -gt + momentumvariable*dtlast;
        innercycleid = 0;
    case 'momentumgrad',
        if ~isequal(size(gt),size(gtlast)), % fix initialization if necessary
            gtlast = 0*gt;
        end;
        normgt = norm(gt); xdim = length(gt);
        momentumvariable = momentumconstant * (gt'*gt) / sqrt((gtlast'*gt)*(gtlast'*gt) + NUMERICALZERO);
        dt = -gt + momentumvariable*gtlast;
        innercycleid = 0;
    case 'momentum2direction',
        % this is second preferred choice. This assumes that observations are
        % identically distributed but not independent or that parameter
        % update takes place every other observation.
          if ~isequal(size(gt),size(dtlast)), % fix initialization if necessary
                dtlast = 0*gt;
          end;
          normgt = norm(gt);
          momentumvariable = momentumconstant * normgt*normgt/(NUMERICALZERO + abs(dtlast'*gt));
          dt = -gt + momentumvariable*dtlast;
    case 'momentumdirection',
            inversedtlast = 1/(norm(dtlast)*norm(dtlast)); themargin = 0.1;
            if (momentumconstant < (1-themargin)*inversedtlast) & ...
                    (momentumconstant > themargin*inversedtlast),
                dt = -gt + momentumconstant*dtlast;
            % disp('momentum step');
            else
              %  disp('gradient-step');
                dt = -gt;
            end;
    case 'newton',
        invhesst = pinv(hesst);
        dt = -invhesst * gt;
        innercycleid = 0;
    case 'levenbergmarquardt', % Revised 1/31/2016
        epsiloncon = 0;
        dim = length(gt);
        if any(any(isnan(hesst(:)))) | any(any(isinf(hesst(:)))),
            invhesst = eye(dim);
        else
            lambdaminhesst = min(eig(hesst));
            if lambdaminhesst <= mineigvalue,
                epsiloncon = mineigvalue;
            end;
            invhesst = pinv(hesst + epsiloncon*eye(dim));
        end;
        dt = -invhesst * gt;
        innercycleid = 0;
    case {'Lbfgs','polakribiere','fletcherreeves'},
        dtmaxval = inf;  % Do not bound search direction
        gooddirection = 1; cosinesearchangle = 0;
        if (innercycleid == 0), % Reset Search Direction
            dt = -gt;   
        else
            ut = gt - gtlast;
            denomt = dtlast'*ut;
            if abs(denomt) < NUMERICALZERO,
                dt = -gt;
            else
                atscalar = (dtlast'*gt)/denomt;
                btscalar = (ut'*gt)/denomt;
                ctscalar = stepsizelast + (ut'*ut)/denomt;
                actscalar = atscalar * ctscalar;
                switch searchoption,
                    case 'Lbfgs',
                        dt = -gt + atscalar * ut + (btscalar - actscalar)*dtlast;
                    case 'polakribiere',
                        normgtsq = gtlast'*gtlast;
                        btpolakribiere = (ut'*gt)/(NUMERICALZERO + normgtsq);
                        dt = -gt + btpolakribiere*dtlast;
                    case 'fletcherreeves',
                        normgtsq = gtlast'*gtlast;
                        btfletcherreeves = (gt'*gt)/(NUMERICALZERO + normgtsq);
                        dt = -gt + btfletcherreeves*dtlast;
                    end; % end inner switch search option statement
            end; % end inner if-else statement 
        end; % end outer if-else statement
        innercycleid = innercycleid + 1;
        if (innercycleid == maxinnercycles), innercycleid = 0; end; 
    otherwise,
        disp(['SEARCH DIRECTION OPTION "',searchoption,'" was not found.']);
    end; % end outer switch searchoption statement
    
% Bound Search Direction so it is confined to an origin-centered hypercube
boundsearchdirection = isfinite(dtmaxval) & strcmp(searchoption,'momentumbound');
if boundsearchdirection,
    dtoriginal = dt;
    dtminval = -dtmaxval;
    dtmaxvals = (dtoriginal > dtmaxval) * dtmaxval;
    dtminvals = (dtoriginal < -dtmaxval) * dtminval;
    keepvals = (dtoriginal >= dtminval) & (dtoriginal <= dtmaxval);
    dt = (dtoriginal .* keepvals) + dtmaxvals + dtminvals;
end;
    

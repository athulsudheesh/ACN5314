function [Y,probYgivenX]=  stepwisesearchproposal(dosample,funkfile,Y,X,temperature,constants);
% USAGE: [Y,probYgivenX] = stepwisesearchproposal(dosample,funkfile,Y,X,temperature,constants);
% Proposal Function for Customized stepwisesearch

isunclamped = (constants.clampedvector == 0);
clampedloc = find(~isunclamped);
Xequals1loc = setdiff(find(X == 1),clampedloc);
Xequals0loc = setdiff(find(X == 0),clampedloc);
dimXequals1 = length(Xequals1loc);
dimXequals0 = length(Xequals0loc);
probaddbit = dimXequals0/(dimXequals0 + dimXequals1);
X = X(:); probYgivenX = [];

if dosample,
    Y = X;
    flipbit = (rand(1,1) <= 0.5);
    addbit = (rand(1,1) <= probaddbit);
    if flipbit & addbit & ~isempty(Xequals0loc),
        Ylocloc0 = randi(dimXequals0,1,1);
        Yloc0 = Xequals0loc(Ylocloc0);
        Y(Yloc0) = 1;
    end;
    if flipbit & ~addbit & ~isempty(Xequals1loc),
        Ylocloc1 = randi(dimXequals1,1,1);
        Yloc1 = Xequals1loc(Ylocloc1);
        Y(Yloc1) = 0;
    end;
end;

% Compute Probabilty Y given X
Y = Y(:);
Ytransition = Y - (Y.*X);
Ytransloc = find(Ytransition ~= 0);
wasadded = X(Ytransloc) > 0;
wasremoved = X(Ytransloc) < 0;
if length(Ytransloc) > 0,
    probYgivenX = (probaddbit*wasadded + (1-probaddbit)*wasremoved)*1/2;
else
    probYgivenX = (1/2);
end;

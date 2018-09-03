function [Y,probYgivenX,energydiff]=  gibbsamplebinary(dosample,funkfile,Y,X,temperature,constants);
% USAGE: [Y,probYgivenX,energydiff] = gibbssamplebinary(dosample,funkfile,Y,X,temperature,constants);
% Proposal Function for Gibbs Sampler
% where we assume the state vectors are binary (0/1) vectors
% In the "sampling mode", we pick one site at random and flip
% it with a particular probability.

% In practice, the "energydiff" can be usually computed
% more efficiently by avoiding full evaluation of the objective
% function and just computing the change in the objective function's
% value.

unclampedlist = find(constants.clampedvector == 0);
nrunclamped = length(unclampedlist);
unitidloc = randi(nrunclamped,1);
unitid = unclampedlist(unitidloc);
statevector1 = X;
statevector0 = X;
statevector1(unitid) = 1;
statevector0(unitid) = 0;
funkval1 = feval(funkfile,statevector1,constants);
funkval0 = feval(funkfile,statevector0,constants);
energydiff = funkval1 - funkval0;
localprob = logisticsigmoid(0.5*(energydiff)/temperature);
if dosample,
    Y = X;
    Y(unitid) = (rand(1,1) <= localprob);
end;
probYgivenX = (Y(unitid) * localprob + (1 - Y(unitid))*(1-localprob))*(1/nrunclamped);

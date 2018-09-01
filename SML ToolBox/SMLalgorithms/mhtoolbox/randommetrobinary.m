function [Y,probYgivenX] =  randommetrobinary(dosample,funkfile,Y,X,temperature,constants);
% USAGE: [Y,probYgivenX] = randommetrobinary(dosample,funkfile,Y,X,temperature,constants);
% Proposal Function for Metropolis Sampler which does a random search
% where we assume the state vectors are binary (0/1) vectors

% Performance of algorithm should be substantially better when the
% temperature = 1 than when temperature = infinity.

% In practice, the "energydiff" can be usually computed
% more efficiently by avoiding full evaluation of the objective
% function and just computing the change in the objective function's
% value.
X = X(:); 
Xdim = length(X);
unclampedlist = find(constants.clampedvector == 0);
nrunclamped = length(unclampedlist);
flippedX = 2*X - 1; % This is a vector which "flips" all bits in X
probflip = zeros(Xdim,1); % probflip(k) = 0 if kth bit should not be flipped because it is clamped
probflip(unclampedlist) = 1; % probflip(k) = 1 if kth bit should be flipped because it is unclamped
if dosample,
    Ytemp = (rand(Xdim,1) < 0.5); % Flip each bit with probability 1/2
    Y = X .* (1 - probflip) + Ytemp .* probflip; % only keep flipped bits which are unclamped
end;
probYgivenX = X .* (1-probflip) + (1-X) .* probflip;

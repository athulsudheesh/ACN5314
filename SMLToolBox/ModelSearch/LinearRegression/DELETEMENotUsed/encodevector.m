function statevector = encodevector(statelist,constants)
% USAGE: statevector = encodevector(statelist,constants)

% Load Dictionary
varnames = constants.model.dictionary.varnames;
possiblevarvalue = constants.model.dictionary.possiblevarvalue;
nrvarnames = length(varnames);

% Encode State Vector
for i = 1:nrvarnames,
    statevectori = ismember(possiblevarvalue{i}{1},statelist);
    statevector(i) = statevectori;
end;

% Convert To Column Vector
statevector = statevector(:);

end


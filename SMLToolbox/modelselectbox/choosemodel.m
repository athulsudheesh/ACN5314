function modelchoice = choosemodel(modelfitrow)
% USAGE: modelchoice = choosemodel(modelfitrow)

% It is assumed that the correct model is always the first model.

[dum,minlocs] = min(modelfitrow);
if length(minlocs) > 1,
    modelchoice = minlocs(randi(minlocs,1,1));
else
    modelchoice = minlocs;
end;
end


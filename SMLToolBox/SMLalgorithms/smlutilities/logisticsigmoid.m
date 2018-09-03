function prob = logisticsigmoid(netinput)
% USAGE: prob = logisticsigmoidnetinput)
[rowdim,coldim] = size(netinput);
myepsilon = 1e-10;
prob = 1 ./ (1 + exp(-netinput));
probdim = max([rowdim,coldim]);
for i = 1:probdim,
    if prob(i) < myepsilon,
        prob(i) = myepsilon;
    end;
end;


end

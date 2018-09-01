function y = mylog(x)
% USAGE: y = mylog(x)

xdim = length(x);
myepsilon = 1e-10;
for i = 1:xdim,
    if x(i) < myepsilon,
        x(i) = myepsilon;
    end;
end;
y = log(x);
end


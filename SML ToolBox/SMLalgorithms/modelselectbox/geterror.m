function [erroravg,perform] = geterror(betavector,data)
% USAGE: [erroravg,perform] = geterror(betavector,data)
[nrrecords,nrvars] = size(data);
targ = data(:,1);
inputvectors = data(:,2:nrvars);
prob = logisticsigmoid((betavector' * inputvectors'));
errorsignals = -(   targ' .* mylog(prob) + ((1-targ') .* mylog(1 - prob))  );
erroravg = mean(errorsignals);

predictone =(prob > 0.5)';
truepositives = predictone .* targ;
truenegatives = (1-predictone) .* (1-targ);
perform.precision = sum(truepositives)/(sum(predictone) + eps);
perform.recall = sum(truepositives)/(sum(targ) + eps);
perform.percentcorrect = mean(truepositives + truenegatives);



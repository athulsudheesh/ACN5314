function fitnessvalue = getmodelfitness(statevector,constants);
% USAGE: fitnessvalue = getmodelfitness(statevector,constants);


% SETUP DATA SET
dodisplay = 0;
datamx = constants.data.eventhistory;
[nrrecords,nrvars] = size(datamx);
statevector = statevector(:);
selectedvarlocs = find(statevector == 1);
selectedvars = [1 selectedvarlocs']';
originaldatanew = datamx(:,selectedvars);
originalheader = constants.model.dictionary.varnames;
estimationonly = 0; % computes model fits (this really slows things down)
perform = linearreg(dodisplay,estimationonly,originalheader,originaldatanew,constants);
finalgradval = perform.finalgradval;
hesscondnum = perform.hesscondnum;
opgcondnum = perform.opgcondnum;
gaicmodelfit = perform.modelfits.gaic;
%bicmodelfit = perform.modelfits.bic;
maxconditionnumber = constants.inference.maxcondnum;
maxgradientnorm = constants.stoppingcriteria.gradmax;
gradnormok = (finalgradval <= maxgradientnorm);
condnumok = (hesscondnum <= maxconditionnumber) & (opgcondnum <= maxconditionnumber);
if gradnormok & condnumok,
    fitnessvalue = gaicmodelfit;
else
    fitnessvalue = inf;
end;
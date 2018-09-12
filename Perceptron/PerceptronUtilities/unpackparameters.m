function [wmatrix,vmatrix] = unpackparameters(xvector,constants,thedata)
% USAGE: [wmatrix,vmatrix] = unpackparameters(xvector,constants,thedata)

inputvectordim = thedata.inputvectordim;
nrhidden = constants.model.nrhidden;
nrtargets = thedata.nrtargets;
vvectordim = (nrhidden+1)*nrtargets;
vvector = xvector(1:vvectordim);
wvectordim = nrhidden*inputvectordim;
wvector = xvector((vvectordim+1) : (vvectordim + wvectordim));
vmatrixT = reshape(vvector,(1+nrhidden),nrtargets);
vmatrix = vmatrixT';
wmatrixT = reshape(wvector,inputvectordim,nrhidden);
wmatrix = wmatrixT';

end


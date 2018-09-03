function dotp = getdotproduct(m1,m2)
% Computes the dotproduct between two matrices or two vectors

m1vec = m1(:);
m2vec = m2(:);
dotp = m1vec'*m2vec;
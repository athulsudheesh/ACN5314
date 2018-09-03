function theangle = getangle(m1,m2)
% Computes the angle between two matrices or two vectors
% Copyright (c) 2000 by Richard Golden

m1vec = m1(:);
m2vec = m2(:);
norm1 = norm(m1vec);
norm2 = norm(m2vec);
if norm1 > 0, m1norm = m1vec/norm1; else m1norm = 0*m1vec; end;
if norm2 > 0, m2norm = m2vec/norm2; else m2norm = 0*m2vec; end;
dotp = m1norm'*m2norm;
theangle = acos(dotp)*180/pi;
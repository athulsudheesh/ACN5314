function extractdataset = extractdatagroup(originaldataset,groupid,nrgroups)
% USAGE: extractdataset = extractdatagroup(originaldataset,groupid,nrgroups)

% originaldataset is n by d matrix with n rows of d-dimensional vectors
[n,d] = size(originaldataset);
samplesizepergroup = round(n/nrgroups);
beginrow = samplesizepergroup * (groupid-1) + 1;
endrow = beginrow + samplesizepergroup - 1;
extractdataset = originaldataset(beginrow:endrow,:);
end


function printspreadsheet(simresults,filename,samplesizedim,samplesizepercentages);
% USAGE: printspreadsheet(simresults,filename,samplesizedim,samplesizepercentages);

% Generate Spreadsheet Report
for samplesizeindex = 1:samplesizedim,
    theresults = simresults{samplesizeindex};
    rowlabels = {'NNLL' 'AIC' 'GAIC' 'BIC' 'GBIC-L' 'GBICX' 'GBICP' 'GBIC','IMGOF'};
    collabels = {'TRUE' 'DECOY-DELETE-Least' 'DECOY-DELETE-2ndLeast' 'DECOY-ADDINTER'};
    resultsrowdim = length(collabels) + 1;
    disp(['Column Headers:',collabels]);
    disp(['Row Headers:',rowlabels]);
    nrcollabels = length(collabels);
    nrrowlabels = length(rowlabels); % 1/30/2016
    nrrowlabelsp1 = nrrowlabels + 1;
    for i = 1:nrrowlabelsp1, % 1/30/2016
    %for i = 1:9,
        if (i > 1),
            reportdata{i,1} = rowlabels{i-1};
            for j = 2:resultsrowdim,
                reportdata{i,j} = theresults(i-1,j-1);
            end;
        end;
        if (i == 1),
            reportdata{1,1} = ' ';
            for j = 2:resultsrowdim,
                reportdata{1,j} = collabels{j-1};
            end;
        end;
    end;
    sheettitle = [num2str(samplesizepercentages(samplesizeindex)),' percent'];
    xlswrite(['RESULTS',filename],reportdata,sheettitle);
    disp(['Report for Sample Size Percentage = ',num2str(samplesizepercentages(samplesizeindex))]);
    disp(reportdata);
    disp('---------------------------------------------------------------------------------');
    disp('   ');
end;


end


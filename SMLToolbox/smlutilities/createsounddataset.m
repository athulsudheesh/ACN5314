function createsounddataset(nrfeatures)

disp('DOMINANT FEATURE WILL BE DELETED AND INTERCEPT FEATURE WILL BE ADDED');
[filenamelist, pathname, filterindex] = uigetfile( ...
       {'*.wav','WAV-files (*.wav)'; ...
        '*.mp3','MP3-files (*.mp3)'; ...
        '*.mp4','MP4-files (*.mp4)'}, ...
        'Pick a file', ...
        'MultiSelect', 'on');
    
figure;
nrfiles = length(filenamelist);
recodedvectors = [];
for k = 1:nrfiles,
    filenamek = filenamelist{k};
    [audio_in,audio_freq_sampl]=audioread(filenamek);
    Length_audio=length(audio_in);
    df=audio_freq_sampl/Length_audio;
    frequency_audio=-audio_freq_sampl/2:df:audio_freq_sampl/2-df;
    spectrumk =fftshift(fft(audio_in))/length(fft(audio_in));
    powerspectrumk = real(abs(spectrumk));
    recodedvector = histcounts(powerspectrumk,nrfeatures);
    recodedvector = recodedvector(2:length(recodedvector)); % DELETE DOMINANT FEATURE
    recodedvector = recodedvector/(norm(recodedvector) + eps);
    recodedvector = [recodedvector 1]; % ADD INTERCEPT TO RIGHT-MOST COLUMN
    recodedvectors = [recodedvectors; (recodedvector(:))'];
    clf;
    subplot(1,2,1);
    plot(frequency_audio,powerspectrumk);
    title(['Power Spectrum ("',filenamek,'")']);
    xlabel('Frequency');
    ylabel('Amplitude');
    subplot(1,2,2);
    bar(1:nrfeatures,recodedvectors(k,:));
    title(['Recoded Vector']);
    xlabel('Feature ID');
    ylabel('Feature State Value');
    pause(3);
end;
disp('NOTE: Dominant Frequency has been deleted from coding and display.');
disp('NOTE: Intercept Has been added to right-most column');

nrfeaturesminus1 = nrfeatures - 1;
for k = 1:nrfeaturesminus1,
    featurelabel{k} = ['f',num2str(k)];
end;
featurelabel{nrfeaturesminus1+1} = 'Intercept';

% Write a spreadsheet where each row is an image
% and each column is a feature
outputfilename = 'codedsounddata.xlsx';
if exist(outputfilename),
    delete(outputfilename);
end;
[nrvectors,nrfeatures] = size(recodedvectors);
if exist(outputfilename), delete(outputfilename); end;
recodedvectorscell = num2cell(recodedvectors);
outputimage = [featurelabel; recodedvectorscell];
xlswrite(outputfilename,outputimage);
disp(['Recoded Sound Data Set has been saved to the spreadsheet "',outputfilename,'"']);



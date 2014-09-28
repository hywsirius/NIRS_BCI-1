% Name: Data to SVM
% Author: Ridoy Majumdar
% Created: August 19th, 2014
%
% The interface in calibration.m (included in this repository) displays a 
% series of images to a user and instructs them to wait for a particular 
% visual stimulus. The purpose of the function below is to process the
% tomographic data collected simultaneously by NIRStar NIRS Acquisition
% Software by NIRx. Data is classified by SVM, with the intent of isolating
% the appearance of visual stimulus (in the previous calibration procedure)
% to a particular blood oxygenation state as observed by NIRStar.

function readData(dataDirectory)
    % Move into specified directory containing data collected by NIRStar
    data = dir(dataDirectory);
    
    % Initialize vectors for holding chunks of NIRS data, separated by trial
    % Separate vectors are made for data collected at each wavelength of 
    % near-infrared light; for this project, the first was at 760 nm and the 
    % second was at 850 nm.
    targetChunksWaveOne = {};
    targetChunksWaveTwo = {};
    otherChunksWaveOne = {};
    otherChunksWaveTwo = {};
    
    % Populate data chunk vectors
    for i = 1:(length(data)-2)
        subDir = fullfile(dataDirectory, data(i+2).name);
        
        evtFileName = dir(fullfile(subDir, '*.evt'));
        evt = load(fullfile(subDir, evtFileName(1).name));
        
        wl1FileName = dir(fullfile(subDir, '*.wl1'));
        wl2FileName = dir(fullfile(subDir, '*.wl2'));
       
        wl = {};
        wl1 = load(fullfile(subDir, wl1FileName(1).name));
        wl2 = load(fullfile(subDir, wl2FileName(1).name));
        
        targetFramesWaveOne = {};
        otherFramesWaveOne = {};
        targetFramesWaveTwo = {};
        otherFramesWaveTwo = {};
        
        for j = 1:length(evt(:,1))
            if evt(j,8) == 1
                if j == length(evt(:,1))
                    targetFramesWaveOne{end+1} = wl1(evt(j,1):length(wl1),:);
                else
                    targetFramesWaveOne{end+1} = wl1(evt(j,1):evt(j+1,1),:);
                end
            else
                if j == length(evt(:,1))
                    otherFramesWaveOne{end+1} = wl1(evt(j,1):length(wl1),:);
                else
                    otherFramesWaveOne{end+1} = wl1(evt(j,1):evt(j+1,1),:);
                end
            end
        end
        
        for j = 1:length(evt(:,1))
            if evt(j,8) == 1
                if j == length(evt(:,1))
                    targetFramesWaveTwo{end+1} = wl2(evt(j,1):length(wl2),:);
                else
                    targetFramesWaveTwo{end+1} = wl2(evt(j,1):evt(j+1,1),:);
                end
            else
                if j == length(evt(:,1))
                    otherFramesWaveTwo{end+1} = wl2(evt(j,1):length(wl2),:);
                else
                    otherFramesWaveTwo{end+1} = wl2(evt(j,1):evt(j+1,1),:);
                end
            end
        end
        
        targetChunksWaveOne{i} = targetFramesWaveOne;
        targetChunksWaveTwo{i} = targetFramesWaveTwo;
        otherChunksWaveOne{i} = otherFramesWaveOne;
        otherChunksWaveTwo{i} = otherFramesWaveTwo;
    end
    
    targetDataSetOne = [];
    targetDataSetTwo = [];
    otherDataSetOne = [];
    otherDataSetTwo = [];
    
    for i = 1:length(targetChunksWaveOne)
        for j = 1:length(targetChunksWaveOne{i})
            targetDataSetOne = [targetDataSetOne; targetChunksWaveOne{i}{j}];
            targetDataSetTwo = [targetDataSetTwo; targetChunksWaveTwo{i}{j}];
        end
    end
    
    for i = 1:length(otherChunksWaveOne)
        for j = 1:length(otherChunksWaveOne{i})
            otherDataSetOne = [otherDataSetOne; otherChunksWaveOne{i}{j}];
            otherDataSetTwo = [otherDataSetTwo; otherChunksWaveTwo{i}{j}];
        end       
    end
    
    targetClassLabelAmount = length(targetDataSetOne);
    otherClassLabelAmount = length(otherDataSetOne);
    
    % Create class labels for SVM
    totalSize = targetClassLabelAmount + otherClassLabelAmount;
    classLabels = ones(totalSize,1);
    classLabels(targetClassLabelAmount:totalSize, :) = -1;
    compositeDataSetOne = [targetDataSetOne; otherDataSetOne];
    compositeDataSetTwo = [targetDataSetTwo; otherDataSetTwo];
 
    % Populate matrix with data from each channel and at each wavelength 
    for i = 1:length(compositeDataSetOne(1,:))
        dataStreams = [dataStreams compositeDataSetOne(:,i) compositeDataSetTwo(:,i)];
    end
    
    clf;
    
    % Create SVM for each channel of data
    for i = (1:length(dataStreams(1,:))/2)
        hold on;
        figure(i);
        SVMModel = svmtrain(dataStreams(:,(2*i)-1:(2*i)), classLabels, 'showplot', 'true');
        legend_handle = legend;
        set(legend_handle, 'Location', 'NorthWest');
        set(gcf, 'color', [1 1 1]);
        title(['Amplitudes observed in Channel #' num2str(i)]);
        xlabel('Amplitude at 760 nm');
        ylabel('Amplitude at 850 nm');
    end
    
    
    
    
    
    

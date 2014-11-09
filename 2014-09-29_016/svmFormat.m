%extracts data from NIRStar .evt, .wl1, and .wl2 files to save them in a
%single array called scmData, which that Matlab can analyze with an SVM.

%svmData has 25 columns. The first 12 columns are the wl1 channels. The 
%next 12 channels are the wl2 channels. The final column is a flag which is
%1 for a target frame or 0 for a distractor frame. Target frames last from
%the cue onset until traceLength frames pass.
% [wl1 data] [wl2 data] [flag]


function [svmData] = svmFormat(dataFileBaseName, traceLength)
    
    distractorEventIndex = 7;

    eventData = load([dataFileBaseName '.evt']);
    waveLength1 = load([dataFileBaseName '.wl1']); %file has 12 columns and one row for each frame
    waveLength2 = load([dataFileBaseName '.wl2']); %file has 12 columns and one row for each frame
    
    %Extract the list of frames when the event file notes a distractor
    distractorEvents = eventData(eventData(:,distractorEventIndex) == 1,1);
    %Extract the list of frames when the event file notes a target
    targetEvents = eventData(eventData(:,distractorEventIndex) == 0,1);
    
    %import target event wavelength 1 data
    [frames, channels] = size(waveLength1);
    svmData = zeros(frames, 2*channels+1);
    
    svmData(:, 1:channels) = waveLength1;
    svmData(:, channels+1:2*channels) = waveLength2;
    svmData(targetEvents:targetEvents+traceLength, 2*channels+1) = 1; %perhaps this needs to be saved as an int, not a double.
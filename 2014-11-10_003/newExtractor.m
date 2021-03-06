function [targetTraces, distractorTraces] = extractTraces(dataFileBaseName)

    distractorEventIndex = 7;
    Fs = 3.906250;
    passband = [.01, .8];
    
    [filter_b, filter_a] = butter(3, passband./(Fs/2));
    
    eventData = load([dataFileBaseName '.evt']);
    wavelength1 = filter(filter_b, filter_a, load([dataFileBaseName '.wl1']));
    wavelength2 = filter(filter_b, filter_a, load([dataFileBaseName '.wl2']));
%     wavelength1 = load([dataFileBaseName '.wl1']);
%     wavelength2 = load([dataFileBaseName '.wl2']);
%     
    trialLength = eventData(2,1) - eventData(1,1);
    % bad code bad ideas
    task1Frame = ceil((15*trialLength)/55); 
    task2Frame = ceil((35*trialLength)/55);
    
    % Trials 2, 3, and 11 have huge motion artifacts in them -- discard
    %indices = [2 3 11];
    %eventData(indices, :) = [];
    
    % Split trials into trials in which visual stimulus appeared in task I 
    % and trials in which it appeared in task II
    split1Events = eventData(eventData(:,distractorEventIndex) == 1, 1);
    split2Events = eventData(eventData(:,distractorEventIndex) == 0, 1);
    targetTracesW1 = {};
    targetTracesW2 = {};
    distractorTracesW1 = {};
    distractorTracesW2 = {};
    
    for i = 1:length(split1Events) %all the data with the rows from (distractor cue onset + task1Frame) to (cue onset + task2Frame)
        targetTracesW1{end+1} = wavelength1(split1Events(i)+task1Frame:split1Events(i)+task2Frame, :);
        targetTracesW2{end+1} = wavelength2(split1Events(i)+task1Frame:split1Events(i)+task2Frame, :);
    end
    
    for i = 1:length(split2Events) %
        targetTracesW1{end+1} = wavelength1(split2Events(i)+task2Frame:split2Events(i)+trialLength, :);
        targetTracesW2{end+1} = wavelength2(split2Events(i)+task2Frame:split2Events(i)+trialLength, :);
    end
    
    targetTraces = {targetTracesW1, targetTracesW2};
    
    for i = 1:length(split1Events)
        distractorTracesW1{end+1} = wavelength1(split1Events(i)+task2Frame:split1Events(i)+trialLength, :);
        distractorTracesW2{end+1} = wavelength2(split1Events(i)+task2Frame:split1Events(i)+trialLength, :);
    end
            
    for i = 1:length(split2Events)
        distractorTracesW1{end+1} = wavelength1(split2Events(i)+task1Frame:split2Events(i)+task2Frame, :);
        distractorTracesW2{end+1} = wavelength2(split2Events(i)+task1Frame:split2Events(i)+task2Frame, :);
    end
        
    distractorTraces = {distractorTracesW1, distractorTracesW2};
end
    
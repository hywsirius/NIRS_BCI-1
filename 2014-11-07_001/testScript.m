
[targetTraces, distractorTraces] = newExtractor('NIRS-2014-11-07_001');

numChannels = 24;

% target and distractor traces
ttraceW1 = {};ttraceW2 = {}; dtraceW1 = {}; dtraceW2 = {}; ttraceRatio = {}; dtraceRatio = {};

% normalized traces
NttraceW1 = {}; NttraceW2 = {}; NdtraceW1 = {}; NdtraceW2 = {};

DttraceRatio = {}; DdtraceW1 = {}; DdtraceW2 = {};
DdtraceRatio = {}; DttraceW1 = {}; DttraceW2 = {};
shallowChannels = [129, 130, 133, 150, 163, 164, 167, 168];
deepChannels = [131, 135, 145, 148, 149, 152, 162, 166];
channels = [deepChannels shallowChannels];
index = 1;

for channelInd = channels
    ttraceW1{channelInd} = zeros(length(targetTraces{1}{1}(:,channelInd)), length(targetTraces{1}));
    ttraceW2{channelInd} = zeros(length(targetTraces{1}{1}(:,channelInd)), length(targetTraces{1}));
    dtraceW1{channelInd} = zeros(length(distractorTraces{1}{1}(:,channelInd)), length(distractorTraces{1}));
    dtraceW2{channelInd} = zeros(length(distractorTraces{1}{1}(:,channelInd)), length(distractorTraces{1}));
    
    for i = 1:length(targetTraces{1})
        ttraceW1{channelInd}(:,i) = targetTraces{1}{i}(:, channelInd);
        ttraceW2{channelInd}(:,i) = targetTraces{2}{i}(:, channelInd);
    end
    
    for i = 1:length(distractorTraces{1})
        dtraceW1{channelInd}(:,i) = distractorTraces{1}{i}(:, channelInd);
        dtraceW2{channelInd}(:,i) = distractorTraces{2}{i}(:, channelInd);
    end
    
    %normalize every column , row(0) = 0;
    NttraceW1{channelInd} = (ttraceW1{channelInd} - (ttraceW1{channelInd}(1,:)'*ones(size(ttraceW1{channelInd},1),1)')');
    NttraceW2{channelInd} = (ttraceW2{channelInd} - (ttraceW2{channelInd}(1,:)'*ones(size(ttraceW2{channelInd},1),1)')');
    
    NdtraceW1{channelInd} = (dtraceW1{channelInd} - (dtraceW1{channelInd}(1,:)'*ones(size(dtraceW1{channelInd},1),1)')');
    NdtraceW2{channelInd} = (dtraceW2{channelInd} - (dtraceW2{channelInd}(1,:)'*ones(size(dtraceW2{channelInd},1),1)')');
    
end

for i = deepChannels
    % Corrected signals
    CttraceW1{i} = NttraceW1{i} - NttraceW1{shallowChannels(index)};
    CttraceW2{i} = NttraceW2{i} - NttraceW2{shallowChannels(index)};
    CdtraceW1{i} = NdtraceW1{i} - NdtraceW1{shallowChannels(index)};
    CdtraceW2{i} = NdtraceW2{i} - NdtraceW2{shallowChannels(index)};
    
    figure(i)
    clf
    errorbar(mean(CttraceW1{i},2), std(CttraceW1{i},1,2))
    hold on
    errorbar(mean(CdtraceW1{i},2), std(CdtraceW1{i},1,2),'r')
    index = index + 1;
end

%Creating a NttraceW1 descriptor by concatenating the output of each
%channel
numtargetTrials = size(NttraceW1{1},2);

% size(NttraceW1AllChannels)
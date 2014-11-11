traceLength = 100;
[targetTraces, distractorTraces, randomTraces] = extractTraces('NIRS-2014-09-29_019' , traceLength);

distractorTraces = randomTraces

numChannels = 8;

% target and distractor traces
ttraceW1 = {};ttraceW2 = {}; dtraceW1 = {}; dtraceW2 = {}; ttraceRatio = {}; dtraceRatio = {};

% normalized traces
NttraceW1 = {}; NttraceW2 = {}; NdtraceW1 = {}; NdtraceW2 = {}; 

DttraceRatio = {}; DdtraceW1 = {}; DdtraceW2 = {};
DdtraceRatio = {}; DttraceW1 = {}; DttraceW2 = {};

for channelInd = 1:numChannels
figure(channelInd)
clf

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

ttraceRatio{channelInd} = ttraceW1{channelInd}./(abs(ttraceW2{channelInd}) + abs(ttraceW1{channelInd}));
dtraceRatio{channelInd} = dtraceW1{channelInd}./(abs(dtraceW2{channelInd}) + abs(dtraceW1{channelInd}));

DttraceRatio{channelInd} = diff(ttraceRatio{channelInd});
DdtraceRatio{channelInd} = diff(dtraceRatio{channelInd});


DttraceW1{channelInd} = diff(ttraceW1{channelInd});
DttraceW2{channelInd} = diff(ttraceW2{channelInd});

%normalize every column , row(0) = 0;
NttraceW1{channelInd} = (ttraceW1{channelInd} - (ttraceW1{channelInd}(1,:)'*ones(size(ttraceW1{channelInd},1),1)')');
NttraceW2{channelInd} = (ttraceW2{channelInd} - (ttraceW2{channelInd}(1,:)'*ones(size(ttraceW2{channelInd},1),1)')');

NttraceRatio{channelInd} = (NttraceW2{channelInd} - (NttraceW2{channelInd}(1,:)'*ones(size(NttraceW2{channelInd},1),1)')');

NdtraceW1{channelInd} = (dtraceW1{channelInd} - (dtraceW1{channelInd}(1,:)'*ones(size(dtraceW1{channelInd},1),1)')');
NdtraceW2{channelInd} = (dtraceW2{channelInd} - (dtraceW2{channelInd}(1,:)'*ones(size(dtraceW2{channelInd},1),1)')');

NdtraceRatio{channelInd} = (NdtraceW2{channelInd} - (NdtraceW2{channelInd}(1,:)'*ones(size(NdtraceW2{channelInd},1),1)')');



%DttraceRatio{channelInd} = DttraceW2{channelInd}./(DttraceW1{channelInd} + DttraceW2{channelInd});

DdtraceW1{channelInd} = diff(dtraceW1{channelInd});
DdtraceW2{channelInd} = diff(dtraceW2{channelInd});
%keyboard;
%DdtraceRatio{channelInd} = DdtraceW2{channelInd}./(DdtraceW1{channelInd} + DdtraceW2{channelInd});



%errorbar(mean(NttraceW1{channelInd},2), std(NttraceW1{channelInd},1,2))
% errorbar(mean(DttraceW2{channelInd},2), std(DttraceW2{channelInd},0,2))
 errorbar(mean(ttraceRatio{channelInd},2), std(ttraceRatio{channelInd},0,2))
hold on
%errorbar(mean(NdtraceW1{channelInd},2), std(NdtraceW1{channelInd},1,2),'r')
% errorbar(mean(DdtraceW2{channelInd},2), std(DdtraceW2{channelInd},0,2),'r')
 errorbar(mean(dtraceRatio{channelInd},2), std(dtraceRatio{channelInd},0,2),'r')
end

%Creating a NttraceW1 descriptor by concatenating the output of each
%channel
numtargetTrials = size(NttraceW1{1},2);

% size(NttraceW1AllChannels)
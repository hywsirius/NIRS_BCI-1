function blockClassifier(targetSet, distractorSet);
% each dataset: c channels, each with matrix of size observations by trials

targets = [];
distractors = [];
startInd = 20;
endInd = 60;

tf = {};
for i = 1:length(targetSet)
    targetSetTemp = targetSet{i}(startInd:endInd);
    tf{i} = reshape(targetSetTemp, numel(targetSetTemp),1);    
end
targets = horzcat(tf{:});

for i = 1:length(distractorSet)
    tf = [];
    for j = 1:length(distractorSet{i}(1,:))
        tf = [tf; distractorSet{i}(:,j)];
    end
    distractors = [distractors, tf];
end

trialFlags = [ones(size(targetSet{1},2), 1); (-1 * ones(size(targetSet{1},2), 1))]; 
frameFlags = [ones(length(targets),1); (-1 * ones(length(distractors), 1))];

blockData = [targets; distractors];
nFrames = endInd - startInd;
blockData = [blockData(:,4), blockData(:,7)];
for i = 1:length(trialFlags(:,1))/2
    ind = true(length(blockData(:,1)),1); 
    ind(1 + (nFrames*(i-1)):(nFrames*(i))) = false;
    ind(1 + (nFrames*(i-1 + (length(trialFlags(:,1))/2))):(nFrames*(i + (length(trialFlags(:,1))/2)))) = false;

    trainingData = blockData(ind, :);
    trainingFlags = frameFlags(ind, :);
    
    testData = blockData(~ind,:);
    
    testFlags = frameFlags(~ind,:);
    SVMModel = fitcsvm(trainingData, trainingFlags, 'KernelFunction', 'rbf', 'standardize', 'on');
    
    [predictedFlag, Score] = predict(SVMModel, testData);
%         [predictedFlags, Score] = predict(SVMModel, testingData);
    
      a = sum(abs(testFlags - predictedFlag))/2;
      figure(i)
      clf
      plot(predictedFlag);
%     a = sum(abs(testFlags(1:length(testFlags)/2,1) - predictedFlag(1:length(predictedFlag)/2,1)));
%     b = sum(abs(testFlags(length(testFlags)/2:end,1) - predictedFlag(length(predictedFlag)/2:end,1)));
    % compare to actual flag
    display(a);
end

    % nPredictedTargets = sum(predictedFlags);
% fprintf('Number of frames to be predicted: %f\n', length(predictedFlags))
% fprintf('Number of actual targets: %f\n', sum(testingFlags))
% fprintf('Number of frames predicted to be targets: %f\n', nPredictedTargets)
% correct(predictedFlags == testingFlags) = 1;
% percentCorrect = sum(correct)/length(predictedFlags);
% fprintf('Percentage of frames correctly predicted: %f\n', percentCorrect)

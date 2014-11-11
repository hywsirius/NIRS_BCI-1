function [nPredictedTargets, percentCorrect, predictedFlags] = classifier(targetSet, distractorSet)
% each dataset: c channels, each with matrix of size observations by trials
intervalStart = 45;
intervalEnd = 60;

meanTargetSet = {}; meanDistractorSet = {};
for i = 1:length(targetSet)    
    meanTargetSet{i} = mean(abs(targetSet{i}(intervalStart:intervalEnd,:)),1);
end

for i = 1:length(distractorSet)
    meanDistractorSet{i} = mean(abs(distractorSet{i}(intervalStart:intervalEnd,:)),1);
end

% for each channel, split half of the data into training data

targetsLength = length(meanTargetSet{i});
distractorsLength = length(meanDistractorSet{i});
orderedpair = [];
% accuracyGraph = [];
% for q = 1:99
    trainingFactor = .5;
    trainingData = [];
    testingData = [];
    tempTraning = [];
    tempTesting = [];
    
    
    numTraining = ceil(targetsLength*trainingFactor)
    meanTargetSetArray = vertcat(meanTargetSet{:});
    meanDistractorSetArray = vertcat(meanDistractorSet{:});
    trainingData = horzcat(meanTargetSetArray(:,1:numTraining), meanDistractorSetArray(:,1:numTraining))';
    testingData = horzcat(meanTargetSetArray(:,numTraining + 1:end), meanDistractorSetArray(:,numTraining + 1:end))';
    totalArray = horzcat(meanTargetSetArray, meanDistractorSetArray)';
    
    
    trainingFlags = [ones(ceil(targetsLength*trainingFactor),1); zeros(ceil(distractorsLength*trainingFactor),1)];
    testingFlags = [ones(targetsLength - ceil(targetsLength*trainingFactor),1); zeros(distractorsLength - ceil(distractorsLength*trainingFactor), 1)];
    totalFlags = [ones(targetsLength,1); zeros(distractorsLength,1)];
    
    SVMModel = fitcsvm(totalArray, totalFlags, 'KernelFunction', 'rbf', 'Standardize',1,'Crossval','on','leaveout','on');
    keyboard
    [predictedFlags, Score] = predict(SVMModel, testingData);
    
    nPredictedTargets = sum(predictedFlags);
    fprintf('Number of frames to be predicted: %f\n', length(predictedFlags))
    fprintf('Number of actual targets: %f\n', sum(testingFlags))
    fprintf('Number of frames predicted to be targets: %f\n', nPredictedTargets)
    correct(predictedFlags == testingFlags) = 1;
    percentCorrect = sum(correct)/length(predictedFlags);
    fprintf('Percentage of frames correctly predicted: %f\n', percentCorrect)
%     orderedpair = [q, percentCorrect];
%     accuracyGraph = [accuracyGraph; orderedpair];
% end

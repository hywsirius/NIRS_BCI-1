function [nPredictedTargets, percentCorrect, predictedFlags] = classifier(targetSet, distractorSet);
% each dataset: c channels, each with matrix of size observations by trials
for i = 1:length(targetSet)
    targetSet{i} = mean(targetSet{i},2);
end

for i = 1:length(distractorSet)
    distractorSet{i} = mean(distractorSet{i},2);
end

% for each channel, split half of the data into training data
trainingData = [];
testingData = [];
tempTraning = [];
tempTesting = [];
targetsLength = length(targetSet{i}(:,1));
distractorsLength = length(distractorSet{i}(:,1));
trainingFactor = .05;

for i = 1:length(targetSet)
    tempTraining = [targetSet{i}(1:ceil(targetsLength*trainingFactor),1); distractorSet{i}(1:ceil(distractorsLength*trainingFactor),1)];
    trainingData = [trainingData, tempTraining];
    tempTesting = [targetSet{i}(ceil(targetsLength*trainingFactor)+1:targetsLength,1); distractorSet{i}(ceil(distractorsLength*trainingFactor)+1:distractorsLength,1)];
    testingData = [testingData, tempTesting];
end

trainingFlags = [ones(ceil(targetsLength*trainingFactor),1); zeros(ceil(distractorsLength*trainingFactor),1)];
testingFlags = [ones(targetsLength - ceil(targetsLength*trainingFactor),1); zeros(distractorsLength - ceil(distractorsLength*trainingFactor), 1)];

SVMModel = fitcsvm(trainingData, trainingFlags, 'KernelFunction', 'rbf');
[predictedFlags, Score] = predict(SVMModel, testingData);

nPredictedTargets = sum(predictedFlags);
fprintf('Number of frames to be predicted: %f\n', length(predictedFlags))
fprintf('Number of actual targets: %f\n', sum(testingFlags))
fprintf('Number of frames predicted to be targets: %f\n', nPredictedTargets)
correct(predictedFlags == testingFlags) = 1;
percentCorrect = sum(correct)/length(predictedFlags);
fprintf('Percentage of frames correctly predicted: %f', percentCorrect)

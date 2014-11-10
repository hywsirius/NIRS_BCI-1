function [nPredictedTargets, percentCorrect, predictedFlags, solutionsTable] = classifier(targetSet, distractorSet);
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
for i = 1:length(targetSet)
    tempTraining = [targetSet{i}(1:ceil(targetsLength/2),1); distractorSet{i}(1:ceil(distractorsLength/2),1)];
    trainingData = [trainingData, tempTraining];
    tempTesting = [targetSet{i}(ceil(targetsLength/2)+1:targetsLength,1); distractorSet{i}(ceil(distractorsLength/2)+1:distractorsLength,1)];
    testingData = [testingData, tempTesting];
end

trainingFlags = [ones(ceil(targetsLength/2),length(targetSet)); zeros(ceil(distractorsLength/2),length(distractorSet))];
SVMModel = fitcsvm(trainingData, trainingFlags, 'KernelFunction', 'rbf');
actual
[testFlags, Score] = predict(SVMModel, testingData);

actualFlags = [ones(targetsLength - ceil(targetsLength/2), length(targetSet)); zeros(distractorLength - ceil(distractorLength/2), length(distractorSet))];
% nPredictedTargets = sum(predictedFlags);
fprintf('Number of frames to be predicted: %f\n', length(predictedFlags))
fprintf('Number of actual targets: %f\n', sum(actualFlags))
fprintf('Number of frames predicted to be targets: %f\n', nPredictedTargets)
correct(predictedFlags == actualFlags) = 1;
percentCorrect = sum(correct)/length(predictedFlags);
fprintf('Percentage of frames correctly predicted: %f', percentCorrect)

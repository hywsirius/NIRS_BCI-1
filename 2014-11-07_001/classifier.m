function [nPredictedTargets, percentCorrect, predictedFlags, solutionsTable] = classifier(targetSet, distractorSet);
% each dataset: c channels, each with matrix of size observations by trials
for i = 1:length(targetSet)
    targetSet{i} = mean(targetSet{i},2);
end

for i = 1:length(distractorSet)
    distractorSet{i} = mean(distractorSet{i},2);
end

trainingData = {};
% for each channel, split half of the data into training data
for i = 1:length(targetSet)
    trainingData{i} = ;
    
end

nPredictedTargets = 100;
percentCorrect = 100;
predictedFlags = 100;
solutionsTable = 100;

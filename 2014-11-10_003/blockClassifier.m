function blockClassifier(targetSet, distractorSet)
% each dataset: c channels, each with matrix of size observations by trials

targets = [];
distractors = [];
startInd = 1;
endInd = 77;

tf = {};
for i = 1:length(targetSet)
    targetSetTemp = targetSet{i}(startInd:endInd,:);
    tf{i} = reshape(targetSetTemp, numel(targetSetTemp),1);    
end
targets = horzcat(tf{:});

for i = 1:length(distractorSet)
    distractorSetTemp = distractorSet{i}(startInd:endInd,:);
    tf{i} = reshape(distractorSetTemp, numel(distractorSetTemp),1);    
end
distractors = horzcat(tf{:});

trialFlags = [ones(size(targetSet{1},2), 1); (-1 * ones(size(targetSet{1},2), 1))]; 
frameFlags = [ones(length(targets),1); (-1 * ones(length(distractors), 1))];

blockData = [targets; distractors];
nFrames = endInd - startInd + 1;
for g = 1:length(blockData(1,:))
    tempBlockData = blockData(:,g);
    nCorrectTClass = 1;
    nIncorrectTClass = 1;
    nCorrectDClass = 1;
    nIncorrectDClass = 1;
    
    for i = 1:length(trialFlags(:,1))/2
        ind = true(length(tempBlockData(:,1)),1);
        ind(1 + (nFrames*(i-1)):(nFrames*(i))) = false;
        
        ind(1 + (nFrames*(i-1 + (length(trialFlags(:,1))/2))):(nFrames*(i + (length(trialFlags(:,1))/2)))) = false;
        
        trainingData = tempBlockData(ind, :);
        trainingFlags = frameFlags(ind, :);
        
        testData = tempBlockData(~ind,:);
        testFlags = frameFlags(~ind,:);
        
        SVMModel = fitcsvm(trainingData, trainingFlags, 'KernelFunction', 'linear', 'standardize', 'on');
        
        [predictedTargetFlags, TScore] = predict(SVMModel, testData(1:(length(testData)/2), :));
        [predictedDistractorFlags, DScore] = predict(SVMModel, testData((length(testData)/2):end, :));
        a = sum(predictedTargetFlags);
        b = sum(predictedDistractorFlags);
        
        if a > 0
            nCorrectTClass = nCorrectTClass + 1;
        else
            nIncorrectTClass = nIncorrectTClass + 1;
        end
        
        if b < 0
            nCorrectDClass = nCorrectDClass + 1;
        else
            nIncorrectDClass = nIncorrectDClass + 1;
        end
    end

display(['Pcnt. correct target classifications (Channel ' num2str(q) '):' num2str(nCorrectTClass/(nIncorrectTClass+nCorrectTClass))]);
display(['Pcnt. correct distractor classifications (Channel ' num2str(q) '):' num2str(nCorrectDClass/(nCorrectDClass+nIncorrectDClass))]);
end
% nPredictedTargets = sum(predictedFlags);
% fprintf('Number of frames to be predicted: %f\n', length(predictedFlags))
% fprintf('Number of actual targets: %f\n', sum(testingFlags))
% fprintf('Number of frames predicted to be targets: %f\n', nPredictedTargets)
% correct(predictedFlags == testingFlags) = 1;
% percentCorrect = sum(correct)/length(predictedFlags);
% fprintf('Percentage of frames correctly predicted: %f\n', percentCorrect)

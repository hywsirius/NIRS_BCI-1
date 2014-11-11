%Use an SVM to analyze the raw NIRStar data

traceLength = 100;
svmData = svmFormat('NIRS-2014-09-29_016', traceLength);
[frames, columns] = size(svmData);
channels = (columns-1)/2; %channels is calculated both in the script and in the function. Must be better way.

noFlagData = svmData(:, 1:2*channels);
flags = boolean(svmData(:, 2*channels+1));
%SVMModel = fitcsvm(noFlagData, flags, 'KernelFunction', 'rbf', 'Standardize', true);
SVMModel = fitcsvm(noFlagData, flags);
function separability_score = MLD_Calculate_SVM_Separability(InpObs,InpCls)
% Assuming X is your data and Y are the labels

% Train the SVM
SVMModel = fitcsvm(InpObs, InpCls, 'KernelFunction','linear', 'BoxConstraint',1);

% Calculate the score (distance to hyperplane) for each instance
[~, score] = predict(SVMModel, InpObs);

% Assuming score is your separability matrix
separability_score = mean(abs(score(:,2)));

% The score is a measure of separability. You can compute its mean, median, etc.
end
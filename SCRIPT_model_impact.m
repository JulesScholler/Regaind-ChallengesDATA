% Train a SVM using the pre-generated features to predict the impact
%
% Return values:
%   - SVM_model: trained SVM model

% Load the config parameters
SCRIPT_config;

% Load the data
SCRIPT_load_meta;       % metadata for test and train
SCRIPT_load_impact;     % impact for train
SCRIPT_generate_histo;  % histogram for test and train
SCRIPT_generate_vgg;    % vgg face for test and train

% Assemble the data
data_train  = [meta_train hist_train face_train];
score_train = impact_train(:,11);

% Set parameters
n_fold = 10;            % cross-validation parameters

% Do cross-validation training for evaluation
idx = randperm(10000);          % randomisation indices
eval = zeros(1,n_fold);         % impact evaluation
for i = 1:n_fold
    tic
    % Generate the CV train and test dataset and corresponding scores
    sep_inf = 1+ floor((i-1)*10000/n_fold);         % inferior separator
    sep_sup = floor(i*10000/n_fold);                % superior separator  
    idx_CV_test  = idx(sep_inf:sep_sup);            % CV test indices
    idx_CV_train = idx;                             % CV train indices
    idx_CV_train(sep_inf:sep_sup) = [];             % remove test indices
    data_CV_test   = data_train(idx_CV_test,:);     % CV test data   
    data_CV_train  = data_train(idx_CV_train,:);    % CV train data
    score_CV_test  = score_train(idx_CV_test);      % CV test score
    score_CV_train = score_train(idx_CV_train);     % CV train score
    
    % Train the SVM
    SVM_model = fitrsvm(data_CV_train,score_CV_train,'KernelFunction','Linear','Standardize',true);
    
    % Predict scores
    predict_CV_test = predict(SVM_model,data_CV_test);
    
    % Evaluate method
    eval(i) = mean((score_CV_test-predict_CV_test).^2);
    
    % Display progress
    toc
    fprintf('Cross-validation iteration %i out of %i: %f\n',i,n_fold,eval(i))
    break
end

% Display results
fprintf('SVM cross validation done, average: %f\n',mean(eval))
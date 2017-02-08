% Train a SVM using the pre-generated features and save it in the file
% SVM_model.mat
%
% Return values:
%   - SVM_model: trained SVM model

% Load the config parameters
SCRIPT_config;

% Load the data
<<<<<<< HEAD
% SCRIPT_load_meta;               % metadata
% SCRIPT_load_impact;             % impact
% SCRIPT_load_score;              % aesthetics
% SCRIPT_generate_histo;          % histogram
% SCRIPT_generate_vgg;            % vgg face
% SCRIPT_generate_basic_quality;  % basic quality
% SCRIPT_generate_sharpness;      % sharpness
% SCRIPT_generate_symmetry;       % symmetry
=======
% SCRIPT_load_impact;             % impact
% SCRIPT_generate_histo;          % histogram
% SCRIPT_generate_vgg;            % vgg face
SCRIPT_load_meta;               % metadata
SCRIPT_load_score;              % aesthetics
SCRIPT_generate_basic_quality;  % basic quality
SCRIPT_generate_sharpness;      % sharpness
SCRIPT_generate_compositional;  % composition
SCRIPT_generate_symmetry;       % symmetry
SCRIPT_generate_circles;        % number of circles
>>>>>>> origin/master

% Assemble the data
% data_train = meta_train;
data_train = [meta_train basic_qual_train sharpness_train ...
    compositional_train sym_train circ_train];

% Set parameters
n_fold = 10;            % cross-validation parameters

% Do cross-validation training for evaluation
idx = randperm(10000);          % randomisation indices
rank_eval = zeros(1,n_fold);    % pearson ranking correlation
for i = 1:n_fold
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
    SVM_model = fitrsvm(data_CV_train,score_CV_train,'KernelFunction','Gaussian','Standardize',true,'KernelScale','auto');
%     SVM_model = fitrlinear(data_CV_train,score_CV_train);
    
    % Predict scores
    predict_CV_test = predict(SVM_model,data_CV_test);
    
    % Evaluate method
    [rank_eval(i),~] = corr(score_CV_test,predict_CV_test,'type','Spearman')
end

% Display results
fprintf('SVM cross validation done, average: %f\n',mean(rank_eval))

%% Train the overall SVM
SVM_model = fitrsvm(data_train,score_train,'KernelFunction','Gaussian','Standardize',true,'KernelScale','auto');
save('SVM_model.mat', 'SVM_model')
disp('SVM trained and saved.')
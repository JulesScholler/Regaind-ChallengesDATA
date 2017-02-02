% Predicts the exposure impact
%
% Return values:
%   - SVM_model: trained SVM model

% Load the config parameters
SCRIPT_config;

% Load the data
SCRIPT_load_meta;           % metadata for test and train
SCRIPT_load_impact;         % impact for train
SCRIPT_generate_exposure;   % exposure features

% Assemble the data
data_train = expo_train;
exposure_p = impact_train(:,9);
exposure_n = impact_train(:,10);

% % Plot the best and worst exposures and their corresponding histograms
% idx = find(exposure_p == max(exposure_p));
% best = idx(randperm(numel(idx),9));
% exp_best = exposure_p(best);
% figure('name', 'Best exposure picture');
% for i = 1:9
%     subplot(3,3,i);
%     imshow(imread(['Data/train/pictures_train/' num2str(best(i)) '.jpg']));
%     title(num2str(best(i)));
% end
% figure('name', 'Best exposure histogram');
% for i = 1:9
%     subplot(3,3,i);
%     bar(cumsum(hist_train(best(i),:))/sum(hist_train(best(i),:)));
%     title(num2str(best(i)));
% end
% idx = find(exposure_n == min(exposure_n));
% worst = idx(randperm(numel(idx),9));
% exp_worst = exposure_n(worst);
% figure('name', 'Worst exposure picture');
% for i = 1:9
%     subplot(3,3,i);
%     imshow(imread(['Data/train/pictures_train/' num2str(worst(i)) '.jpg']));
%     title(num2str(worst(i)));
% end
% figure('name', 'Worst exposure histogram');
% for i = 1:9
%     subplot(3,3,i);
%     bar(cumsum(hist_train(worst(i),:))/sum(hist_train(worst(i),:)));
%     title(num2str(worst(i)));
% end

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
    score_CV_test  = exposure_n(idx_CV_test);       % CV test score
    score_CV_train = exposure_n(idx_CV_train);      % CV train score
    
    % Train the SVM
    SVM_model = fitrsvm(data_CV_train,score_CV_train,'KernelFunction','gaussian');
%     SVM_model = fitrlinear(data_CV_train,score_CV_train,'Regularization','lasso');
    
    % Predict scores
    predict_CV_test = predict(SVM_model,data_CV_test);
    
    % Evaluate method
    eval(i) = sqrt(mean((score_CV_test-predict_CV_test).^2));
    
    % Display progress
    toc
    fprintf('Cross-validation iteration %i out of %i: %f\n',i,n_fold,eval(i))
end

% Display results
fprintf('SVM cross validation done, average: %f\n',mean(eval))
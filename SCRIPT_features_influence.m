% Train a SVM using the pre-generated features and save it in the file
% SVM_model.mat
%
% Return values:
%   - SVM_model: trained SVM model

% Load the config parameters
SCRIPT_config;

% Load the data
% SCRIPT_load_impact;             % impact
% SCRIPT_generate_histo;          % histogram
% SCRIPT_generate_vgg;            % vgg face
SCRIPT_load_meta;                   % metadata
SCRIPT_load_score;                  % aesthetics
SCRIPT_generate_basic_quality;      % basic quality
SCRIPT_generate_sharpness;          % sharpness
SCRIPT_generate_compositional;      % composition
SCRIPT_generate_symmetry;           % symmetry
SCRIPT_generate_circles;            % number of circles
SCRIPT_generate_spectral_saliency   % spectral saliency

% Assemble the data
% data_train = meta_train;
% data_train = [meta_train basic_qual_train sharpness_train ...
%     compositional_train sym_train circ_train spectral_saliency_train];
data_train=[meta_train blur_train(:,2:end)];
% Kernel
% data_train= sign(data_train).*sqrt(abs(data_train)); % Hellinger
% Data Standardization (= 'Standardized':'true' when calling fitrsvm)
data_train=(data_train-repmat(mean(data_train,1),[10000 1]))./repmat(std(data_train,0,1),[10000 1]);

% Set parameters
n_fold = 10;            % cross-validation parameters

% Do cross-validation training for evaluation
idx = randperm(10000);          % randomisation indices
rank_eval = zeros(1,n_fold);    % pearson ranking correlation
predict_CV_test=zeros(1000,10);
err=zeros(10,24);
m=zeros(10,24);
for i = 1:10
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
    SVM_model = fitrsvm(data_CV_train,score_CV_train,'KernelFunction','Gaussian','KernelScale','auto');
%     SVM_model = fitrlinear(data_CV_train,score_CV_train);
    
    % Predict scores
    predict_CV_test(:,i) = predict(SVM_model,data_CV_test);
    
    % Evaluate method
    [rank_eval(i),~] = corr(score_CV_test,predict_CV_test(:,i),'type','Spearman')
    tmp=predict_CV_test(:,i);
    for j=0:24
        err(i,j+1)=std(tmp(score_CV_test==j));
        m(i,j+1)=mean(tmp(score_CV_test==j));
    end
end
err=mean(err);
m=mean(m);
figure
errorbar(0:24,m,err,'--+r')
ylim([0 24])
xlim([-1 25])
xlabel 'Ground truth'
ylabel 'Prediction'
set(gca,'FontSize',15)
% Display results
fprintf('SVM cross validation done, average: %f\n',mean(rank_eval))
% Load paths
SCRIPT_config;
filename_test = [cfg.dir_data 'test/facial_features_test.csv'];
filename_train = [cfg.dir_data 'train/facial_features_train.csv'];
filename_score = [cfg.dir_data 'train/Score_train.csv'];

% Load data
if ~exist('data','var')
    data=load_data(filename_train);
    load([cfg.dir_data 'train/hist_features.mat'])
    data=[data hist_features];
    load([cfg.dir_data 'train/blur_features_train.mat'])
    data=[data blur_features];
end
if ~exist('score','var')
    score=load7(filename_score);
end

% Randomize data order
ind=randperm(10000)';
score_rand=score(ind);
data_rand=data(ind,:);

% L2 normalize the histograms before running the linear SVM
% data_rand= bsxfun(@times, data_rand, 1./sqrt(sum(data_rand.^2,1))) ;
% L1 normalize the histograms before running the linear SVM
data_rand = bsxfun(@times, data_rand, 1./sum(abs(data_rand),1)) ;
% Kernel
data_rand= sign(data_rand).*sqrt(abs(data_rand));

% Loop for cross-validation evalutation
for i=1:10
    % 10-fold partition
    [data_train,data_test]=CV(data_rand,10,i);
    [score_train,score_test]=CV(score_rand,10,i);
    % Train SVM
    Mdl = fitrsvm(data_train,score_train,'KernelFunction','Linear','Standardize',true);
    % Predict scores
    score_predict=predict(Mdl,data_test);
    % Evaluate method
    [RHO(i),~] = corr(score_test,score_predict,'type','Pearson');
end
mean(RHO)

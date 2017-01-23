% Load paths
addpath('./fun')
addpath('./data')
pathname='/Volumes/500GO Jules/Wavelet/Data/';
filename_test = [pathname 'test/facial_features_test.csv'];
filename_train = [pathname 'train/facial_features_train.csv'];
filename_score = [pathname 'Score_train.csv'];

% Load data
if ~exist('data','var')
    data=load_data(filename_train);
    load('/Volumes/500GO Jules/Wavelet/Data/train/hist_features.mat')
    data=[data hist_features];
    load('CNN_features.mat')
    data=[data CNN_features];
end
if ~exist('score_train','var')
    score=load7(filename_score);
end

% Randomize data order
ind=randperm(10000)';
score_rand=score(ind);
data_rand=data(ind,:);

% Loop for cross-validation evalutation
for i=1:10
    % 10-fold partition
    [data_train,data_test]=CV(data_rand,10,i);
    [score_train,score_test]=CV(score_rand,10,i);
    % Train SVM
    Mdl = fitrsvm(data_train,score_train,'KernelFunction','gaussian','KernelScale','auto','Standardize',true);
    % Predict scores
    score_predict=predict(Mdl,data_test);
    % Evaluate method
    [RHO(i),~] = corr(score_test,score_predict,'type','Pearson');
end
mean(RHO)
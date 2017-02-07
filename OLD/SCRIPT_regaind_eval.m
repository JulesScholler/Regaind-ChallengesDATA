% Parameters
SCRIPT_config;
filename_test = [cfg.dir_data 'test/facial_features_test.csv'];
filename_train = [cfg.dir_data 'train/facial_features_train.csv'];
filename_score = [cfg.dir_data 'train/Score_train.csv'];

% Load data
if ~exist('data.test','var')
    data.test=load_data(filename_test);
    load([cfg.dir_data 'test/hist_features.mat'])
    data.test=[data.test hist_features];
    load([cfg.dir_data 'test/blur_features_test.mat'])
    data.test=[data.test blur_features];
end
if ~exist('data.train','var')
    data.train=load_data(filename_train);
    load([cfg.dir_data 'train/hist_features.mat'])
    data.train=[data.train hist_features];
    load([cfg.dir_data 'train/blur_features_train.mat'])
    data.train=[data.train blur_features];
end
if ~exist('score_train','var')
    score_train=load7(filename_score);
end

% % L1 normalize the histograms before running the linear SVM
data_train = bsxfun(@times, data.train, 1./sum(abs(data.train),1)) ;
data_test = bsxfun(@times, data.test, 1./sum(abs(data.test),1)) ;
% % Kernel
data_train= sign(data_train).*sqrt(abs(data_train));
data_test= sign(data_test).*sqrt(abs(data_test));
% Train SVM
Mdl = fitrsvm(data_train,score_train,'KernelFunction','Linear','Standardize',true);

% Predict scores
score_test=predict(Mdl,data_test);

% Export data
ID=(1:3000)';
csvwrite('test.csv',['ID' 'TARGET'])
dlmwrite('test.csv',[ID round(score_test)],'delimiter',';','-append')


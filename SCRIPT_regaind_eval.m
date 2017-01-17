% Parameters
pathname='/Volumes/500GO Jules/Wavelet/Data/';
filename_test = [pathname 'test/facial_features_test.csv'];
filename_train = [pathname 'train/facial_features_train.csv'];
filename_score = [pathname 'Score_train.csv'];

% Load data
if ~exist('data_test','var')
    data_test=load_data(filename_test);
    load('/Volumes/500GO Jules/Wavelet/Data/test/hist_features.mat')
    data_test=[data_test hist_features];
end
if ~exist('data_train','var')
    data_train=load_data(filename_train);
    load('/Volumes/500GO Jules/Wavelet/Data/train/hist_features.mat')
    data_train=[data_train hist_features];
end
if ~exist('score_train','var')
    score_train=load7(filename_score);
end


% Train SVM
Mdl = fitrsvm(data_train,score_train,'KernelFunction','gaussian','KernelScale','auto','Standardize',true);

% Predict scores
score_test=predict(Mdl,data_test);

% Export data
ID=(1:3000)';
csvwrite('test.csv',['ID' 'TARGET'])
dlmwrite('test.csv',[ID round(score_test)],'delimiter',';','-append')


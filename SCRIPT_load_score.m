% Load all score data provided by Regaind for the train data then save
% it in the file scores.mat
%
% Return values:
%   - score_train: aesthetics scores for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('scores.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from scores.mat')
    load('scores.mat');
else
    % Load the data
    fileID = fopen(cfg.scores_train,'r');
    dataArray = textscan(fileID, '%*s%f%[^\n\r]', 'Delimiter', ';', 'EmptyValue', NaN, 'HeaderLines', 1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    score_train = dataArray{1};

    % Clear variables
    clear ans dataArray fileID;

    % Save data
    save('scores.mat','score_train')
    disp('Scores done.')
end
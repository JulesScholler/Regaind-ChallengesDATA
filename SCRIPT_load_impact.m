% Load all impact data provided by Regaind for the train data then save
% it in the file impact_features.mat
%
% Return values:
%   - impact_train: impact features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('impact_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from impact_features.mat')
    load('impact_features.mat');
else
    % Load the data
    formatSpec = '%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
    fileID = fopen(cfg.facial_features_train,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', ',', 'HeaderLines', 1, 'ReturnOnError', false);
    fclose(fileID);

    % Convert the data to numeric
    impact_train = zeros(10000,12);
    for col = 1:12
        impact_train(:,col) = cellfun(@str2num,dataArray{col}); 
    end

    % Clear variables
    clear ans col dataArray fileID formatSpec;

    % Save data
    save('impact_features.mat','impact_train')
    disp('Impact features done.')
end
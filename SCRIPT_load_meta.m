% Load all metadata provided by Regaind for both the train and test data 
% then save it in the file meta_features.mat
%
% Return values:
%   - meta_test: meta features for the test dataset
%   - meta_train: meta features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('meta_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from meta_features.mat')
    load('meta_features.mat');
else
    % Load the data
    formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
    fileID_test     = fopen(cfg.facial_features_test,'r');
    fileID_train    = fopen(cfg.facial_features_train,'r');
    dataArray_test  = textscan(fileID_test, formatSpec, 'Delimiter', ',', 'HeaderLines', 1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    dataArray_train = textscan(fileID_train, formatSpec, 'Delimiter', ',', 'HeaderLines', 1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID_test);
    fclose(fileID_train);

    % Convert numeric data
    numCol = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21, ...
        22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41, ...
        42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61, ...
        62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77, ...
        85,86,87,88,89,90,91,92,93,94];
    meta_train = NaN(10000, numel(numCol));
    meta_test = NaN(3000, numel(numCol));
    for i = 1:numel(numCol)
        meta_test(:,i) = cellfun(@str2num,dataArray_test{numCol(i)}); 
        meta_train(:,i) = cellfun(@str2num,dataArray_train{numCol(i)}); 
    end

    % Special case :
    %   - 78, age: replace None with -1
    meta_test  = [meta_test ...
        cellfun(@str2num,strrep(dataArray_test{78},'None','-1'))];
    meta_train = [meta_train ...
        cellfun(@str2num,strrep(dataArray_train{78},'None','-1'))];

    % Special case:
    %   - 79/80, gender/confidence_gender: positive confidence for male, 
    %   negative for woman, 0 for None
    %   - 81/82, left_eye/confidence_left_eye: positive confidence for open, 
    %   negative for closed and 0 for None
    %   - 83/84, right_eye/confidence_right_eye: positive confidence for open, 
    %   negative for closed and 0 for None
    for col = [79, 81, 83]

        % Train data
        if col == 79
            temp = strrep(dataArray_train{col},'female','-1');
            temp = strrep(temp,'male','1');
        else
            temp = strrep(dataArray_train{col},'closed','-1');
            temp = strrep(temp,'opened','1');       
        end
        temp = strrep(temp,'None','0');
        temp = cellfun(@str2num,temp);
        temp = temp.*cellfun(@str2num,strrep(dataArray_train{col+1},'None','0'));
        meta_train = [meta_train temp];

        % Test data
        if col == 79
            temp = strrep(dataArray_test{col},'female','-1');
            temp = strrep(temp,'male','1');
        else
            temp = strrep(dataArray_test{col},'closed','-1');
            temp = strrep(temp,'opened','1');       
        end
        temp = strrep(temp,'None','0');
        temp = cellfun(@str2num,temp);
        temp = temp.*cellfun(@str2num,strrep(dataArray_test{col+1},'None','0'));
        meta_test = [meta_test temp];
    end

    % Special case:
    %   - 95, list_others: create a column by attribute and add the
    %   corresponding weight
    % Go through train data
    temp_data = dataArray_train{95};
    temp_feat = [];
    unique_attributes = {};
    for i = 1:10000
        temp = temp_data{i};

        % Check if the attribute is empty
        if ~strcmp(temp,'{}')
            attribute = temp(4:strfind(temp,':')-2);
            value     = str2double(temp(strfind(temp,':')+2:end-1));

            % Store the attribute if it's unique
            if ~ismember(attribute,unique_attributes)
                unique_attributes = [unique_attributes; attribute];
                temp_feat = [temp_feat zeros(10000,1)];
            end

            % Record the value
            k = find(strcmp(unique_attributes,attribute));
            temp_feat(i,k) = value;
        end
    end
    meta_train = [meta_train temp_feat];

    % Go through test data
    temp_data = dataArray_test{95};
    temp_feat = zeros(3000, numel(unique_attributes));
    for i = 1:3000
        temp = temp_data{i};

        % Check if the attribute is empty
        if ~strcmp(temp,'{}')
            attribute = temp(4:strfind(temp,':')-2);
            value = str2double(temp(strfind(temp,':')+2:end-1));        

            % Record the value
            k = find(strcmp(unique_attributes,attribute));
            temp_feat(i,k) = value;
        end
    end
    meta_test = [meta_test temp_feat];

    % Clear variables
    clear ans attribute col dataArray_test dataArray_train formatSpec;
    clear fileID_test fileID_train i k numCol temp;
    clear temp_data temp_feat unique_attributes value;

    % Save data
    save('meta_features.mat','meta_train','meta_test')
    disp('Meta features done.')
end
 
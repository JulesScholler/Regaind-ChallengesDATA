% Analyze all pictures and generate the yahoo features then save
% the data in the file yahoo_features.mat
%
% Arguments:
%   - bla: bla
%
% Return values:
%   - bla: bla
%
% Corresponding value indices:
%   - 01: ID
%   - 02: detection score
%   - 03: x0
%   - 04: y0
%   - 05: width
%   - 06: height
%   - 07: left_eye_x
%   - 08: left_eye_y
%   - 09: right_eye_x
%   - 10: right_eye_y
%   - 11: left_of_left_eyebrow_x
%   - 12: left_of_left_eyebrow_y
%   - 13: right_of_left_eyebrow_x
%   - 14: right_of_left_eyebrow_y
%   - 15: left_of_right_eyebrow_x
%   - 16: left_of_right_eyebrow_y
%   - 17: right_of_right_eyebrow_x
%   - 18: right_of_right_eyebrow_y
%   - 19: midpoint_between_eyes_x
%   - 20: midpoint_between_eyes_y
%   - 21: nose_tip_x
%   - 22: nose_tip_y
%   - 23: upper_lip_x
%   - 24: upper_lip_y
%   - 25: lower_lip_x
%   - 26: lower_lip_y
%   - 27: mouth_left_x
%   - 28: mouth_left_y
%   - 29: mouth_right_x
%   - 30: mouth_right_y
%   - 31: mouth_center_x
%   - 32: mouth_center_y
%   - 33: nose_bottom_right_x
%   - 34: nose_bottom_right_y
%   - 35: nose_bottom_left_x
%   - 36: nose_bottom_left_y
%   - 37: nose_bottom_center_x
%   - 38: nose_bottom_center_y
%   - 39: left_eye_top_boundary_x
%   - 40: left_eye_top_boundary_y
%   - 41: left_eye_right_corner_x
%   - 42: left_eye_right_corner_y
%   - 43: left_eye_bottom_boundary_x
%   - 44: left_eye_bottom_boundary_y
%   - 45: left_eye_left_corner_x
%   - 46: left_eye_left_corner_y
%   - 47: left_eye_pupil_x
%   - 48: left_eye_pupil_y
%   - 49: right_eye_top_boundary_x
%   - 50: right_eye_top_boundary_y
%   - 51: right_eye_right_corner_x
%   - 52: right_eye_right_corner_y
%   - 53: right_eye_bottom_boundary_x
%   - 54: right_eye_bottom_boundary_y
%   - 55: right_eye_left_corner_x
%   - 56: right_eye_left_corner_y
%   - 57: right_eye_pupil_x
%   - 58: right_eye_pupil_y
%   - 59: left_eyebrow_upper_midpoint_x
%   - 60: left_eyebrow_upper_midpoint_y
%   - 61: right_eyebrow_upper_midpoint_x
%   - 62: right_eyebrow_upper_midpoint_y
%   - 63: left_ear_tragion_x
%   - 64: left_ear_tragion_y
%   - 65: right_ear_tragion_x
%   - 66: right_ear_tragion_y
%   - 67: forehead_glabella_x
%   - 68: forehead_glabella_y
%   - 69: chin_gnathion_x
%   - 70: chin_gnathion_y
%   - 71: chin_left_gonion_x
%   - 72: chin_left_gonion_y
%   - 73: chin_right_gonion_x
%   - 74: chin_right_gonion_y
%   - 75: landmarks confidence
%   - 76: pan angle
%   - 77: roll angle
%   - 78: age
%   - 79: gender
%   - 80: confidence_gender
%   - 81: left_eye
%   - 82: confidence_left_eye
%   - 83: right_eye
%   - 84: confidence_right_eye
%   - 85: anger
%   - 86: sadness
%   - 87: fear
%   - 88: neutral
%   - 89: grimace
%   - 90: surprise
%   - 91: hard_to_tell
%   - 92: smile
%   - 93: laugh
%   - 94: other
%   - 95: list_others

% Load the config parameters
SCRIPT_config;

if 0
    return
else    
    % Retrieve facial features
    format = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
    fileID = fopen(cfg.facial_features_train,'r');
    dataArray = textscan(fileID, format, 'Delimiter', ',', 'HeaderLines', 1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    faceData = zeros(10000,74);
    for i = 1:74
        faceData(:,i) = cellfun(@str2num,dataArray{i});
    end

    % Loop through all training images
    disp('Train yahoo starting...')
    % Initialize variables
    yahoo_train = zeros(10000,9);                   % yahoo features
    for i=1:10000
        % Open image
        im_fn    = [num2str(i) '.jpg'];             % image filename
        im       = imread([cfg.dir_train im_fn]);   % open image        
        
        % Face
        [row, col, ~] = size(im);
        x0 = 1 + faceData(i,3)*col;
        x1 = min(col, x0 + faceData(i,5)*col);
        y0 = 1 + faceData(i,4)*row;
        y1 = min(row, y0 + faceData(i,6)*row);
        im_face = im(uint16(y0):uint16(y1),uint16(x0):uint16(x1),:);
        
        % Background
        im_back = double(im);
        im_back(uint16(y0):uint16(y1),uint16(x0):uint16(x1),:) = nan;
        
        % Left eye
        pt = [7 39 41 43 45 47];
        x0 = uint16(1+min(faceData(i,pt))*col);
        x1 = uint16(1+max(faceData(i,pt))*col);
        y0 = uint16(1+min(faceData(i,pt+1))*row);
        y1 = uint16(1+max(faceData(i,pt+1))*row);
        im_left_eye = im(max(1,y0):min(y1,row),max(1,x0):min(x1,col),:);
        
        % Right eye
        pt = [9 49 51 53 55 57];
        x0 = uint16(1+min(faceData(i,pt))*col);
        x1 = uint16(1+max(faceData(i,pt))*col);
        y0 = uint16(1+min(faceData(i,pt+1))*row);
        y1 = uint16(1+max(faceData(i,pt+1))*row);
        im_right_eye = im(max(1,y0):min(y1,row),max(1,x0):min(x1,col),:);
        
        % Left eyebrow
        pt = [11 13 59];
        x0 = uint16(1+min(faceData(i,pt))*col);
        x1 = uint16(1+max(faceData(i,pt))*col);
        y0 = uint16(1+min(faceData(i,pt+1))*row);
        y1 = uint16(1+max(faceData(i,pt+1))*row);
        im_left_eyebrow = im(max(1,y0):min(y1,row),max(1,x0):min(x1,col),:);

        % Right eyebrow
        pt = [15 17 61];
        x0 = uint16(1+min(faceData(i,pt))*col);
        x1 = uint16(1+max(faceData(i,pt))*col);
        y0 = uint16(1+min(faceData(i,pt+1))*row);
        y1 = uint16(1+max(faceData(i,pt+1))*row);
        im_right_eyebrow = im(max(1,y0):min(y1,row),max(1,x0):min(x1,col),:);

        % Mouth
        pt = [23 25 27 29 31];
        x0 = uint16(1+min(faceData(i,pt))*col);
        x1 = uint16(1+max(faceData(i,pt))*col);
        y0 = uint16(1+min(faceData(i,pt+1))*row);
        y1 = uint16(1+max(faceData(i,pt+1))*row);
        im_mouth = im(max(1,y0):min(y1,row),max(1,x0):min(x1,col),:);

        % Nose
        pt = [19 21 33 35 37];
        x0 = uint16(1+min(faceData(i,pt))*col);
        x1 = uint16(1+max(faceData(i,pt))*col);
        y0 = uint16(1+min(faceData(i,pt+1))*row);
        y1 = uint16(1+max(faceData(i,pt+1))*row);
        im_nose = im(max(1,y0):min(y1,row),max(1,x0):min(x1,col),:);
        
        % Compute features        
        yahoo_train(i,1) = eval_sharpness(im);
        yahoo_train(i,2) = eval_sharpness(im_face);
        yahoo_train(i,3) = eval_sharpness(im_back);
        yahoo_train(i,4) = eval_sharpness(im_left_eye);
        yahoo_train(i,5) = eval_sharpness(im_right_eye);
        yahoo_train(i,6) = eval_sharpness(im_left_eyebrow);
        yahoo_train(i,7) = eval_sharpness(im_right_eyebrow);
        yahoo_train(i,8) = eval_sharpness(im_mouth);
        yahoo_train(i,9) = eval_sharpness(im_nose);
        yahoo_train(i,isnan(yahoo_train(i,:))) = 0;

        % Display progress
        if mod(100*i/10000,5)==0
            fprintf('Train exposure progress: %i%%\n',uint8(100*i/10000));
        end
    end

end
disp('Train yahoo done.')

%% Test the model
% Load features
SCRIPT_load_score;
SCRIPT_load_meta;
load([cfg.dir_data 'train/hist_features.mat'])
load([cfg.dir_data 'train/blur_features_train.mat'])

% Assemble the data
data_train = [meta_train yahoo_train hist_features blur_features];

% Set parameters
n_fold = 5;                     % cross-validation parameters

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
%     SVM_model = fitrsvm(data_CV_train,score_CV_train,'KernelFunction','Linear','Standardize',true);
    SVM_model = fitrlinear(data_CV_train,score_CV_train);
    
    % Predict scores
    predict_CV_test = predict(SVM_model,data_CV_test);
    
    % Evaluate method
    [rank_eval(i),~] = corr(score_CV_test,predict_CV_test,'type','Spearman');
end

% Display results
fprintf('SVM cross validation done, average: %f\n',mean(rank_eval))



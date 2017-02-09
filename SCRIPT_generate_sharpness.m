% Analyze all pictures and generate the sharpness features then save
% the data in the file sharpness_features.mat
%

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('sharpness_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from sharpness_features.mat')
    load('sharpness_features.mat');
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
    disp('Train sharpness starting...')
    sharpness_train = zeros(10000,9);               % train features
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
        sharpness_train(i,1) = eval_sharpness(im);
        sharpness_train(i,2) = eval_sharpness(im_face);
        sharpness_train(i,3) = eval_sharpness(im_back);
        sharpness_train(i,4) = eval_sharpness(im_left_eye);
        sharpness_train(i,5) = eval_sharpness(im_right_eye);
        sharpness_train(i,6) = eval_sharpness(im_left_eyebrow);
        sharpness_train(i,7) = eval_sharpness(im_right_eyebrow);
        sharpness_train(i,8) = eval_sharpness(im_mouth);
        sharpness_train(i,9) = eval_sharpness(im_nose);
        sharpness_train(i,isnan(sharpness_train(i,:))) = 0;

        % Display progress
        if mod(100*i/10000,5)==0
            fprintf('Train sharpness progress: %i%%\n',uint8(100*i/10000));
        end
    end
    disp('Train sharpness done.')
    
    % Retrieve facial features
    format = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
    fileID = fopen(cfg.facial_features_test,'r');
    dataArray = textscan(fileID, format, 'Delimiter', ',', 'HeaderLines', 1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    faceData = zeros(3000,74);
    for i = 1:74
        faceData(:,i) = cellfun(@str2num,dataArray{i});
    end
    % Loop through all training images
    disp('Test sharpness starting...')
    sharpness_test = zeros(3000,9);         % test features
    for i=1:3000
        % Open image
        im_fn    = [num2str(10000+i) '.jpg'];       % image filename
        im       = imread([cfg.dir_test im_fn]);    % open image        
        
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
        sharpness_test(i,1) = eval_sharpness(im);
        sharpness_test(i,2) = eval_sharpness(im_face);
        sharpness_test(i,3) = eval_sharpness(im_back);
        sharpness_test(i,4) = eval_sharpness(im_left_eye);
        sharpness_test(i,5) = eval_sharpness(im_right_eye);
        sharpness_test(i,6) = eval_sharpness(im_left_eyebrow);
        sharpness_test(i,7) = eval_sharpness(im_right_eyebrow);
        sharpness_test(i,8) = eval_sharpness(im_mouth);
        sharpness_test(i,9) = eval_sharpness(im_nose);
        sharpness_test(i,isnan(sharpness_test(i,:))) = 0;

        % Display progress
        if mod(100*i/3000,5)==0
            fprintf('Test sharpness progress: %i%%\n',uint8(100*i/3000));
        end
    end
    disp('Test sharpness done.')
        
    % Clear variables
    clear ans col dataArray faceData fileID format i im im_back im_face;
    clear im_face im_fn in_left_eye im_left_eyebrow im_mouth im_nose;
    clear im_right_eye im_right_eyebrow pt row x0 x1 y0 y1;
    
    % Save data
    save('sharpness_features.mat','sharpness_train','sharpness_test')
end

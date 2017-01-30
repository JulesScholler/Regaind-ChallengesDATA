% Extract face subimage from all pictures and retrieve a layer after
% performing a forward-pass with the VGG-face network. Then save the data
% in the file face_features.mat
% 
% Arguments:
%   - n_layer: number of the layer to retrieve in the forward pass
%                   * fc8: 38
%                   * fc7: 35
%                   * fc6: 32
%
% Return values:
%   - face_test: histogram features for the test dataset
%   - face_train: histogram features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('face_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from face_features.mat')
    load('face_features.mat');
else
    % Define the parameters
    n_layer = 36;
    
    % Load the network and upgrade it to MatConvNet current version
    load(cfg.vgg_path);
    net = vl_simplenn_tidy(net);
    
    % Retrieve face size and position raw data
    formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
    fileID_train = fopen(cfg.facial_features_train,'r');
    fileID_test = fopen(cfg.facial_features_test,'r');
    dataArray_train  = textscan(fileID_train, formatSpec, 'Delimiter', ',', ...
        'HeaderLines', 1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    dataArray_test  = textscan(fileID_test, formatSpec, 'Delimiter', ',', ...
        'HeaderLines', 1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID_train);
    fclose(fileID_test);
    
    % Convert to number
    face_x0_train     = cellfun(@str2num,dataArray_train{3});
    face_y0_train     = cellfun(@str2num,dataArray_train{4});
    face_width_train  = cellfun(@str2num,dataArray_train{5});
    face_height_train = cellfun(@str2num,dataArray_train{6});
    face_x0_test      = cellfun(@str2num,dataArray_test{3});
    face_y0_test      = cellfun(@str2num,dataArray_test{4});
    face_width_test   = cellfun(@str2num,dataArray_test{5});
    face_height_test  = cellfun(@str2num,dataArray_test{6});
    
    % Train dataset
    disp('Train VGG starting...')
    for i = 1:10000
        % Open image and crop on face
        im_fn = [num2str(i) '.jpg'];                    % image filename
        im    = imread([cfg.dir_train im_fn]);          % open image
        if ndims(im) == 2                               % convert to rgb
            im = cat(3, im, im, im);
        end
        [row, col, ~] = size(im);                       % image dimension
        x0 = 1 + face_x0_train(i)*col;                  % left corner
        x1 = min(col, x0 + face_width_train(i)*col);    % right corner
        y0 = 1 + face_y0_train(i)*row;                  % top corner
        y1 = min(row, y0 + face_height_train(i)*row);   % bottom corner
        im = im(uint16(y0):uint16(y1),uint16(x0):uint16(x1),:); % face crop

        % Preprocess image before network forward pass   
        im    = double(imresize(im, net.meta.normalization.imageSize(1:2), ...
            'method',net.meta.normalization.interpolation));    % resize
        avg   = net.meta.normalization.averageImage;        % network average
        im(:,:,1) = im(:,:,1) - avg(1);                     % normalize R
        im(:,:,2) = im(:,:,2) - avg(2);                     % normalize G
        im(:,:,3) = im(:,:,3) - avg(3);                     % normalize B
        res = vl_simplenn(net, single(im));                 % foward pass
        
        % Store the value
        if ~exist('face_train', 'var')
            face_train = zeros(10000, numel(res(n_layer+1).x(:)));
        end
        face_train(i,:) =  res(n_layer+1).x(:);
                
        % Display progress
        if mod(100*i/10000,5)==0
            fprintf('Train VGG progress: %i%%\n',uint8(100*i/10000));
        end
    end
    disp('Train VGG done.')
    
    % Test dataset
    disp('Test VGG starting...')
    for i = 1:3000
        % Open image and crop on face
        im_fn = [num2str(10000+i) '.jpg'];              % image filename
        im    = imread([cfg.dir_test im_fn]);           % open image
        if ndims(im) == 2                               % convert to rgb
            im = cat(3, im, im, im);
        end
        [row, col, ~] = size(im);                       % image dimension
        x0 = 1 + face_x0_test(i)*col;                   % left corner
        x1 = min(col, x0 + face_width_test(i)*col);     % right corner
        y0 = 1 + face_y0_test(i)*row;                   % top corner
        y1 = min(row, y0 + face_height_test(i)*row);    % bottom corner
        im = im(uint16(y0):uint16(y1),uint16(x0):uint16(x1),:);     % face crop

        % Preprocess image before network forward pass   
        im    = double(imresize(im, net.meta.normalization.imageSize(1:2), ...
            'method',net.meta.normalization.interpolation));    % resize
        avg   = net.meta.normalization.averageImage;        % network average
        im(:,:,1) = im(:,:,1) - avg(1);                     % normalize R
        im(:,:,2) = im(:,:,2) - avg(2);                     % normalize G
        im(:,:,3) = im(:,:,3) - avg(3);                     % normalize B
        res = vl_simplenn(net, single(im));                 % foward pass
        
        % Store the value
        if ~exist('face_test', 'var')
            face_test = zeros(3000, numel(res(n_layer+1).x(:)));
        end
        face_test(i,:) =  res(n_layer+1).x(:);
                
        % Display progress
        if mod(100*i/3000,5)==0
            fprintf('Test VGG progress: %i%%\n',uint8(100*i/3000));
        end
    end
    disp('Test VGG done.')

    % Clear variables
    clear ans avg col row;
    clear dataArray_test dataArray_train ;
    clear face_height_test face_height_train ;
    clear face_width_test face_width_train;
    clear face_x0_test face_x0_train face_y0_test face_y0_train;
    clear fileID_test fileID_train formatSpec i im im_fn n_layer net;
    clear res x0 x1 y0 y1;

    % Save data
    save('face_features.mat','face_train','face_test')
end


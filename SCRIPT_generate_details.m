% Analyze all pictures and compute the level of details features
%
% Return values:
%   - glcm_test: level of details features for the test dataset
%   - glcm_train: level of details features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('details_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from details_features.mat')
    load('details_features.mat');
else
    % Initialize variables   
    lvldet_test  = zeros(3000,1);      % test features
    lvldet_train = zeros(10000,1);     % train features
    thresh = 0.4;

    % Loop through all training images
    disp('Train level of details starting...')
    for i=1:10000
        % Open image
        im_fn   = [num2str(i) '.jpg'];              % image filename
        im      = imread([cfg.dir_train im_fn]);    % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Compute the number of regions
        shape = ones(3,3);                              % open shape
        im_bw = rgb2gray(im);                           % gray image
        im_bn = im_bw > thresh*max(max(im_bw));         % binary image
        im_bn = imclose(imopen(im_bn,shape),shape);     % segmentation 1
        im_bn = imclose(imopen(im_bn,shape),shape);     % segmentation 2        
        im_lb = bwlabel(im_bn);                         % image labeling        
        n_reg = max(im_lb(:));                          % number of regions
        %%
        
        % Store the value
        lvldet_train(i) = n_reg;

        % Display progress
        if mod(100*i/10000,5)==0            
            fprintf('Train level of details: %i%%\n',uint8(100*i/10000));
        end
    end
    disp('Train level of details done.')

    % Loop through all test images
    disp('Test level of details starting...')
    for i=1:3000
        % Open image
        im_fn = [num2str(i+10000) '.jpg'];          % image filename        
        im    = imread([cfg.dir_test im_fn]);       % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Compute the number of regions
        shape = ones(3,3);                              % open shape
        im_bw = rgb2gray(im);                           % gray image
        im_bn = im_bw > thresh*max(max(im_bw));         % binary image
        im_bn = imclose(imopen(im_bn,shape),shape);     % segmentation 1
        im_bn = imclose(imopen(im_bn,shape),shape);     % segmentation 2        
        im_lb = bwlabel(im_bn);                         % image labeling        
        n_reg = max(im_lb(:));                          % number of regions
        
        % Store the value
        lvldet_test(i) = n_reg;
        
        % Display progress
        if mod(100*i/3000,5)==0
            fprintf('Test level of details: %i%%\n',uint8(100*i/3000));
        end
    end
    disp('Test level of details done.')

    % Save data
    save('details_features.mat','lvldet_train','lvldet_test')
    
    % Clear variables
	clear i im im_bn im_bw im_fn im_lb n_ref shape thresh;
end
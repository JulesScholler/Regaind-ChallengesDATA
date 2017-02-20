% Analyze all pictures and compute the basic quality features
%
% Return values:
%   - basic_qual_test: basic quality features for the test dataset
%   - basic_qual_train: basic quality features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('basic_qual_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from basic_qual_features.mat')
    load('basic_qual_features.mat');
else
    % Initialize variables   
    basic_qual_test  = zeros(3000,2);   % test features
    basic_qual_train = zeros(10000,2);  % train features

    % Loop through all training images
    disp('Train basic quality starting...')
    for i=1:10000
        % Open image
        im_fn   = [num2str(i) '.jpg'];              % image filename
        im      = imread([cfg.dir_train im_fn]);    % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Compute the contrast quality
        im_gray = rgb2gray(im);                         % grayscale
        im_eq   = double(histeq(im_gray));              % hist equalization
        im_diff = (double(im_gray) - im_eq).^2;         % diff square
        basic_qual_train(i,1) = sqrt(mean(im_diff(:))); % mean      
        
        % Compute the exposure quality
        im_y    = rgb2ycbcr(im);                        % change space
        im_y    = im_y(:,:,1);                          % luminance
        skew_y  = skewness(histcounts(im_y,linspace(0,255,256)));
        basic_qual_train(i,2) = -abs(skew_y);           % exposure
        
        
        % Display progress
        if mod(100*i/10000,5)==0
            fprintf('Train basic quality: %i%%\n',uint8(100*i/10000));
        end
    end
    disp('Train basic quality done.')

    % Loop through all test images
    disp('Test basic quality starting...')
    for i=1:3000
        % Open image
        im_fn    = [num2str(i+10000) '.jpg'];       % image filename        
        im      = imread([cfg.dir_test im_fn]);     % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Compute the contrast quality
        im_gray = rgb2gray(im);                         % grayscale
        im_eq   = double(histeq(im_gray));              % hist equalization
        im_diff = (double(im_gray) - im_eq).^2;         % diff square
        basic_qual_test(i,1) = sqrt(mean(im_diff(:)));  % mean
        
        % Compute the exposure quality
        im_y    = rgb2ycbcr(im);                        % change space
        im_y    = im_y(:,:,1);                          % luminance
        skew_y  = skewness(histcounts(im_y,linspace(0,255,256)));
        basic_qual_test(i,2) = -abs(skew_y);            % exposure

        % Display progress
        if mod(100*i/3000,5)==0
            fprintf('Test basic quality: %i%%\n',uint8(100*i/3000));
        end
    end
    disp('Test basic quality done.')

    % Save data
    save('basic_qual_features.mat','basic_qual_train','basic_qual_test')
    
    % Clear variables
    clear ans hist i im im_diff im_eq im_fn im_gray im_y skew_y;
end
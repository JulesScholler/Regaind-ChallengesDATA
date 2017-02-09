% Analyze all pictures and compute the number of each discriminative colors
%
% Return values:
%   - discol_test: discriminative color features for the test dataset
%   - discol_train: discriminative color features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('discol_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from discol_features.mat')
    load('discol_features.mat');
else
    % Initialize variables   
    discol_test  = zeros(3000,11);      % test features
    discol_train = zeros(10000,11);     % train features
    
    % Load the dictionnary
    load('DD11_w2c_fast.mat')

    % Loop through all training images
    disp('Train discol starting...')
    for i=1:10000
        % Open image
        im_fn   = [num2str(i) '.jpg'];              % image filename
        im      = imread([cfg.dir_train im_fn]);    % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Separate channels and retrieve color ID
        r = double(im(:,:,1));
        g = double(im(:,:,2));
        b = double(im(:,:,3));
        idx_col = 1 + floor(r(:)/8)+32*floor(g(:)/8)+32*32*floor(b(:)/8);
        disccol = w2c(uint16(idx_col));
        
        % Retrieve the disccol numbers
        for j = 1:11
            discol_train(i,j) = numel(find(disccol==j));
        end
        discol_train(i,:) = discol_train(i,:)/numel(r);
        
        % Display progress
        if mod(100*i/10000,5)==0            
            fprintf('Train discol: %i%%\n',uint8(100*i/10000));
        end
    end
    disp('Train discol done.')

    % Loop through all test images
    disp('Test discol starting...')
    for i=1:3000
        % Open image
        im_fn = [num2str(i+10000) '.jpg'];          % image filename        
        im    = imread([cfg.dir_test im_fn]);       % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Separate channels and retrieve color ID
        r = double(im(:,:,1));
        g = double(im(:,:,2));
        b = double(im(:,:,3));
        idx_col = 1 + floor(r(:)/8)+32*floor(g(:)/8)+32*32*floor(b(:)/8);
        disccol = w2c(round(idx_col));
        
        % Retrieve the disccol numbers
        for j = 1:11
            discol_test(i,j) = numel(find(disccol==j));
        end
        discol_test(i,:) = discol_test(i,:)/numel(r);

        % Display progress
        if mod(100*i/3000,5)==0
            fprintf('Test discol: %i%%\n',uint8(100*i/3000));
        end
    end
    disp('Test discol done.')

    % Save data
    save('discol_features.mat','discol_train','discol_test')
    
    % Clear variables
	clear ans i j disccol idx_col r g b im im_fn w2c;
end
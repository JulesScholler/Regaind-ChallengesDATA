% Analyze all pictures and compute the image order features
%
% Return values:
%   - order_test: image order features for the test dataset
%   - order_train: image order features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('order_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from order_features.mat')
    load('order_features.mat');
else
    % Initialize variables   
    order_test  = zeros(3000,1);      % test features
    order_train = zeros(10000,1);     % train features

    % Loop through all training images
    disp('Train image order starting...')
    for i=1:10000
        % Open image
        im_fn   = [num2str(i) '.jpg'];              % image filename
        im      = imread([cfg.dir_train im_fn]);    % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Compute and store the entropy
        order_train(i) = entropy(rgb2gray(im));

        % Display progress
        if mod(100*i/10000,5)==0            
            fprintf('Train image order: %i%%\n',uint8(100*i/10000));
        end
    end
    disp('Train image order done.')

    % Loop through all test images
    disp('Test image order starting...')
    for i=1:3000
        % Open image
        im_fn = [num2str(i+10000) '.jpg'];          % image filename        
        im    = imread([cfg.dir_test im_fn]);       % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Compute and store the entropy
        order_test(i) = entropy(rgb2gray(im));
        
        % Display progress
        if mod(100*i/3000,5)==0
            fprintf('Test image order: %i%%\n',uint8(100*i/3000));
        end
    end
    disp('Test image order done.')

    % Save data
    save('order_features.mat','order_train','order_test')
    
    % Clear variables
% 	clear i im im_bn im_bw im_fn im_lb n_ref shape thresh;
end
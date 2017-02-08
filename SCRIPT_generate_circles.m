% Analyze all pictures and compute the circles features
%
% Return values:
%   - circ_test: circles features for the test dataset
%   - circ_train: circles features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('circles_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from circles_features.mat')
    load('circles_features.mat');
else
    % Initialize variables   
    circ_test  = zeros(3000,1);      % test features
    circ_train = zeros(10000,1);     % train features

    % Loop through all training images
    disp('Train circ starting...')
    for i=1:10000
        % Open image
        im_fn   = [num2str(i) '.jpg'];              % image filename
        im      = imread([cfg.dir_train im_fn]);    % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Resize image
        im = imresize(rgb2gray(im), 0.25);
        
        % Find the number of circles
        n_circ = numel(imfindcircles(im,[10 30])) + ...
            numel(imfindcircles(im,[30 90]));
        circ_train(i) = n_circ;

        % Display progress
        if mod(100*i/10000,5)==0            
            fprintf('Train circ: %i%%\n',uint8(100*i/10000));
        end
        
    end
    disp('Train circ done.')

    % Loop through all test images
    disp('Test circ starting...')
    for i=1:3000
        % Open image
        im_fn = [num2str(i+10000) '.jpg'];          % image filename        
        im    = imread([cfg.dir_test im_fn]);       % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Resize image
        im = imresize(rgb2gray(im), 0.25);
        
        % Find the number of circles
        n_circ = numel(imfindcircles(im,[10 30])) + ...
            numel(imfindcircles(im,[30 90]));
        circ_test(i) = n_circ;

        % Display progress
        if mod(100*i/3000,5)==0
            fprintf('Test circ: %i%%\n',uint8(100*i/3000));
        end
    end
    disp('Test circ done.')

    % Save data
    save('circles_features.mat','circ_train','circ_test')
    
    % Clear variables
	clear ans col i im_fn im n_circ;
end
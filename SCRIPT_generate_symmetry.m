% Analyze all pictures and compute the symmetry features
%
% Return values:
%   - sym_test: symmetry features for the test dataset
%   - sym_train: symmetry features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('symmetry_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from symmetry_features.mat')
    load('symmetry_features.mat');
else
    % Initialize variables   
    sym_test  = zeros(3000,1);      % test features
    sym_train = zeros(10000,1);     % train features

    % Loop through all training images
    disp('Train symmetry starting...')
    for i=1:10000
        % Open image
        im_fn   = [num2str(i) '.jpg'];              % image filename
        im      = imread([cfg.dir_train im_fn]);    % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Compute the left and right images
        [row, col, ~] = size(im);
        im_left  = im(:,1:round(col/2),:);
        im_right = im(:,end:-1:end-round(col/2)+1,:);
        
        % Compute hog descriptors
        hog_left  = extractHOGFeatures(im_left,'CellSize',[32 32]);
        hog_right = extractHOGFeatures(im_right,'CellSize',[32 32]);
        hog_diff  = mean(-abs((hog_left - hog_right)));
        sym_train(i) = hog_diff;
        
        % Display progress
        if mod(100*i/10000,5)==0
            fprintf('Train symmetry: %i%%\n',uint8(100*i/10000));
        end
        
    end
    disp('Train symmetry done.')

    % Loop through all test images
    disp('Test symmetry starting...')
    for i=1:3000
        % Open image
        im_fn = [num2str(i+10000) '.jpg'];          % image filename        
        im    = imread([cfg.dir_test im_fn]);       % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Compute the left and right images
        [row, col, ~] = size(im);
        im_left  = im(:,1:round(col/2),:);
        im_right = im(:,end:-1:end-round(col/2)+1,:);
        
        % Compute hog descriptors
        hog_left  = extractHOGFeatures(im_left,'CellSize',[32 32]);
        hog_right = extractHOGFeatures(im_right,'CellSize',[32 32]);
        hog_diff  = mean(-abs((hog_left - hog_right)));
        sym_test(i) = hog_diff;

        % Display progress
        if mod(100*i/3000,5)==0
            fprintf('Test symmetry: %i%%\n',uint8(100*i/3000));
        end
    end
    disp('Test symmetry done.')

    % Save data
    save('symmetry_features.mat','sym_train','sym_test')
    
    % Clear variables
	clear col hog_diff hog_left hog_right i im im_fn im_left im_right row;
end
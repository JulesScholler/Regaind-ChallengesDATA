% Analyze all pictures and compute the basic quality features
%
% Return values:
%   - basic_qual_test: basic quality features for the test dataset
%   - basic_qual_train: basic quality features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('compositional_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from compositional_features.mat')
    load('compositional_features.mat');
else
    
    % Loop through all training images
    disp('Train composition starting...')
    hist_train=zeros(10000,32);
    contrast_train=zeros(10000,2);
    for i=1:10000
        % Open image
        im_fn   = [num2str(i) '.jpg'];              % image filename
        im      = imread([cfg.dir_train im_fn]);    % open image
        if ismatrix(im)                             % convert to rgb
            im = cat(3, im, im, im);
        end
        
        hist_train(i,:)=eval_color(im);
        contrast_train(i,:)=eval_contrast(im);
        
        % Display progress
        if mod(100*i/10000,5)==0
            fprintf('Train composition: %i%%\n',uint8(100*i/10000));
        end
    end
    compositional_train=[hist_train contrast_train];
    disp('Train composition done.')

    % Loop through all test images
    disp('Test composition starting...')
    hist_test=zeros(3000,32);
    contrast_test=zeros(3000,2);
    for i=1:3000
        % Open image
        im_fn    = [num2str(i+10000) '.jpg'];       % image filename        
        im      = imread([cfg.dir_test im_fn]);     % open image
        if ismatrix(im)                             % convert to rgb
            im = cat(3, im, im, im);
        end
        
        hist_test(i,:)=eval_color(im);
        contrast_test(i,:)=eval_contrast(im);

        % Display progress
        if mod(100*i/3000,5)==0
            fprintf('Test composition: %i%%\n',uint8(100*i/3000));
        end
    end
    
    compositional_test=[hist_test contrast_test];
    disp('Test composition done.')

    % Save data
    save('compositional_features.mat','compositional_train','compositional_test')
end
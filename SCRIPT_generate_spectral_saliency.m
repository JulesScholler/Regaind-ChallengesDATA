% Analyze all pictures and compute the spectral_saliency
%
% Return values:
%   - spectral_saliency_test: spectral_saliency features for the test dataset
%   - spectral_saliency_train: spectral_saliency features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('spectral_saliency_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from spectral_saliency_features.mat')
    load('spectral_saliency_features.mat');
else
    
    % Loop through all training images
    disp('Train composition starting...')
    spectral_saliency_train=zeros(10000,9);
    for i=1:10000
        % Open image
        im_fn   = [num2str(i) '.jpg'];              % image filename
        im      = imread([cfg.dir_train im_fn]);    % open image
        if ismatrix(im)                             % convert to rgb
            im = cat(3, im, im, im);
        end
        
        spectral_saliency_train(i,:)=eval_spectral_saliency(im);
        
        % Display progress
        if mod(100*i/10000,5)==0
            fprintf('Train composition: %i%%\n',uint8(100*i/10000));
        end
    end
    disp('Train composition done.')

    % Loop through all test images
    disp('Test composition starting...')
    spectral_saliency_test=zeros(3000,9);
    for i=1:3000
        % Open image
        im_fn    = [num2str(i+10000) '.jpg'];       % image filename        
        im      = imread([cfg.dir_test im_fn]);     % open image
        if ismatrix(im)                             % convert to rgb
            im = cat(3, im, im, im);
        end
        
        spectral_saliency_test(i,:)=eval_spectral_saliency(im);

        % Display progress
        if mod(100*i/3000,5)==0
            fprintf('Test composition: %i%%\n',uint8(100*i/3000));
        end
    end
    disp('Test composition done.')

    % Save data
    save('spectral_saliency_features.mat','spectral_saliency_train','spectral_saliency_test')
end
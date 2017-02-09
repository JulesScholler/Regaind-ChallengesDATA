% Analyze all pictures and compute the GLCM features
%
% Return values:
%   - glcm_test: GLCM features for the test dataset
%   - glcm_train: GLCM features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('GLCM_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from GLCM_features.mat')
    load('GLCM_features.mat');
else
    % Initialize variables   
    glcm_test  = zeros(3000,5);      % test features
    glcm_train = zeros(10000,5);     % train features   

    % Loop through all training images
    disp('Train GLCM starting...')
    for i=1:10000
        % Open image
        im_fn   = [num2str(i) '.jpg'];              % image filename
        im      = imread([cfg.dir_train im_fn]);    % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Compute the GLCM
        glcm = graycomatrix(rgb2gray(im));
        
        % Compute relevant statistics
        stats = graycoprops(glcm);        
        
        % Store variables
        glcm_train(i,1) = entropy(glcm);
        glcm_train(i,2) = stats.Contrast;
        glcm_train(i,3) = stats.Correlation;
        glcm_train(i,4) = stats.Energy;
        glcm_train(i,5) = stats.Homogeneity;

        % Display progress
        if mod(100*i/10000,5)==0            
            fprintf('Train GLCM: %i%%\n',uint8(100*i/10000));
        end
    end
    disp('Train GLCM done.')

    % Loop through all test images
    disp('Test GLCM starting...')
    for i=1:3000
        % Open image
        im_fn = [num2str(i+10000) '.jpg'];          % image filename        
        im    = imread([cfg.dir_test im_fn]);       % open image
        if ndims(im) == 2                           % convert to rgb
            im = cat(3, im, im, im);
        end
        
        % Compute the GLCM
        glcm = graycomatrix(rgb2gray(im));
        
        % Compute relevant statistics
        stats = graycoprops(glcm);        
        
        % Store variables
        glcm_test(i,1) = entropy(glcm);
        glcm_test(i,2) = stats.Contrast;
        glcm_test(i,3) = stats.Correlation;
        glcm_test(i,4) = stats.Energy;
        glcm_test(i,5) = stats.Homogeneity;

        % Display progress
        if mod(100*i/3000,5)==0
            fprintf('Test GLCM: %i%%\n',uint8(100*i/3000));
        end
    end
    disp('Test GLCM done.')

    % Save data
    save('GLCM_features.mat','glcm_train','glcm_test')
    
    % Clear variables
	clear i im im_fn stats glcm;
end
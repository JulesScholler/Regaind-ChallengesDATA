% Analyze all pictures and generate histograms grouped in bins then save 
% the data in the file hist_features.mat
%
% Arguments:
%   - n_bins: number of bins to use for the histogram
%
% Return values:
%   - hist_test: histogram features for the test dataset
%   - hist_train: histogram features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('hist_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from hist_features.mat')
    load('hist_features.mat');
else
    % Define parameters
    n_bins    = 10;     % number of bins
    
    % Initialize variables
    separator  = linspace(0,255,n_bins+1);  % bins separator
    hist_test  = zeros(3000,n_bins);        % test histogram features
    hist_train = zeros(10000,n_bins);       % test histogram features

    % Loop through all training images
    disp('Train histogram starting...')
    for i=1:10000
        % Compute histograms
        im_fn    = [num2str(i) '.jpg'];             % image filename
        im       = imread([cfg.dir_train im_fn]);   % open image
        [hist,~] = histcounts(im,separator);        % create histograms
        hist_train(i,:) = hist/max(hist);           % normalize histograms

        % Display progress
        if mod(100*i/10000,5)==0
            fprintf('Train histogram progress: %i%%\n',uint8(100*i/10000));
        end
    end
    disp('Train histogram done.')

    % Loop through all test images
    disp('Test histogram starting...')
    for i=1:3000
        im_fn    = [num2str(i+10000) '.jpg'];       % image filename
        im       = imread([cfg.dir_test im_fn]);    % open image
        [hist,~] = histcounts(im,separator);        % create histograms
        hist_test(i,:) = hist/max(hist);            % normalize histograms

        % Display progress
        if mod(100*i/3000,5)==0
            fprintf('Test histogram progress: %i%%\n',uint8(100*i/3000));
        end
    end
    disp('Test histogram done.')

    % Clear variables
    clear separator msg i im_fn im hist n_bins;

    % Save data
    save('hist_features.mat','hist_test','hist_train')
end
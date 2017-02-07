% Analyze all pictures and generate the exposure features then save
% the data in the file exposure_features.mat
% The features are composed of:
%   - whether the image is rgb or b&w
%   - histogram of overall image
%   - histogram of face
%   - histogram of background
%   - surface occupied by the face
%
% Arguments:
%   - n_bins: number of bins to use for the histogram
%
% Return values:
%   - expo_train: exposure features for the train dataset

% Load the config parameters
SCRIPT_config;

% Check if the features already exist
if exist('exposure_features.mat','file')
    % Load the data form the pre-existing .mat file
    disp('Loading data from exposure_features.mat')
    load('exposure_features.mat');
else
    % Define parameters
    n_bins = 25;      % number of bins
    
    % Initialize variables
    separator  = linspace(0,255,n_bins+1);  % bins separator
    expo_train = zeros(10000,3*n_bins+2);   % test histogram features
    
    % Retrieve face size and position raw data
    formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
    fileID_train = fopen(cfg.facial_features_train,'r');
    dataArray_train  = textscan(fileID_train, formatSpec, 'Delimiter', ',', 'HeaderLines', 1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID_train);
    face_x0_train     = cellfun(@str2num,dataArray_train{3});
    face_y0_train     = cellfun(@str2num,dataArray_train{4});
    face_width_train  = cellfun(@str2num,dataArray_train{5});
    face_height_train = cellfun(@str2num,dataArray_train{6});

    % Loop through all training images
    disp('Train exposure starting...')
    for i=1:10000        
        % Compute histograms
        im_fn    = [num2str(i) '.jpg'];             % image filename
        im       = imread([cfg.dir_train im_fn]);   % open image
        
        % Test if the image is rgb or b&w
        if ndims(im) == 2
            expo_train(i,1) = 0;
        else
            expo_train(i,1) = 1;
            im = rgb2gray(im);
        end
        
        % Overall image histogram
        [hist,~] = histcounts(im(:),separator);
%         expo_train(i,2:n_bins+1) = cumsum(hist)/sum(hist);
        expo_train(i,2:n_bins+1) = hist/sum(hist);
        
        % Crop face
        [row, col, ~] = size(im);                       % image dimension
        x0 = 1 + face_x0_train(i)*col;                  % left corner
        x1 = min(col, x0 + face_width_train(i)*col);    % right corner
        y0 = 1 + face_y0_train(i)*row;                  % top corner
        y1 = min(row, y0 + face_height_train(i)*row);   % bottom corner
        im_face = im(uint16(y0):uint16(y1),uint16(x0):uint16(x1),:);        
        
        % Face histogram
        [hist,~] = histcounts(im_face(:),separator);
%         expo_train(i,2+n_bins:2*n_bins+1) = cumsum(hist)/sum(hist);
        expo_train(i,2+n_bins:2*n_bins+1) = hist/sum(hist);
        
        % Background histogram
        im_back = double(im);
        im_back(uint16(y0):uint16(y1),uint16(x0):uint16(x1),:) = nan;
        im_back = im_back(~isnan(im_back));  
        [hist,~] = histcounts(im_back(:),separator);
%         expo_train(i,2+2*n_bins:3*n_bins+1) = cumsum(hist)/sum(hist);
        expo_train(i,2+2*n_bins:3*n_bins+1) = hist/sum(hist);
        
        % Surface occupied
        expo_train(i,end) = face_width_train(i)*face_height_train(i);

        % Display progress
        if mod(100*i/10000,5)==0
            fprintf('Train exposure progress: %i%%\n',uint8(100*i/10000));
        end
    end
    disp('Train exposure done.')


    % Clear variables
    clear ans col dataArray_train face_height_train face_width_train;
    clear face_x0_train face_y0_train fileID_train formatSpec hist;
    clear i im im_back im_face im_fn n_bins row separator x0 x1 y0 y1;

    % Save data
    save('exposure_features.mat','expo_train')
end
% Configuration script: should be run before any other script to ensure
% proper configuration.
% Store all parameters in the cfg variable.

% Add customs function to the path
addpath('./fun')

% Leo
% cfg.dir_test  = 'Data/test/pictures_test/';
% cfg.dir_train = 'Data/train/pictures_train/';
% cfg.vgg_path  = 'vgg-face.mat';
% cfg.facial_features_test  = 'Data/test/facial_features_test.csv';
% cfg.facial_features_train = 'Data/train/facial_features_train.csv';
% cfg.scores_train = 'Data/train/aesthetic_scores_train.csv';

% Jules
cfg.dir_test  = '/Volumes/500GO Jules/Wavelet/Data/test/pictures_test/';
cfg.dir_train = '/Volumes/500GO Jules/Wavelet/Data/train/pictures_train/';
cfg.dir_data = '/Volumes/500GO Jules/Wavelet/Data/';
cfg.vgg_path  = '/Volumes/500GO Jules/Wavelet/Data/vgg-face.mat';
cfg.facial_features_test  = '/Volumes/500GO Jules/Wavelet/Data/test/facial_features_test.csv';
cfg.facial_features_train = '/Volumes/500GO Jules/Wavelet/Data/train/facial_features_train.csv';
cfg.scores_train = '/Volumes/500GO Jules/Wavelet/Data/train/Score_train.csv';
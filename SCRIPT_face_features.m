% This script needs matconvnet/initialize.m be executed first.
% Reset matlab and load paths
if ~exist('net','var')
    net=load('vgg-face');
end

% Parameters
pathname_test = '/Volumes/500GO Jules/Wavelet/Data/test/pictures_test/';
pathname_train = '/Volumes/500GO Jules/Wavelet/Data/train/pictures_train/';
nb_images=10000;

CNN_features=zeros(nb_images,4096);
for i=1:nb_images
    filename=[num2str(i) '.jpg'];
    u=imread([pathname_train filename]);
    res = vl_simplenn(net,image_preprocessing(u,net));
    CNN_features(i,:)=squeeze(res(36).x); % Take only fc8
    if mod(i,100)==0
        fprintf('%d/%d\n',i,nb_images)
    end
end
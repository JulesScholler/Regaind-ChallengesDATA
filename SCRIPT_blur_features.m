% Parameters
pathname.test = '/Volumes/500GO Jules/Wavelet/Data/test/pictures_test/';
pathname.train = '/Volumes/500GO Jules/Wavelet/Data/train/pictures_train/';
nb_images=3000;

blur_features=zeros(nb_images,10);
for i=1:nb_images
    filename=[num2str(i+10000) '.jpg'];
    u=imread([pathname.test filename]);
    blur_features(i,:)=eval_blur(u);
    if mod(i,100)==0
        fprintf('%d/%d\n',i,nb_images)
    end
end
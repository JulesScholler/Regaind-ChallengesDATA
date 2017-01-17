% Parameters
pathname_test = '/Volumes/500GO Jules/Wavelet/Data/test/pictures_test/';
pathname_train = '/Volumes/500GO Jules/Wavelet/Data/train/pictures_train/';

edges=linspace(0,255,11);
hist_features=zeros(3000,10);
for i=1:3000
    filename=[num2str(i+10000) '.jpg'];
    u=imread([pathname_test filename]);
    [hist,bin]=histcounts(u,edges);
    hist=hist/max(hist);
    hist_features(i,:)=hist;
    if mod(i,100)==0
        fprintf('%d/%d\n',i,3000)
    end
end
function print_images(im_nb)

pathname='/Volumes/500GO Jules/Wavelet/Data/train/pictures_train/';
for i=1:length(im_nb)
    imshow([pathname num2str(im_nb(i)) '.jpg'])
    pause
end
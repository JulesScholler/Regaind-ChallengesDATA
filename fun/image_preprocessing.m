function u=image_preprocessing(im,net)

v = imresize(im, net.meta.normalization.imageSize(1:2),'method',net.meta.normalization.interpolation);
u = single(v) - double(net.meta.normalization.averageImage);

end
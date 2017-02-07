function [contrast]=eval_contrast(im)

im_RGB=double(im)/255; % rescale [0,255]->[0,1]
Y=0.299*im_RGB(:,:,1)+0.587*im_RGB(:,:,2)+0.114*im_RGB(:,:,3); % Compute luminance
Lmax=max(max(Y));
Lmin=min(min(Y));
Lmean=mean(mean(Y));
contrast(1)=(Lmax-Lmin)/(Lmax+Lmin);
contrast(2)=Lmean/(Lmax+Lmin);
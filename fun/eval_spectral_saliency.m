function [s]=eval_spectral_saliency(im)

im=double(rgb2gray(im))/255;
x=[1 round(size(im,1)*1/3) round(size(im,1)*2/3) size(im,1)];
y=[1 round(size(im,2)*1/3) round(size(im,2)*2/3) size(im,2)];

for i=1:3
    for j=1:3
        ims{j+(i-1)*3}=im(x(i):x(i+1),y(j):y(j+1));
    end
end

for i=1:9
    n=5;
    h=1/n^2*ones(n);
    imconv=conv2(ims{i},h,'same');
    L=fft2(ims{i});
    Llog=fftshift(log(1+abs(L)));
    A=fft2(imconv);
    Alog=fftshift(log(1+abs(A)));
    d=sqrt((Llog-Alog).^2);
    s(i)=sum(d(:));
end
s=s/sum(s);
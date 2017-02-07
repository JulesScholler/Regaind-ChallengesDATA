function [hist]=eval_color(im_RGB)

im_HSV=rgb2hsv(double(im_RGB));
im_HSV(:,:,3)=im_HSV(:,:,3)/255;

% Define parameters
n_bins.H    = 12;     % number of bins
n_bins.S    = 5;
n_bins.V    = 3;

% Histograms
edges  = linspace(0,1,n_bins.H+1);            % bins separator
[tmp,~] = histcounts(im_HSV(:,:,1),edges);    % create histograms
hist = tmp/sqrt(sum(tmp.^2));                 % normalize histograms
dev(1) = std(tmp);                            % histograms std
clear edges tmp
edges  = linspace(0,1,n_bins.S+1);
[tmp,~] = histcounts(im_HSV(:,:,2),edges);             
hist = [hist tmp/sqrt(sum(tmp.^2))];
dev(2) = std(tmp);
clear edges tmp
edges  = linspace(0,1,n_bins.V+1);
[tmp,~] = histcounts(im_HSV(:,:,3),edges);             
hist = [hist tmp/sqrt(sum(tmp.^2))];
dev(3)=std(tmp);
hist=[hist dev/sqrt(sum(dev.^2))];

% H,S,V mean on whole image
HSV_mean=mean(im_HSV,1);
HSV_mean2=squeeze(mean(HSV_mean,2))';
hist=[hist HSV_mean2];
clear HSV_mean HSV_mean2

% H,S,V mean on inner quadrant
x=[round(size(im_HSV,1)*1/3) round(size(im_HSV,1)*2/3)];
y=[round(size(im_HSV,2)*1/3) round(size(im_HSV,2)*2/3)];
HSV_mean=mean(im_HSV(x(1):x(2),y(1):y(2),:),1);
HSV_mean2=squeeze(mean(HSV_mean,2))';
hist=[hist HSV_mean2];
clear HSV_mean HSV_mean2

% Pleasure, Arousal, Dominance
Pleasure = mean(mean(0.69*im_HSV(:,:,3) + 0.22*im_HSV(:,:,2)));
Arousal = mean(mean(-0.31*im_HSV(:,:,3) + 0.60*im_HSV(:,:,2)));
Dominance = mean(mean(0.76*im_HSV(:,:,3) + 0.32*im_HSV(:,:,2)));
hist=[hist Pleasure Arousal Dominance];

end
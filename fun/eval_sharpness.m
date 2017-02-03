function sharpness = eval_sharpness(im)
% Eval the sharpness of a gray image using the Tenengrad method with a
% threshold of zero.

% Convert the image to gray
im_ = double(im);
if ndims(im) > 2
    im_ = mean(im_,3);
end
n_nan = sum(sum(isnan(im_)));
im_(isnan(im_)) = 0;

% Define the Sobolev operators
S_x = [-1 0 1; -2 0 2; -1 0 -1]/4;
S_y = [1 2 1; 0 0 0; -1 -2 -1]/4;

% Perform the edge detection
temp_x = conv2(im_, S_x, 'same');
temp_y = conv2(im_, S_y, 'same');

% Compute the sharpness
sharpness = sum(sum(temp_x.^2 + temp_y.^2))/(numel(im_)-n_nan);

% Normalize
sharpness = sharpness/(255*255);

end


function [blur]=eval_blur(u)

% Face detection
faceDetector = vision.CascadeObjectDetector;
bboxes = step(faceDetector, u);
if size(bboxes,1)==4 && size(bboxes,2)==1
    face=u(bboxes(2):bboxes(2)+bboxes(4),bboxes(1):bboxes(1)+bboxes(3),:);
else
%     fprintf('Warning: no face detected\n')
    face=u;
end

% If RGB, transform to B&W
if size(u,3)>1
    face=mean(face,3);
end

% Compute grad intensity histogram 
gradx=conv2(double(face),[-1 -1;1 1],'same');
grady=conv2(double(face),[-1 1;-1 1],'same');
grad=sqrt(gradx.^2+grady.^2);
blur=histcounts(grad,10);
blur=blur/max(blur);



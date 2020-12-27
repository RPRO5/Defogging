function A = atmLight(img, JDark)

% the color of the atmospheric light is very close to the color of the sky
% so just pick the first few pixels that are closest to 1 in JDark
% and take the average

% pick top 0.1% brightest pixels in the dark channel

% get the image size
[height, width, ~] = size(img);
imsize = width * height;

numpx = floor(imsize/1000); % accomodate for small images
JDarkVec = reshape(JDark,imsize,1); % a vector of pixels in JDark
ImVec = reshape(img,imsize,3);  % a vector of pixels in my image

[JDarkVec, indices] = sort(JDarkVec); %sort
indices = indices(imsize-numpx+1:end); % need the last few pixels because those are closest to 1
atmSum = zeros(1,3);
atmSum=double(atmSum);
ImVec=double(ImVec);
indices=double(indices);
for ind = 1:numpx
    atmSum = atmSum + ImVec(indices(ind),:);
end
A = atmSum / numpx; 

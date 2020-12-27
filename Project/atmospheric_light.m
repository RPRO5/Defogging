function A = atmospheric_light(I, dc, percentage)
%ESTIMATE_AIRLIGHT Estimates airlight from the given image and dark channel
%Brightest pixels from the dark channel are selected
% and pixel values with highest intensity (euclidian norm)
% in hazy image returned as atmospheric light
%
% Metin Suloglu, 2018
% Bahcesehir University

assert(size(I, 1) == size(dc, 1) & size(I, 2) == size(dc, 2),... 
    "Image sizes must be equal");

if nargin == 2
    percentage = 0.001;
end

[M, N, ~] = size(I);
n_pixels = M * N;
dc = dc(:);
I = reshape(I, [n_pixels, 1, 3]);

k = ceil(n_pixels * percentage);

[~, indeces] = sort(dc, 'descend');
img_sub = I(indeces(1:k), :, :);

[~, max_index] = max(vecnorm(img_sub, 2, 3));

A = img_sub(max_index, :);

end


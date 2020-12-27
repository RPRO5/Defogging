%Finding edges of a color image
%Authors : Jeny Rajan, Chandrashekar P.S 
%Usage edgecolor('abc.jpg');
function R=edgecolor(img);

[x y z]=size(img);
if z==1
    rslt=edge(img,'canny');
elseif z==3
    img1=rgb2ycbcr(img);
    dx1=edge(img1(:,:,1),'canny');
    dx1=(dx1*255);
    img2(:,:,1)=dx1;
    img2(:,:,2)=img1(:,:,2);
    img2(:,:,3)=img1(:,:,3);
    rslt=ycbcr2rgb(uint8(img2));
end
 R=rslt;
% ll={R 0.2};
% [Img] = PalKing(ll);
% figure,imshow(Img);
end
function [Img] = PalKing(varargin)
[image,threshold] = varargin{:};
pixel_min = min(image(:));
pixel_max = max(image(:));

fImg = FuzzyImage(image,threshold);

eImg = FuzzyEnhance(fImg,0.5,2);

rImg = FuzzyRestore(image,eImg,threshold);

minImg = NeighborMin(image);

Img = EdgeDetection(minImg,rImg);%rImg

end



function [FOUImg] = FuzzyImage(varargin)
[image,threshold] = varargin{:};
pixel_min = double(min(image(:)));
pixel_max = double(max(image(:)));
image = double(image);
image(logical(image>threshold)) = 1-0.5.*((image(logical(image>threshold))-pixel_max)/double(pixel_max - threshold + eps)).^2;
image(logical(image<=threshold)) = 0.5*((image(logical(image<=threshold))-pixel_min)/double(threshold-pixel_min + eps)).^2;
FOUImg = image;
end


function [FEImg] = FuzzyEnhance(varargin)
[image,threshold,interate] = varargin{:};
for i=1:interate
    image(logical(image<=threshold)) = ( (image(logical(image<=threshold))).^2) ./threshold;
    image(logical(image<=1 & image>threshold)) = 1 - (1 - image(logical(image<=1 & image>threshold))).^2 ./(1-threshold);
end
FEImg = image;
end


function [FRImg] = FuzzyRestore(varargin)
[originalImage,image,threshold] = varargin{:};
pixel_min = double(min(image(:)));
pixel_max = double(max(image(:)));
threshold = double(threshold);
image(logical(originalImage>threshold)) = pixel_max + (threshold-pixel_max) .* sqrt( (1- image(logical(originalImage>threshold))));
image(logical(originalImage<=threshold)) = pixel_min + (threshold-pixel_min) .* sqrt( (2.*image(logical(originalImage<=threshold))));
FRImg = uint8(image);
end


function [FMinImg] = NeighborMin(varargin)
% image = varargin{:};
% enlargeImg = padarray(image,[1 1],'replicate','both');
% MinImg = colfilt(enlargeImg,[3 3],'sliding',@min);
% FMinImg = MinImg(2:end-1,2:end-1);
image = varargin{:};
interval = 1;
interval_matrix = 2*interval + 1;
enlargeImg = padarray(image,[interval interval],'replicate','both');
MinImg = colfilt(enlargeImg,[interval_matrix interval_matrix],'sliding',@min);
FMinImg = MinImg(interval+1:end-interval,interval+1:end-interval);
end


function [FImg] = EdgeDetection(varargin)
[minImage,restoreImage] = varargin{:};
FImg = abs(real(restoreImage) - real(minImage));
end


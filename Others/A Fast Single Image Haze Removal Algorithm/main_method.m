
%% Set Parameters
clear all;clc;
traindataPath = './Dataset/';
trainData = imageSet(traindataPath,'recursive');
newSize = 500; %Size of the image
OutputPath = './Results/ColorAttentuationPriorDehazing/';
% GroundTruth = imageSet('GroundTruth','recursive');
% 
% img1 = read(trainData,1);
% imshow(img1)
% path = char(trainData.ImageLocation(1));
% [~,name,~] = fileparts(path) ;

for count = 1:trainData.Count
    img = read(trainData, count);
    imgpath = char(trainData.ImageLocation(count));
    [~,imgname,~] = fileparts(imgpath) ;
    %% Pre-Processing
    img = imresize(img, [newSize,newSize]);
% img = double(img);   %convert image into double class
% img = img./255;        %normalize the pixels to whole range between [0,1]
I=img;
r = 15;
beta = 1.0;

%----- Parameters for Guided Image Filtering -----
gimfiltR = 60;
eps = 10^-3;
%-------------------------------------------------
tic;
[dR, dP] = calVSMap(I, r);
refineDR = imguidedfilter(dR, I, 'NeighborhoodSize', [gimfiltR, gimfiltR], 'DegreeOfSmoothing', eps);
tR = exp(-beta*refineDR);
tP = exp(-beta*dP);

a = estA(I, dR);
t0 = 0.05;
t1 = 1;
I = double(I)/255;
[h w c] = size(I);
J = zeros(h,w,c);
J(:,:,1) = I(:,:,1)-a(1);
J(:,:,2) = I(:,:,2)-a(2);
J(:,:,3) = I(:,:,3)-a(3);

t = tR;
[th tw] = size(t);
for y=1:th
    for x=1:tw
        if t(y,x)<t0
            t(y,x)=t0;
        end
    end
end

for y=1:th
    for x=1:tw
        if t(y,x)>t1
            t(y,x)=t1;
        end
    end
end

J(:,:,1) = J(:,:,1)./t;
J(:,:,2) = J(:,:,2)./t;
J(:,:,3) = J(:,:,3)./t;

J(:,:,1) = J(:,:,1)+a(1);
J(:,:,2) = J(:,:,2)+a(2);
J(:,:,3) = J(:,:,3)+a(3);

toc;


figure;
imshow([I J]);
title('hazy image and dehazed image');

%% Save Image
    savepath = strcat(OutputPath,imgname, '.png');
    imwrite(J,savepath);
end

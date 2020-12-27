%% Set Parameters
clear all;clc;
traindataPath = './time/';
trainData = imageSet(traindataPath,'recursive');
newSize = 500; %Size of the image
OutputPath = './Results/11/'%Fast Visibility/';
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
    img = double(img);   %convert image into double class
	img = img./255;        %normalize the pixels to whole range between [0,1]
tic;
	%% Fog removal
    sv=2*floor(max(size(img))/50)+1;
    % ICCV'2009 paper result (NBPC)
    res=nbpc(img,sv,0.95,0.5,1,1.3); % Fast visibility
toc
%% Save Image
    savepath = strcat(OutputPath,imgname, '.png');
%     savepath = strcat(OutputPath,imgname, '.jpg');
    imwrite(res,savepath);
    
end
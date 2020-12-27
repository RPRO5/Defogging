%[file,absPath]=uigetfile('*.tif;*.bmp;*.png;*.jpeg;*.jpg;*.gif','File Image');
%name=[absPath file];
clear all;clc;
traindataPath = './Dataset/';
trainData = imageSet(traindataPath,'recursive');
newSize = 500; %Size of the image
OutputPath = './Results/11/'%Single Image dehazing using a multi layer perception/';
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
image = double(img)/255.0;

tic
 %% Save Image
result= dehaze(image, 0.7,8);
toc
    savepath = strcat(OutputPath,imgname, '.png');
%     savepath = strcat(OutputPath,imgname, '.jpg');
    imwrite(result,savepath);
end




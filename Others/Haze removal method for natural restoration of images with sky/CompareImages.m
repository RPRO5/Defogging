%% Set Parameters
clear all;clc;
GroundTruth = imageSet('GroundTruth','recursive'); % Path of ground truth images
% testimagePath = './Dataset'; % Path of test images
% testimagePath = './Results/A Fast Single Image Haze Removal Algorithm';
% testimagePath = './Results/Fast Visibility Restoration from a Single Color or Gray Level Image';
% testimagePath = './Results/single image haze removal using dark channel prior';
% testimagePath = './Results/Improved Visibility of Road Scene Images under Heterogeneous Fog';
% testimagePath = './Results/ImprovedSingleImageByFusion';
% testimagePath = './Results/OptimizedContrastEnhance';
% testimagePath = './Results/Single Image dehazing using a multi layer perception';
% testimagePath = './Results/Single Image Dehazing with white Balance';
%testimagePath = './Results/Single Image fog removal based on fusion strategy';
%testimagePath ='./Results/Single Image Haze Removal Using Dark Channel Prior';
%testimagePath='./Results/Guided Image Filtering';
testimagePath='./Results/FRIDA2 ';
testImages = imageSet(testimagePath,'recursive');
mse = zeros(1,testImages.Count);
psnrV = zeros(1,testImages.Count);
ssimvalV = zeros(1,testImages.Count);
size = 500; % Resize size
%% Comparision
for count = 1:testImages.Count
    testimg = read(testImages, count);
    imgpath = char(testImages.ImageLocation(count));
    [~,imgname,~] = fileparts(imgpath);
    testimgId = str2num(imgname(end-1:end));
   % testimgId = str2num(imgname(1:2));
    GroundTruthimg = read(GroundTruth, testimgId);
    

    testimg = imresize(testimg,[size,size]);
    GroundTruthimg = imresize(GroundTruthimg,[size,size]);
    testimg = rgb2gray(testimg);
    GroundTruthimg = rgb2gray(GroundTruthimg);

    mse(1,count) = immse(GroundTruthimg,testimg);
    psnrV(1,count) = psnr(GroundTruthimg,testimg);
    ssimvalV(1,count) = ssim(GroundTruthimg,testimg);
end

%Average
disp('Average MSE is')
mean(mse)
disp('Average PSNR is')
mean(psnrV)
disp('Average ssim Index is');
mean(ssimvalV)



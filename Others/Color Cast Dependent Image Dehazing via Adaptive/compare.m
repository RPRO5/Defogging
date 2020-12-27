%% Set Parameters
clear all;clc;
GroundTruth = imageSet('Groundtruth','recursive'); % Path of ground truth images
% testimagePath = './Dataset'; % Path of test images
%testimagePath = './Results/ColorAttenuationPriorDehazing';
% testimagePath = './Results/DarkChannel';
% testimagePath = './Results/Guided';
% testimagePath = './Results/MultipleFusion';
% testimagePath = './Results/visibresto2';
% testimagePath = './Results/OptimizedContrastEnhance';
% testimagePath = './Results/Final_Output';
%testimagePath = './Results/Dehaze';
testimagePath = './Results/FRIDA2';
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
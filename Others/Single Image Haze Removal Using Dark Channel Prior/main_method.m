 
%% Set Parameters
clear all;clc;
traindataPath = './Dataset/';
trainData = imageSet(traindataPath,'recursive');
newSize = 500; %Size of the image
OutputPath = '../Results/DarkChannel/';

for count = 1:trainData.Count
    img = read(trainData, count);
    imgpath = char(trainData.ImageLocation(count));
    [~,imgname,~] = fileparts(imgpath) ;
    %% Pre-Processing
    img = imresize(img, [newSize,newSize]);
    
    img=double(img);
    img=img./255;

    % 3.0 Dark Channel Prior
    dark = darkChannel(img);
   

    % 4.4 Estimating the Atmospheric Light
    atmospheric = atmLight(img, dark);

    % 4.1 Estimating the Transmission
    transmission = transmissionEstimate(img, atmospheric);
    

    % 4.3 Recovering the Scene Radiance
    radiance = getRadiance(atmospheric, img, transmission);
   
    
    % 4.2 Apply Soft Matting
    refinedTransmission = matte(img, transmission);
    
    % 4.3 Recovering the Scene Radiance
    refinedRadiance = getRadiance(atmospheric, img, refinedTransmission);
   
    %% Save Image
    savepath = strcat(OutputPath,imgname, '.png');
%     savepath = strcat(OutputPath,imgname, '.jpg');
    imwrite(refinedRadiance,savepath);
end

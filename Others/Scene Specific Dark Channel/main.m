% clear all;clc;
trainData = imageSet('./time','recursive');
patchSize = 15;     %the patch size is set to be 15 x 15
padSize =  floor((patchSize-1)/2);
newSize = 500; %Size of the image
intialRegions = 5; %number of regions for segmentation
OutputPath = './Results/11/'; % Path for saving output images
t=0;
for count = 1:trainData.Count
    
     img = read(trainData, count);
    imgpath = char(trainData.ImageLocation(count));
    [~,imgname,~] = fileparts(imgpath) ;
    %Pre-Processing
    img = imresize(img, [newSize,newSize]);
tic
%     % Dark Channel Prior
    patchSize = 3;
    dark = darkChannel(img,patchSize);
    
%     Superpixel segmentation
    [L,N,avgInten] = superPixelSegment(dark, intialRegions);
%     Adaptive dark channel estimation
    [JDarks,Adaptivedark] = AdaptivedarkChannel(img, L, N, avgInten);
%     
    img = double(img);   %convert image into double class
	img = img./255;
%     
    %figure
    BW = boundarymask(L);
    imshow(imoverlay(img,BW,'red'),'InitialMagnification',67)
   
    Adaptivedark = double(Adaptivedark);
    Adaptivedark = Adaptivedark./255;

    
    % Estimating the Atmospheric Light
    atmospheric = atmLight(img, Adaptivedark);
    
    
    % Estimating the Transmission
    transmission = adaptiveTransmissionEstimate(img, atmospheric, L, N, avgInten);
    
   

    %Find refinded Transmission
    window_size=75;
    refinedTransmission = Guided_Filter(transmission,img,window_size);
    

    % Recovering the Scene Radiance
    refinedRadiance = getRadiance(atmospheric, img, refinedTransmission);
    
     %%Post processing
    enhancedimg = SimplestColorBalance(refinedRadiance);
    
%     %White Balancing
    whiteBalance = whiteBalancing(enhancedimg);
    
    toc
    
    %Save Image
    savepath = strcat(OutputPath,imgname, '.png');
    imwrite(uint8(whiteBalance),savepath);
    
end



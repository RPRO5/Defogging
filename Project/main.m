% clear all;clc;
trainData = imageSet('./Dataset','recursive');
patchSize = 15;     %the patch size is set to be 15 x 15
padSize =  floor((patchSize-1)/2);
newSize = 500; %Size of the image
intialRegions = 5; %number of regions for segmentation
OutputPath = './Results/11/'; % Path for saving output images

for count = 1:trainData.Count
    
     img = read(trainData, count);
    imgpath = char(trainData.ImageLocation(count));
    [~,imgname,~] = fileparts(imgpath) ;
    tic;
    %Pre-Processing
    img = imresize(img, [newSize,newSize]);

 
  imgE(:,:,1)=uint8(bilateralFilter(double(img(:,:,1))));
  imgE(:,:,2)=uint8(bilateralFilter(double(img(:,:,2))));
  imgE(:,:,3)=uint8(bilateralFilter(double(img(:,:,3))));


    
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
    imgE = double(imgE);   %convert image into double class
    imgE = imgE./255;
    
    %figure
    BW = boundarymask(L);
   % imshow(imoverlay(img,BW,'red'),'InitialMagnification',67)
 
    Adaptivedark = double(Adaptivedark);
    Adaptivedark = Adaptivedark./255;
    
    % Estimating the Atmospheric Light
   
  atmospheric1 = atmospheric_light(img, Adaptivedark, 0.001);
  atmospheric2 = atmospheric_light(img, dark, 0.001);
  
  atmospheric = (atmospheric1+atmospheric2)/2;

    % Estimating the Transmission
    transmission = adaptiveTransmissionEstimate(img, atmospheric, L, N, avgInten);
    
    %Find refinded Transmission
    window_size=75;
   refinedTransmission=guidedfilter_color(imgE,transmission,window_size,0.5);


    % Recovering the Scene Radiance
    refinedRadiance = getRadiance(atmospheric, img, refinedTransmission);
    
     %%Post processing
    enhancedimg = SimplestColorBalance(refinedRadiance);

%     %White Balancing
   whiteBalance=wdc_whiteImage(enhancedimg,atmospheric);  

    img1=whiteBalance;
    lab1 = rgb_to_lab(whiteBalance);
 
%     % CLAHE
     lab2 = lab1;
     lab2(:, :, 1) = adapthisteq(lab2(:, :, 1));
    
     img2 = lab_to_rgb(lab2);
   
%     % input1
     R1 = double(lab1(:, :, 1)) / 255;
%     % calculate laplacian contrast weight
     lap = fspecial('Laplacian')
     WL1 = abs(imfilter(R1, fspecial('Laplacian'), 'replicate', 'conv'));
%     %calculate Local contrast weight
     h = 1/16* [1, 4, 6, 4, 1];
     WC1 = imfilter(R1,  h'*h, 'replicate', 'conv');
     WC1(find(WC1 > (pi/2.75))) = pi/2.75;
     WC1 = (R1 - WC1).^2;
%     % calculate the saliency weight
     WS1 = saliency_detection(img1);
%     % calculate the exposedness weight
     sigma = 0.25;
     aver = 0.5;
     WE1 = exp(-(R1 - aver).^2 / (2*sigma^2));
 
%     % input2
     R2 = double(lab2(:, :, 1)) / 255;
%     % calculate laplacian contrast weight
     WL2 = abs(imfilter(R1, fspecial('Laplacian'), 'replicate', 'conv'));
%     %calculate Local contrast weight
     h = 1/16* [1, 4, 6, 4, 1];
     WC2 = imfilter(R2, h'*h, 'replicate', 'conv');
     WC2(find(WC2 > (pi/2.75))) = pi/2.75;
     WC2 = (R2 - WC2).^2;
%     % calculate the saliency weight
     WS2 = saliency_detection(img2);
%     % calculate the exposedness weight
     sigma = 0.25;
     aver = 0.5;
     WE2 = exp(-(R2 - aver).^2 / (2*sigma^2));
% 
%     % calculate the normalized weight
     W1 = (WL1 + WC1 + WS1 + WE1) ./ ...
          (WL1 + WC1 + WS1 + WE1 + WL2 + WC2 + WS2 + WE2);
     W2 = (WL2 + WC2 + WS2 + WE2) ./ ...
          (WL1 + WC1 + WS1 + WE1 + WL2 + WC2 + WS2 + WE2);
    
%     % calculate the gaussian pyramid
     level = 8;
     Weight1 = gaussian_pyramid(W1, level);
     Weight2 = gaussian_pyramid(W2, level);

%     % calculate the laplacian pyramid
%     % input1
     R1 = laplacian_pyramid(double(double(img1(:, :, 1))), level);
     G1 = laplacian_pyramid(double(double(img1(:, :, 2))), level);
     B1 = laplacian_pyramid(double(double(img1(:, :, 3))), level);
%     % input2
     R2 = laplacian_pyramid(double(double(img2(:, :, 1))), level);
     G2 = laplacian_pyramid(double(double(img2(:, :, 2))), level);
     B2 = laplacian_pyramid(double(double(img2(:, :, 3))), level);
 
%     % fusion
     for i = 1 : level
        R_r{i} = Weight1{i} .* R1{i} + Weight2{i} .* R2{i};
        R_g{i} = Weight1{i} .* G1{i} + Weight2{i} .* G2{i};
        R_b{i} = Weight1{i} .* B1{i} + Weight2{i} .* B2{i};
     end

%     % reconstruct & output
     R = pyramid_reconstruct(R_r);
     G = pyramid_reconstruct(R_g);
     B = pyramid_reconstruct(R_b);
 
     fusion = cat(3, uint8(R), uint8(G), uint8(B));
    toc
   
   
    %Save Image
    savepath = strcat(OutputPath,imgname, '.png');
    imwrite(uint8(fusion),savepath);
    
    
end
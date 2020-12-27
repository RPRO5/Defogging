
%% Set Parameters
clear all;clc;
traindataPath = './time/';
trainData = imageSet(traindataPath,'recursive');
newSize = 500; %Size of the image
OutputPath = './Results/11/';%MultipleFusion/';
% GroundTruth = imageSet('GroundTruth','recursive');

t=0;
for count = 1:trainData.Count
    img = read(trainData, count);
    imgpath = char(trainData.ImageLocation(count));
    [~,imgname,~] = fileparts(imgpath) ;

    %% Pre-Processing
    img = imresize(img, [newSize,newSize]);
    img = im2double(img);   %convert image into double class

   imshow(img);
   title('Original Hazy Image');

% Inputs that are derrived from the Hazy image
tic;
    firstInput = whiteBalance( img );
   figure;subplot(1,2,1);imshow(firstInput);title('First Input');
   secondInput = enhanceContrast( img );
   subplot(1,2,2);imshow(secondInput);title('Second Input');

%Weight maps of the First Input

 luminanceWeightmap1 = luminanceWeightmap(firstInput);
figure;subplot(1,3,1);imshow(luminanceWeightmap1);title('luminanceWeightmap of First input');
chromaticWeightmap1 = chromaticWeightmap(firstInput);
subplot(1,3,2);imshow(chromaticWeightmap1);title('chromaticWeightmap of First input');
saliencyWeightmap1 = saliencyWeightmap(firstInput);
subplot(1,3,3);imshow(saliencyWeightmap1);title('saliencyWeightmap of First input');

%Resultant Weight map of the first input

resultedWeightmap1 = luminanceWeightmap1 .* chromaticWeightmap1 .* saliencyWeightmap1 ;

%Weightmaps of the Second Input

luminanceWeightmap2 = luminanceWeightmap(secondInput);
figure;subplot(1,3,1);imshow(luminanceWeightmap2);title('luminanceWeightmap of Second input');
chromaticWeightmap2 = chromaticWeightmap(secondInput);
subplot(1,3,2);imshow(chromaticWeightmap2);title('chromaticWeightmap of Second input');
saliencyWeightmap2 = saliencyWeightmap(secondInput);
subplot(1,3,3);imshow(saliencyWeightmap2);title('saliencyWeightmap of Second input');

%Resultant Weight map of the second input

resultedWeightmap2 = luminanceWeightmap2 .* chromaticWeightmap2 .* saliencyWeightmap2 ;

%Normalized Weight maps of the Inputs

normaizedWeightmap1 = resultedWeightmap1 ./ (resultedWeightmap1 + resultedWeightmap2);
normaizedWeightmap2 = resultedWeightmap2 ./ (resultedWeightmap1 + resultedWeightmap2);


%Generating Gaussian Pyramid for normalized weight maps
gaussianPyramid1 = genPyr(normaizedWeightmap1,'gauss',5);
gaussianPyramid2 = genPyr(normaizedWeightmap2,'gauss',5);

for i = 1 : 5
    tempImg = [];
    for j = 1 : size(img,3)
        laplacianPyramid1 = genPyr(firstInput(:,:,j),'laplace',5); %Generating Laplacian Pyramid for derrived inputs
        laplacianPyramid2 = genPyr(secondInput(:,:,j),'laplace',5);
        rowSize = min([size(laplacianPyramid1{i},1),size(laplacianPyramid2{i},1),size(gaussianPyramid1{i},1),size(gaussianPyramid2{i},1)]);
        columnSize = min([size(laplacianPyramid1{i},2),size(laplacianPyramid2{i},2),size(gaussianPyramid1{i},2),size(gaussianPyramid2{i},2)]);
        tempImg(:,:,j) = laplacianPyramid1{i}(1:rowSize , 1:columnSize) .* gaussianPyramid1{i}(1:rowSize, 1:columnSize) + laplacianPyramid2{i}(1:rowSize, 1:columnSize) .* gaussianPyramid2{i}(1:rowSize, 1:columnSize);
    end
    fusedPyramid1{i} = tempImg;
end

enhancedImage = pyrReconstruct(fusedPyramid1);
toc
figure
imshow(enhancedImage);
title('Dehazed Image');
t=t+toc;
 %Save Image
    savepath = strcat(OutputPath,imgname, '.png');
    imwrite(enhancedImage,savepath);
end
time=t/10;
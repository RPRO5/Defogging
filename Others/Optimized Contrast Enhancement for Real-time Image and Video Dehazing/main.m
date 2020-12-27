%% Set Parameters
clear all;clc;
traindataPath = './Dataset/';
trainData = imageSet(traindataPath,'recursive');
newSize = 500; %Size of the image
OutputPath = './Results/OptimizedContrastEnhance/';
% GroundTruth = imageSet('GroundTruth','recursive');


for count = 1:trainData.Count
    img = read(trainData, count);
    imgpath = char(trainData.ImageLocation(count));
    [~,imgname,~] = fileparts(imgpath) ;
    %% Pre-Processing
    img = imresize(img, [newSize,newSize]);
   
%% Fog removal
    img = SimplestColorBalance(img);
    figure,imshow(uint8(img))
   [m, n, ~] = size(img);

%**********************find the airlight**********************
blocksize = 200;
showFigure = false;
A = AirlightEstimate(img, blocksize, showFigure);

%*************find and refine the transmission map************
patchsz = 8; % the size of a patch
lambda = 5; % control the importance of contrast loss and info loss
r = 10;
eps = 10^-8;
T = TransEstimate(img, patchsz, A, lambda);
t = guidedfilter(double(rgb2gray(uint8(img))) / 255, T, r, eps);
% figure,imagesc(t), axis image, truesize; colorbar

% if mean2(img(:,:,2)) > mean2(img(:,:,3))
%     Nrer = [0.8, 0.97, 0.95];
% else
%     Nrer = [0.8, 0.93, 0.95];
% end
% betar = -log10(Nrer(1));
% betag = -log10(Nrer(2));
% betab = -log10(Nrer(3));
% tb = t;
% tg = tb.^(betag/betab);
% tr = tb.^(betar/betab);


%*********************restore the image***********************
J(:,:,1) = (img(:,:,1) - A(1)) ./ t + A(1);
J(:,:,2) = (img(:,:,2) - A(2)) ./ t + A(2);
J(:,:,3) = (img(:,:,3) - A(3)) ./ t + A(3);
J(:,:,1) = (J(:, :, 1) - min(min(J(:, :, 1)))) / ...
    (max(max(J(:, :, 1))) - min(min(J(:, :, 1)))) * 255;
J(:,:,2) = (J(:, :, 2) - min(min(J(:, :, 2)))) / ...
    (max(max(J(:, :, 2))) - min(min(J(:, :, 2)))) * 255;
J(:,:,3) = (J(:, :, 3) - min(min(J(:, :, 3)))) / ...
    (max(max(J(:, :, 3))) - min(min(J(:, :, 3)))) * 255;
figure,imshow([uint8(J)])

%% Save Image
    savepath = strcat(OutputPath,imgname, '.png');
% savepath = strcat(OutputPath,imgname, '.jpg');
    imwrite(uint8(J),savepath);
    
end
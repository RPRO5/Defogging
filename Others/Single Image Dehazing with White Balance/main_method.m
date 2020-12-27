%% Set Parameters
clear all;clc;
traindataPath = './Dataset/';
trainData = imageSet(traindataPath,'recursive');
newSize = 500; %Size of the image
OutputPath = './Results/Dehaze/';
% GroundTruth = imageSet('GroundTruth','recursive');


for count = 1:trainData.Count
    img = read(trainData, count);
    imgpath = char(trainData.ImageLocation(count));
    [~,imgname,~] = fileparts(imgpath) ;
    %% Pre-Processing
    img = imresize(img, [newSize,newSize]);

    % white balance
    img_wb = double(SimplestColorBalance1(img)) / 255;
    RL = zeros(size(img));
    %imshow([double(img) / 255, img_wb])

    % image decomposition
    for i = 1 : 3
        k = 0.5 * img_wb(:, :, i) / max(max(img_wb(:, :, i)));
        AL(:, :, i) = (1 - k) .* img_wb(:, :, i);
        RL(:, :, i) = k .* img_wb(:, :, i);
    end
    %figure,imshow([RL,AL])

    % to gray
    img_gray = double(rgb2gray(img))/255;
    img = double(img) / 255;

    % find the airlight
    blksz = 20 * 20;
    showFigure = false;
    A = AirlightEstimate(img, blksz, showFigure);

    % dark channel
    [m, n, ~] = size(img);
    dc = zeros(m, n);
    for x = 1 : m
        for y = 1 : n
            dc(x, y) = min(img(x, y, :));
        end
    end
    dc = imresize(minfilt2(dc, [11, 11]), [m, n]);
    t = 1 - dc;
    r = 150;
    eps = 10^-6;
    filter_img = double(rgb2gray(uint8(AL * 255))) / 255;
    t_f = guidedfilter(filter_img, t, r, eps);
    %figure,imshow(t_f)

    F=fspecial('gaussian',[20,20],10);%估计直接用这个filter有问题
    Lsmooth = imfilter(t_f, F, 'replicate', 'conv');
    Ldetail = t_f - Lsmooth;
    t_enhanced = Lsmooth + 1.7 * Ldetail;
    %t_enchanced = t_enhanced / max(max(t_enhanced));
    %figure,imshow(t_enhanced)
    J(:, :, 1) = (img(:, :, 1) - A(1)) ./ max(t_enhanced, 0.1) + A(1);
    J(:, :, 2) = (img(:, :, 2) - A(2)) ./ max(t_enhanced, 0.1) + A(2);
    J(:, :, 3) = (img(:, :, 3) - A(3)) ./ max(t_enhanced, 0.1) + A(3);

    meanAL = [mean2(AL(:,:,1)), mean2(AL(:,:,2)), mean2(AL(:,:,3))];
    meanRL = [mean2(RL(:,:,1)), mean2(RL(:,:,2)), mean2(RL(:,:,3))];
    %path = strcat(WritePath,int2str(Data), '.png');
    %figure,imshow([img, J])

%% Save Image
    savepath = strcat(OutputPath,imgname, '.png');
% savepath = strcat(OutputPath,imgname, '.jpg');
    imwrite(J,savepath);
    

end


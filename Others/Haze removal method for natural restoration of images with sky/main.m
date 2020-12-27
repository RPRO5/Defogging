clear all
clc
close all
tao=3.4

kenlRatio = .01;
minAtomsLight = 240;
aerialPerspective = 0.95;
t0=cputime;
% dirname =  '.\image\';
% Files = dir(fullfile(dirname));
% LengthFiles=length(Files);
% 
% for i=3:LengthFiles
%     clear dRGB dRGBk img;
%     fileName=Files(i).name;
%     disname{i}=strcat(dirname,fileName);
%     imgu=imread(disname{i});
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
    
    %Pre-Processing
    imgu = imresize(img, [newSize,newSize]);

    img=double(imgu);
    [h,w,l]=size(img);
    dRGB=img/255;
    tic;
    [At]=sky_decte2(img);
    
    dRGBk(:,:,1)=img(:,:,1)/At(1);
    dRGBk(:,:,2)=img(:,:,2)/At(2);
    dRGBk(:,:,3)=img(:,:,3)/At(3);
    At=At./255;

    %% Dark channel
    J = makeDarkChannel(dRGBk,10);

    %% matting
    r = 60;
    eps = 10^-6;
    s = 4;
    T = 1-0.95*fastguidedfilter_color(dRGB,J, r, eps, s);

    %% LL
    hsl=rgb2hsl(dRGB);
    dres=hsl(:,:,3);
    yy=dres(:);
    b4= prctile(yy,95);
    
    dRatiob=tao/b4;
    dres=dRatiob*dres;
    LR=exp(-dres.*0.3324);
    LG=exp(-dres.*0.3433);
    LB=exp(-dres.*0.3502);
    min1=min(min(T));
    max1=max(max(T));
    a=20/(max1-min1);
    b=-10-a*min1;
    alpht=1./(1+exp(-a.*T-b));
    synR=alpht.*T+(1-alpht).*LR;
    synG=alpht.*T+(1-alpht).*LG;
    synB=alpht.*T+(1-alpht).*LB;
    clear LLL;
    LLL(:,:,1) =((dRGB(:,:,1)-At(1))./synR +At(1));
    LLL(:,:,2) = ((dRGB(:,:,2)-At(2))./synG +At(2));
    LLL(:,:,3) = ((dRGB(:,:,3)-At(3))./synB +At(3));
    mi= prctile(LLL(:),1);
    ma= prctile(LLL(:),99);
    LLL(:,:,1)=(LLL(:,:,1)-mi)*255/(ma-mi);
    LLL(:,:,2)=(LLL(:,:,2)-mi)*255/(ma-mi);
    LLL(:,:,3)=(LLL(:,:,3)-mi)*255/(ma-mi);
    LLL=gamma0(uint8(LLL));
%     figure,imshow(LLL);
%     imwrite(LLL, ['.\result\_', fileName]);
toc
%Save Image
    savepath = strcat(OutputPath,imgname, '.png');
    imwrite(uint8(LLL),savepath);
    
end

clear all;

% clear,clc,close all
% pic=imread('Example1.png');

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
    pic = imresize(img, [newSize,newSize]);

pic=double(pic)/256;
pic_gray=rgb2gray(pic);
tic;
%figure,imshow(pic);
%%%%%%%%%%%%%%%%%%%%%%%%Using GCP
pic_i=1-pic;%figure,imshow(pic1) 
gamma=0.5;
pic_v(:,:,1)=1-(pic_i(:,:,1)).^gamma;%(g1.^exp(pic(:,:,1)));%histeq(pic(:,:,1));
pic_v(:,:,2)=1-(pic_i(:,:,2)).^gamma;%(g1.^exp(pic(:,:,1)));%histeq(pic(:,:,2));
pic_v(:,:,3)=1-(pic_i(:,:,3)).^gamma;%(g1.^exp(pic(:,:,1)));%
%%%%%%%%%%%%%%%%%%%%%%%%Scene depth 
method = 'he'; 
A_channel_o= Airlight(pic,method,15);%Here we use BCCR or DCP method to estimate the atmospheric light as an example, due to its available.
A_channel_s= Airlight(pic_v,method,15);
A_o=A_channel_o(3);
A_s=A_channel_s(3);
eps=0.00001;
F1=max(A_o-pic(:,:,3),eps);
F2=max(A_s-pic_v(:,:,3),eps);
F3=A_s/A_o;
D__=-log(F1./F2)-log(F3);
% figure,imshow(D__)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find constant¦È.%It depends on the standard you select, you can use the Eq. 17 to determine it. 
ST=2.4; %Example1
% ST=2.7; %Example2
% ST=4.7; %Example3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t=max(exp(-1.*ST.*D__),0.1);
J(:,:,1)=(pic(:,:,1)-A_channel_o(1))./(A_channel_o(1).*t)+1;
J(:,:,2)=(pic(:,:,2)-A_channel_o(2))./(A_channel_o(2).*t)+1;
J(:,:,3)=(pic(:,:,3)-A_channel_o(3))./(A_channel_o(3).*t)+1;
toc
%figure,imshow(1.0*J)
%Save Image
    savepath = strcat(OutputPath,imgname, '.png');
    imwrite(1.0*J,savepath);
end
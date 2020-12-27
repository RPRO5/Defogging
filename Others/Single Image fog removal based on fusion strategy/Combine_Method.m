function Combine_Method()
% Input Options
%ext           = '.jpg';
%filenames     = {'pumpkins'};
% 'canon' 'city_1' 'city_2' 'cones' 'lake' 'mountain' 'ny_1' 'ny_2' 'pumpkins' 'stadium' 'toys' 'trees'};
%scalingFactor = 0.5;

%numFiles = size(filenames, 2);
%for fileIndex = 1:numFiles
%    Get Filename
 %   filename = char(filenames(fileIndex));
  %  disp(strcat('Processing: ', filename));
    
%    Read Image
    %imageRGB = imresize(readIm(filename, ext), scalingFactor);
   % imageRGB = readIm(filename, ext);
 % clear all;clc;
trainData = imageSet('./time','recursive');
patchSize = 15;     %the patch size is set to be 15 x 15
padSize =  floor((patchSize-1)/2);
newSize = 500; %Size of the image
intialRegions = 5; %number of regions for segmentation
OutputPath = './Results/11/'; % Path for saving output images

for count = 1:trainData.Count
    
     img = read(trainData, count);
    imgpath = char(trainData.ImageLocation(count));
    [~,imgname,~] = fileparts(imgpath) ;
    %filename=imgname;
    %Pre-Processing
    %img = imresize(img, [newSize,newSize]);

    [r,c,di]=size(img);
    I=zeros(r,c);
    %imwrite(imageRGB, fullfile('Results', strcat(filename, ext)));
     tic;
    res2=run_examples(img);
    %imageRGB = imresize(res2, scalingFactor);
    %imwrite(res2, fullfile('Results/Veil-Teral', strcat(filename, '_veil', ext)));
    %figure;imshow(res2);title('Veil Method');

    refinedRadiance=AirLight_Method(img,imgname);
    %imwrite(refinedRadiance, fullfile('Results/Airlight', strcat(filename, '_air', ext)));
    %figure;imshow(refinedRadiance);title('Airlight Method');
    mes=0;
        for i=1:r
            for j=1:c
                for d=1:di
                 I(i,j,d)=(2*res2(i,j,d)+refinedRadiance(i,j,d))/3;
                end
                %Means Square Error
               % mes=mes+(1/(r*c)*(imageRGB(i,j)-I(i,j))*(imageRGB(i,j)-I(i,j)));
               
                
            end
        end
     %save(['Results/MSE/' filename '.txt'],'mes','-ASCII');
     %imwrite(I, fullfile('Results/Combine', strcat(filename, '_combine', ext)));
     %figure;imshow(I);title('Combine Method');
     toc
    %Save Image
    savepath = strcat(OutputPath,imgname, '.png');
    imwrite(I,savepath);
end
end
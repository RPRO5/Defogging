function refinedRadiance=AirLight_Method(imageRGB,filename) 
% % Input Options
    ext           = '.jpg';


imageRGB=double(imageRGB);
imageRGB=imageRGB./255;
     % 3.0 Dark Channel Prior
     dark = darkChannel(imageRGB);
    % imwrite(dark, fullfile('Results/Dark_Chennel', strcat(filename, '_dark', ext)));
 
     % 4.4 Estimating the Atmospheric Light
     atmospheric = atmLight(imageRGB, dark);


     % 4.1 Estimating the Transmission
     transmission = transmissionEstimate(imageRGB, atmospheric);
     %imwrite(transmission, fullfile('Results/Transmission', strcat(filename, '_trans', ext)));


     %4.3 Recovering the Scene Radiance
      radiance = getRadiance(atmospheric, imageRGB, transmission);
     %imwrite(radiance, fullfile('Results', strcat(imageRGB, '_rad', ext)));

    
     %4.2 Apply Soft Matting
     %refinedTransmission = matte(imageRGB, transmission);
     %imwrite(refinedTransmission, fullfile('Results', strcat(filename, '_reftrans', ext)));
    
    
     

     K = wiener2(transmission,[5 5]);
     %K =imguidedfilter(transmission);
     %imwrite(K, fullfile('Results/Refined_Transmission', strcat(filename, '_win', ext)));
  	
     %Colour correction
	 %refinedTransmission=color_correction(radiance);
	 %C=laplacian_Filter(radiance);
     %B =imguidedfilter(radiance);
     %[J,noise] = wiener2(radiance,[15 15]);

     % 4.3 Recovering the Scene Radiance
     refinedRadiance = getRadiance(atmospheric, imageRGB, K);
     %imwrite(refinedRadiance, fullfile('Results', strcat(imageRGB, '_refrad', ext)));







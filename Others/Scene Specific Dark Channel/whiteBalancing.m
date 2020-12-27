function whiteBalanced = whiteBalancing(Jw)
 	R_avg = mean(mean(Jw(:,:,1)));           % Getting the average Of R ,G, B components
 	G_avg = mean(mean(Jw(:,:,2)));
 	B_avg = mean(mean(Jw(:,:,3)));
 	RGB_avg = [R_avg G_avg B_avg];
 	gray_value = (R_avg + G_avg + B_avg)/3;  % By Grey world, avg color of the whole image is gray
 	scaleValue = gray_value./RGB_avg;       % By Grey world, scale value=gray / avg of each color component
 	 whiteBalanced(:,:,1) = scaleValue(1) * Jw(:,:,1);   % R,G,B components of the new white balanced new image
 	whiteBalanced(:,:,2) = scaleValue(2) * Jw(:,:,2);
 	whiteBalanced(:,:,3) = scaleValue(3) * Jw(:,:,3);
end
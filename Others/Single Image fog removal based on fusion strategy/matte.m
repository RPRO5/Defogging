function [ refinedTransmission ] = matte( imageRGB, transmission )

epsilon = 10^-8;
lambda  = 10^-4;

windowSize      = [3 3];    
numWindowPixels = windowSize(1) * windowSize(2);   % 9

imageSize          = size(imageRGB);               % 263   300     3
numImagePixels     = imageSize(1) * imageSize(2);  % 78900
numImageDimensions = imageSize(3);                 % 3

mattingLaplacian = sparse(numImagePixels, numImagePixels);  % All zero sparse: 78900-by-78900
for imageRow = 2:imageSize(1)-1
    for imageCol = 2:imageSize(2)-1
        windowIndices = [imageRow-1 imageCol-1 imageRow+1 imageCol+1];  %1     1     3     3
        
        window     = imageRGB(windowIndices(1):windowIndices(3), windowIndices(2):windowIndices(4), :);
        
%               window
% 
%             window(:,:,1) =
% 
%                 0.7265    0.7231    0.7180
%                 0.7190    0.7085    0.7055
%                 0.7187    0.7095    0.7086
% 
% 
%             window(:,:,2) =
% 
%                 0.7272    0.7225    0.7193
%                 0.7151    0.7048    0.7060
%                 0.7194    0.7092    0.7074
% 
% 
%             window(:,:,3) =
% 
%                 0.7353    0.7289    0.7263
%                 0.7248    0.7144    0.7171
%                 0.7274    0.7170    0.7188


        
        windowFlat = reshape(window, numWindowPixels, numImageDimensions);
        
        %windowFlat =

        %0.7265    0.7272    0.7353
        %0.7190    0.7151    0.7248
        %0.7187    0.7194    0.7274
        %0.7231    0.7225    0.7289
        %0.7085    0.7048    0.7144
        %0.7095    0.7092    0.7170
        %0.7180    0.7193    0.7263
        %0.7055    0.7060    0.7171
        %0.7086    0.7074    0.7188
        

        windowMean       = transpose(mean(windowFlat));
            %windowMean =

            %0.7153
            %0.7145
            %0.7233
        
        windowCovariance = cov(windowFlat, 1);
        
       % windowCovariance =

        %1.0e-04 *

        %0.4886    0.5148    0.4377
        %0.5148    0.5733    0.4856
        %0.4377    0.4856    0.4244
        
        windowInvNumPixels          = 1 / numWindowPixels;
        
        %windowInvNumPixels =
        % 0.1111
        
        windowInvCovarianceIdentity = windowCovariance + (epsilon / numWindowPixels) * speye(numImageDimensions);
       % windowInvCovarianceIdentity =

       % 1.0e-04 *

       %0.4886    0.5148    0.4377
       %0.5148    0.5733    0.4856
       %0.4377    0.4856    0.4244
        
        for firstRow = windowIndices(1):windowIndices(3)       
            for firstCol = windowIndices(2):windowIndices(4)    
                mattingLaplacianRow = ((firstRow - 1) * imageSize(2)) + firstCol;  %1
                
                for secondRow = windowIndices(1):windowIndices(3)  
                    %if secondRow < firstRow
                    %    continue
                    %end
                    
                    for secondCol = windowIndices(2):windowIndices(4)   
                        %if secondCol < firstCol
                        %    continue
                        %end
                        
                        mattingLaplacianCol = ((secondRow - 1) * imageSize(2)) + secondCol; %mattingLaplacianCol=1
                        
                        if (mattingLaplacianRow == mattingLaplacianCol)
                            kroneckerDelta = 1;
                        else
                            kroneckerDelta = 0;
                        end
                        
                        rowPixelVariance = reshape(imageRGB(firstRow,  firstCol,  :), numImageDimensions, 1) - windowMean;
                        
                        %rowPixelVariance =

                         %0.0112
                         %0.0126
                         %0.0120
                         
                        colPixelVariance = reshape(imageRGB(secondRow, secondCol, :), numImageDimensions, 1) - windowMean;
                        %colPixelVariance =

                                %0.0112
                                %0.0126
                                %0.0120
                        
                        mattingLaplacian(mattingLaplacianRow, mattingLaplacianCol) = mattingLaplacian(mattingLaplacianRow, mattingLaplacianCol) + (kroneckerDelta - windowInvNumPixels * (1 + transpose(rowPixelVariance) / windowInvCovarianceIdentity * colPixelVariance));
                        
                           % mattingLaplacian(mattingLaplacianRow, mattingLaplacianCol)

                           % ans =

                           % (1,1)       0.4360
                        
                        %if kroneckerDelta == 0
                        %    mattingLaplacian(mattingLaplacianCol, mattingLaplacianRow) = mattingLaplacian(mattingLaplacianCol, mattingLaplacianRow) + (kroneckerDelta - windowInvNumPixels * (1 + transpose(colPixelVariance) / windowInvCovarianceIdentity * rowPixelVariance));
                        %end
                    end
                end
            end
        end
    end
end

transmissionFlat = reshape(transpose(transmission), numImagePixels, 1);

refinedTransmissionFlat = (mattingLaplacian + (lambda * speye(numImagePixels)))\(lambda * transmissionFlat);

refinedTransmission = transpose(reshape(refinedTransmissionFlat, imageSize(2), imageSize(1)));

end


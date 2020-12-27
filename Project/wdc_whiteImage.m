%% white balance based on Retinex theory
% I, input image
% I, output image, balanced
function [ Iw ] = wdc_whiteImage( I, A )

    [~,~,c] = size(I);
    if c==3
        Iw(:,:,1) = I(:,:,1) ./ A(1);
        Iw(:,:,2) = I(:,:,2) ./ A(2);
        Iw(:,:,3) = I(:,:,3) ./ A(3);
    else
        Iw = I./A;
    end
end


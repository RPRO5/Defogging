function [L,N,avgInten] = superPixelSegment(darkimg, regions)
[L,N] = superpixels(darkimg,regions, 'Compactness',0.1);
avgInten = zeros(1,N);

    for i=1:N
        avgInten(1,i) = mean(darkimg(L==i));
    end


end


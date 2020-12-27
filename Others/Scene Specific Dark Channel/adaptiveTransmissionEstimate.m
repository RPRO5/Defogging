function transmission = adaptiveTransmissionEstimate(im, A, L, N, avgInten)

omega = 0.95; % the amount of haze we're keeping

im3 = zeros(size(im));
for ind = 1:3 
    im3(:,:,ind) = im(:,:,ind)./A(ind);
end

% imagesc(im3./(max(max(max(im3))))); colormap gray; axis off image
% imshow(im3)
im3 = im3.*255;
[~,Adaptivedark] = AdaptivedarkChannel(im3, L, N, avgInten);
Adaptivedark = double(Adaptivedark);
Adaptivedark = Adaptivedark./255;
% darkchannel = darkChannel(im3,15);

AdaptiveOmega = zeros(size(Adaptivedark,1),size(Adaptivedark,2));
for k=1:N
    if(avgInten(k)>=230)
        omega = 0.95;
    elseif(avgInten(k)>=140)
        omega = 0.9;
    elseif(avgInten(k)>=100)
        omega = 0.8;
    elseif(avgInten(k)>=80)
        omega = 0.7;
    else
        omega = 0.6;
    end
    S=(L==k);
    AdaptiveOmega(S) = omega;
end


transmission = 1-AdaptiveOmega.*Adaptivedark;

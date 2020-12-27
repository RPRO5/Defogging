function [JDarks,Adaptivedark] = AdaptivedarkChannel(im2, L, N, avgIntern)

[height, width, ~] = size(im2);

JDarks = zeros(height, width, N); % the dark channel

for k=1:N
    if(avgIntern(k)>=240)
        patchSize = 21;
    elseif(avgIntern(k)>=140)
        patchSize = 15;
    elseif(avgIntern(k)>=90)
        patchSize = 11;
    else
        patchSize = 5;
    end
    padSize = floor((patchSize-1)/2);
  
    imJ = padarray(im2, [padSize padSize], Inf);
   
    JDark = zeros(height, width);
    for j = 1:height
        for i = 1:width
            % the patch has top left corner at (jj, ii)
            patch = imJ(j:(j+patchSize-1), i:(i+patchSize-1),:);
           % patch1 = imJ1(j:(j+patchSize-1), i:(i+patchSize-1),:);
            % the dark channel for a patch is the minimum value for all
            % channels for that patch
     %
            JDark(j,i) = min(patch(:));
          %  
        end
    end
    JDarks(:,:,k) = JDark;
end

Adaptivedark = zeros(height, width);

for k=1:N
    S=(L==k);
    Darktemp = JDarks(:,:,k);
    Adaptivedark(S) = Darktemp(S);
end



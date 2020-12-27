function img1=gamma0(img)
for i=0:255;
    f=power((i+0.5)/256,1/1.2);
    LUT(i+1)=uint8(f*256-0.5);
end  
%img=imread('_y01_photo.png');
img0=rgb2ycbcr(img);
R=img(:,:,1);
G=img(:,:,2);
B=img(:,:,3);
Y=img0(:,:,1);
Yu=img0(:,:,1);
[x y]=size(Y);
for row=1:x
    for width=1:y
        for i=0:255
        if (Y(row,width)==i)
             Y(row,width)=LUT(i+1);
             break; 
        end
        end
    end
end
img0(:,:,1)=Y;
img1=ycbcr2rgb(img0);


end





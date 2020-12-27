function [A]=sky_decte2(I)
[h,w,l]=size(I);
beishu=300/h;
if max(w,h)>300
    img = imresize(I, beishu, 'nearest');
else
    img=I;
end
[h,w,l]=size(img);
edge=edgecolor(rgb2gray(uint8(img)));

window=ones(floor(20/beishu));
edge=double(edge);
[is_sky]=conv2(edge,window,'same');

is_sky=1-is_sky;
bw2=im2bw(is_sky);

B=regionprops(bw2,'all');
if length(B)==0
    fig=0;
else
    centr=[B.Centroid];
    yPixel=reshape(centr,2,round(size(centr,2)/2))';
    idx = find([B.Area] >50 & [(yPixel(:,2))<h/3]');
    fig=size(idx,2);
    areas=0;
    for k=1:length(idx)
        areas=areas+length(B(idx(k)).Area);
    end
end
if(fig==0)
    A(1)=max(max(img(:,:,1)));
    A(2)=max(max(img(:,:,2)));
    A(3)=max(max(img(:,:,3)));
else
    img=double(img);
    skkk=[];
    for ff=1:fig
        skkk=[skkk;B(idx(ff)).PixelList];
    end
    xx=skkk(:,2);
    yy=skkk(:,1);
    len=length(skkk);
    sky_bright=zeros(len,3);
    imgR=img(:,:,1);
    imgG=img(:,:,2);
    imgB=img(:,:,3);
    sky_bright(:,1)=imgR((xx-1)*w+yy);
    sky_bright(:,2)=imgG((xx-1)*w+yy);
    sky_bright(:,3)=imgB((xx-1)*w+yy);
    sky_bright(:,4)=sky_bright(:,1)+sky_bright(:,2)+sky_bright(:,3);
    sumsky_bright=-sortrows(-sky_bright,4);
    index= round(len*0.01/2)+3;
    A(1)=sumsky_bright(index,1);
    A(2)=sumsky_bright(index,2);
    A(3)=sumsky_bright(index,3);
    
end
end

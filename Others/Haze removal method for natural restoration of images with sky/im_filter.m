function [out_img]=im_filter(in_img,window)
[h,w,r]=size(in_img);
[l,t]=size(window);
% if((l~=t)||(mod(l,2)~=1))
%     error('filter not corrected');
% end

out_img=ones(h,w);
for k=1:r
    T=in_img(:,:,r);
    T=[zeros(fix(t/2),w);T;zeros(fix(t/2),w)];
    T=[zeros(h+2*fix(t/2),fix(t/2)) T zeros(h+2*fix(t/2),fix(t/2))];
    for j=1:floor(h*2/3)
        for i=1:w
            out_img(j,i,r)=sum(sum(T(j:j+l-1,i:i+t-1).*window));
           
          if out_img(j,i,r)<10
                out_img(j,i,r)=0;
          else
               out_img(j,i,r)=1;
          end
          
        end
    end
end
end
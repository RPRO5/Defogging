function [req_img,Yvp]= VO(type,temp_fin,image_name)
    [rows,columns]=size(temp_fin);
    Yvp=0;
    if type==0
        y=zeros(rows,1);
        for i=1:columns
           temp=find(temp_fin(:,i)==200|temp_fin(:,i)==255);
           if(isempty(temp))
            y(i)=rows-1;
           else
               y(i)=temp(1);
           end
        end
        Yvp=max(y);
        Xvp=round(columns/2);
        Yvp=round(Yvp);
        req_img=zeros(rows,columns);
        intensity=1;
        offset=(1-200/255)/(rows-Yvp);
        i=rows;
        while i>Yvp && i>1
            req_img(i,:)=intensity;
            intensity=intensity-offset;
            i=i-1;
        end
        req_img(1:Yvp,:) = 60/255;
    else
        req_img=geometric_depthMap(type,image_name);
    end
end
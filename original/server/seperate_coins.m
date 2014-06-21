function region_s = seperate_coins(region,iterator)

for i=1:length(iterator)
    [w,h]=size(region);
    temp=region*0;
    temp((region==iterator(i)))=1;
    temp_s=temp(1:8:end,1:8:end);
    SE=strel('disk',12);
    temp_s=imfill(temp_s,'holes');
    temp_s=imerode(temp_s,SE);
    temp_s_l=bwlabel(temp_s);
    SE=strel('disk',10);
    temp_s_l=imdilate(temp_s_l,SE);
    temp_s_l(temp_s_l>0)=temp_s_l(temp_s_l>0)+iterator(i)-1;
    for j=1:w/8
        for k=1:h/8
            temp(j*8-7:j*8,k*8-7:k*8)=temp_s_l(j,k);
        end
    end
    region(region==iterator(i))=0;
    region(region>iterator(i))=region(region>iterator(i))+iterator(i);
    region=region+temp;
end
        region_s=region;
end
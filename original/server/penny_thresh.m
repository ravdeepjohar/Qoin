function [newpennys numpennys]  = penny_thresh(img,Area_thresh)
hsvimg = rgb2hsv(img);
simg = hsvimg(:,:,2);
vimg = hsvimg(:,:,3);
penny_mask = (simg < 0.25);
pennylabeled = bwlabel(imfill(logical(penny_mask),'holes')); 
pennyreg = regionprops(pennylabeled);
newpennys = zeros(size(img(:,:,1))); 
numpennys = 0;
for j = 1:length(pennyreg), 
    if (pennyreg(j).Area >Area_thresh), 
        numpennys = numpennys + 1;
        newpennys(find(pennylabeled == j)) = 1;
    end, 
end
function [radius img_thresholded_labeled img_rad_labeled] = get_radii(img_thresholded_labeled, values, max_rad)
img_rad_binary = imclose((values>100),strel('disk',25));
img_rad = max_rad.*img_rad_binary;
img_rad_labeled = bwlabel(img_rad_binary);
img_rad_reg = regionprops(img_rad_labeled);
iterator = zeros(1,length(img_rad_reg));
 for j = 1: length(img_rad_reg), 
     ind = find(img_rad_labeled == j);
     if (img_rad_reg(j).Area>100),
         iterator(j) = 1;
         reg_values = values(ind);
         reg_maxrad = img_rad(ind);
         [reg_values_sorted sorted_indices] = sort(reg_values);
         radius(j) = mean(reg_maxrad(sorted_indices(end-round(length(sorted_indices)/50):end)))
         j,
         imshow(img_rad_labeled == j), 
     else
         img_rad_labeled(ind) = 0;
     end
 end
 
 
for j = 1:max(max(img_thresholded_labeled))
    region = img_thresholded_labeled == j;
    if(sum(sum(region.*img_rad_labeled))==0)
        img_thresholded_labeled(region) = 0;
    end
end
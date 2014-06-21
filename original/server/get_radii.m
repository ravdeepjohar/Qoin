function [radii img_thresholded_labeled iterator] = get_radii(values, max_rad)

% If value of Hough transform exceeds some threshold assign radius to that
% point
img_rad_binary = imclose((values>100),strel('disk',25));
img_rad = max_rad.*img_rad_binary;
img_rad_labeled = bwlabel(img_rad_binary);
img_rad_reg = regionprops(img_rad_labeled,'Centroid','Area');

% For each region with area above a threshold find radius corresponding to
% thtat region
iterator = zeros(1,length(img_rad_reg));
radii = zeros(1,length(img_rad_reg));
for j = 1: length(img_rad_reg),
    ind = find(img_rad_labeled == j);
    if (img_rad_reg(j).Area>100),
        iterator(j) = 1;
        reg_values = values(ind);
        reg_maxrad = img_rad(ind);
        [reg_values_sorted sorted_indices] = sort(reg_values);
        radii(j) = mean(reg_maxrad(sorted_indices(end-round(length(sorted_indices)/50):end)));
    else
        img_rad_labeled(ind) = 0;
    end
end
% imshow(img_rad_labeled>0)
iterator = find(iterator);
radii = radii(find(radii));

% Reconstruct thresholded labeled image by plotting circles with determined
% radii centered at centroid of respective region (clutter will be removed)
img_thresholded_labeled = zeros(size(values));
for j = 1:length(iterator)
    reg = iterator(j);
    centr = img_rad_reg(reg).Centroid;
    rad = .9*radii(j);
    for x = -rad:rad
        for y = -sqrt(rad*rad-x*x):sqrt(rad*rad-x*x)
            img_thresholded_labeled(round(centr(2)+y),round(centr(1)+x)) = reg;
        end
    end
end

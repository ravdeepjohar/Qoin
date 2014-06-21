function [radii img_thresholded_labeled iterator] = get_radii(values, max_rad)

% Determines radius of each coin and produces thresholded and labeled image
% with only regions corresponding to coins (no clutter or overlapping)

% INPUTS:

% values - maximum value at each pixel of Hough transform across all radii

% max_rad - radius at each pixel corressponding to maximum value of Hough
% transform

% OUTPUTS:

% radii - array of radius of each region in thresholded and labeled image

% img_thresholded_labeled - thresholded and labeled image where each region
% corresponds to a coin

% iterator - array of labels corresponding to regions in thresholded and
% labeled image

% If value of Hough transform exceeds some threshold assign radius to that
% pixel, otherwise pixel remains 0. Then collect pixels into regions.
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
figure
imshow(img_rad_labeled>0)
title('Radius Image')
pause
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
figure,
imshow(img_thresholded_labeled)
title('New Thresholded Image (Without Clutter or Overlapping)')
pause

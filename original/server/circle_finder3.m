clear all, close all, clc
img = imread('coins100.jpg');
coin_types = {'penny' 'nickel' 'dime' 'quarter'};
absolute_diam = [.750 .835 .705 .955];
hsv_img = rgb2hsv(img);
hue_img = hsv_img(:,:,1);
sat_img = hsv_img(:,:,2);

% Determine upper and lower thresholds for background
img_thresholded = apply_threshold(img);

[values max_rad] = get_radius_w_hough(edge(double(img_thresholded)),150:5:320);
[radii img_thresholded_labeled iterator] = get_radii(values, max_rad);

% Reverse effects of closing operation possibly including some of
% background
% g = 0.05;
% img_binary = img_binary .* ((himg>(upper_thresh*(1-g))) + (himg<((1+g)*lower_thresh)));

% img_labeled = bwlabel(img_binary);
% img_reg = regionprops(img_labeled,'Area','Eccentricity');

% Reverse effects of closing operation possibly including some of
% background
% g = 0;
% img_labeled = img_labeled .* ((himg>(upper_thresh*(1-g))) + (himg<((1+g)*lower_thresh)));

% iterator = find_coins(img_reg);
penny_logical = find_pennies(hue_img,sat_img,img_thresholded_labeled,iterator);
% coin_id = find_sift_matches(img,img_labeled,iterator)
% penny_iterator = iterator(penny_logical);
num_pennies = sum(penny_logical);
penny_radius = mean(radii(penny_logical));
% penny_diam = mean(est_diam(:,penny_logical),2);
% if (num_pennies > 0 & accuracy1>.8)
non_penny_radii = radii(:,~penny_logical);
non_penny_iterator = iterator(~penny_logical);
[nq_iterator dime_radius nq_radii num_dimes dime_logical] = find_dimes(non_penny_radii,penny_radius,non_penny_iterator); 
% [penny_diam num_pennies] = find_penny_diam(penny_iterator,img_labeled);
coin_radii = 0.5*((penny_radius*absolute_diam/absolute_diam(1)) + (dime_radius*absolute_diam/absolute_diam(2)));
nq_coin_radii = coin_radii([2 4]);
[num_nickels nickel_logical num_quarters quarter_logical] = identify_nq(nq_coin_radii,nq_radii);
dollar_value = [.01 .05 .1 .25]*[num_pennies num_nickels num_dimes num_quarters]'

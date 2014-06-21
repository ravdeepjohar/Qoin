function [dollar_value coin_counts] = coin_counter(img)
coin_types = {'penny' 'nickel' 'dime' 'quarter'};
absolute_diam = [.750 .835 .705 .955];
hsv_img = rgb2hsv(img);
hue_img = hsv_img(:,:,1);
sat_img = hsv_img(:,:,2);

% Create thresholded image, label, and get region properties
img_thresholded = apply_threshold(img,hue_img,sat_img);
img_t_label = bwlabel(img_thresholded);
img_t_reg = regionprops(img_t_label,'MajorAxisLength','Area');

% Determine range of radii to sweep
max_MA = 0;
min_MA = inf;
for j = 1:length(img_t_reg)
    if((img_t_reg(j).Area>5000) && ((abs(img_t_reg(j).Area - pi*(img_t_reg(j).MajorAxisLength/2)^2)/img_t_reg(j).Area)<.25) )
        max_MA = round(max(max_MA,img_t_reg(j).MajorAxisLength));
        min_MA = round(min(min_MA,img_t_reg(j).MajorAxisLength));
    end
end

% Use Hough transform to get radius of each coin
[values max_rad] = get_radius_w_hough(edge(double(img_thresholded)),round(0.9*(min_MA/2)):5:round(1.1*(max_MA/2)));
[radii img_thresholded_labeled iterator] = get_radii(values, max_rad);

% Use color of pennies to identify them
[penny_logical num_pennies] = find_pennies(hue_img,sat_img,img_thresholded_labeled,iterator);
if(num_pennies == 0)
    % If no pennies exist use sift to identify one coin and use this as
    % reference to determine coin radius scaling (from absolute dimensions to
    % pixels)
    [best_match_coin_id best_match_label] = find_sift_matches(img,img_thresholded_labeled,iterator);
    penny_radius = radii(find(iterator == best_match_label))*absolute_diam(1)/absolute_diam(best_match_coin_id);
else
    % If pennies exist use penny radius to determine coin radius scaling (from
    % absolute dimensions to pixels)
    penny_radius = mean(radii(penny_logical));
end

% Determine number of dimes and dime radius
non_penny_radii = radii(~penny_logical);
non_penny_iterator = iterator(~penny_logical);
[nq_iterator dime_radius nq_radii num_dimes dime_logical] = find_dimes(non_penny_radii,penny_radius,non_penny_iterator); 
if num_dimes == 0,
    dime_radius = penny_radius*absolute_diam(3)/absolute_diam(1);
end

% Use penny and dime radii to estimate radii in pixels of each coin type
coin_radii = 0.5*((penny_radius*absolute_diam/absolute_diam(1)) + (dime_radius*absolute_diam/absolute_diam(3)));
nq_coin_radii = coin_radii([2 4]); %estimated nickel and quarter radii

% Determine number of nickels and quarters
[num_nickels nickel_logical num_quarters quarter_logical] = identify_nq(nq_coin_radii,nq_radii);

% Final result
coin_counts = [num_pennies num_nickels num_dimes num_quarters];
dollar_value = [.01 .05 .1 .25]*[num_pennies num_nickels num_dimes num_quarters]'

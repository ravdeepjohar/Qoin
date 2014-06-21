function img_thresholded = apply_threshold(hue_img,sat_img)

% Separates foreground from background using hue and saturation values.
% Thresholded image could possibly include overlapping or clutter.

% INPUTS:

% hue_img - image with hue values (first component of hsv image)

% sat_img - image with saturation values (second component of hsv image)

% OUTPUTS:

% img_thresholed - binary image with coins (and possibly clutter) in the
% foreground

% Determine hue of background
[counts x] = imhist(hue_img);
hue_peak = x(find(counts == max(counts),1));

% Apply saturation thresholding
sat_thresh = graythresh(sat_img);

% Determine threshold factor a value that rates likelihood of being in the
% background
thresh_factor = sat_img-sat_thresh-abs(hue_img-hue_peak);
thresh_factor = thresh_factor-min(min(thresh_factor));
thresh_factor = thresh_factor / max(max(thresh_factor));

% Create binary image and remove irregularities with closing, filling, and
% area thresholding
img_thresholded = thresh_factor<graythresh(thresh_factor);
img_thresholded = imclose(img_thresholded,strel('disk',5));
img_thresholded = imfill(img_thresholded,'holes');
img_thresholded = bwareaopen(img_thresholded,1000);



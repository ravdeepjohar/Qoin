function [values max_rad] = get_radius_w_hough(img,rad_range)

% At each pixel, determines most likely radius of the circle, if any, centered at that pixel 

% INPUTS:

% img - edge detected thresholded image

% rad_range - array of radii to sweep over

% OUTPUTS:

% values - maximum value of Hough transform at each pixel across all radii

% max_rad - radius at each pixel corresponding to the maximum value of
% Hough transform

values = zeros(size(img,1),size(img,2));
max_rad = rad_range(1)*ones(size(img));

for k = 1:length(rad_range)
    rad = rad_range(k);
    transform = houghcircle(img,rad);
    values_new = max(values,transform);
    max_rad(values_new ~= values) = rad;
    values = values_new;
end

        

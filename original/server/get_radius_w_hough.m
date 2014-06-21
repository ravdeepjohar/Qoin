function [values max_rad] = get_radius_w_hough(img,rad_range)
values = zeros(size(img,1),size(img,2));
max_rad = rad_range(1)*ones(size(img));

for k = 1:length(rad_range)
    rad = rad_range(k);
    transform = houghcircle(img,rad);
    values_new = max(values,transform);
    max_rad(values_new ~= values) = rad;
    values = values_new;
end

        

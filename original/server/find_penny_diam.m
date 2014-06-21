function [penny_diam num_pennies] = find_penny_diam(iterator,img_labeled)
penny_diam = zeros(2,1);
num_pennies = length(iterator);
for j = iterator
    [y_ind x_ind] = find(img_labeled == j);
    penny_diam = penny_diam + [max(x_ind)-min(x_ind);max(y_ind)-min(y_ind)];
end
penny_diam = penny_diam/num_pennies;

function [penny_diam_x penny_diam_y] = find_penny_rad(iterator,img_labeled,penny_logical)
iterator = iterator((iterator.*penny_logical)>0);
penny_diam_x = 0;
penny_diam_y = 0;
num_coins = length(iterator);
for j = iterator
    [y_ind x_ind] = find(img_labeled == j);
    penny_diam_x = penny_diam_x + max(x_ind)-min(x_ind);
    penny_diam_y = penny_diam_y + max(y_ind)-min(y_ind);
end
penny_diam_y = penny_diam_y/num_coins;
penny_diam_x = penny_diam_x/num_coins;
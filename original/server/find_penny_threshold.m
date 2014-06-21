function [penny_logical penny_threshold accuracy est_diam] = find_penny_threshold(iterator,sat_img,img_labeled)
num_coins = length(iterator);
mean_sat = zeros(1,num_coins);
est_diam =zeros(2,num_coins);
for j = 1:num_coins
    coin_img_bw = img_labeled == iterator(j);
    [y_ind x_ind] = find(coin_img_bw);
    est_diam(:,j) = [max(x_ind)-min(x_ind);max(y_ind)-min(y_ind)];
    current_img_sat = sat_img.*coin_img_bw;
    current_img_sat = current_img_sat((current_img_sat>0) & (current_img_sat ~= 1));
    mean_sat(j) = mean(current_img_sat);
end
[penny_threshold accuracy] = graythresh(mean_sat);
penny_logical = mean_sat>penny_threshold;
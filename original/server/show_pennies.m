penny_img= img_thresholded_labeled;
penny_ind = find(~penny_logical);
for j = 1:length(penny_ind), 
    reg = iterator(penny_ind(j)); 
    penny_img(penny_img == reg)=0;
end
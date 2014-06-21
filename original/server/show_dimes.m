dime_img= false(size(img_thresholded_labeled));
dime_ind = find(dime_logical);
for j = 1:length(dime_ind), 
    reg = non_penny_iterator(dime_ind(j)); 
    dime_img(img_thresholded_labeled == reg)=true;
end
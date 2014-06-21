quarter_img= false(size(img_thresholded_labeled));
quarter_ind = find(quarter_logical);
for j = 1:length(quarter_ind), 
    reg = nq_iterator(quarter_ind(j)); 
    quarter_img(img_thresholded_labeled == reg)=true;
end
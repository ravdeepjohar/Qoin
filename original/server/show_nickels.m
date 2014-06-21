nickel_img= false(size(img_thresholded_labeled));
nickel_ind = find(nickel_logical);
for j = 1:length(nickel_ind), 
    reg = nq_iterator(nickel_ind(j)); 
    nickel_img(img_thresholded_labeled == reg)=true;
end
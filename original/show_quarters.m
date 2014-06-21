% Displays an image showing only the quarters from the original image

quarter_img= false(size(img_thresholded_labeled));
quarter_ind = find(quarter_logical);
for j = 1:length(quarter_ind), 
    reg = nq_iterator(quarter_ind(j)); 
    quarter_img(img_thresholded_labeled == reg)=true;
end
figure,
quarter_img_col(:,:,1) = img(:,:,1).*uint8(quarter_img>0);
quarter_img_col(:,:,2) = img(:,:,2).*uint8(quarter_img>0);
quarter_img_col(:,:,3) = img(:,:,3).*uint8(quarter_img>0);
imshow(quarter_img_col),
title('Quarters')
pause
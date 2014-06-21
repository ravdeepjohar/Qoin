% Displays an image showing only the dimes from the original image

dime_img= false(size(img_thresholded_labeled));
dime_ind = find(dime_logical);
for j = 1:length(dime_ind), 
    reg = non_penny_iterator(dime_ind(j)); 
    dime_img(img_thresholded_labeled == reg)=true;
end
figure,
dime_img_col(:,:,1) = img(:,:,1).*uint8(dime_img>0);
dime_img_col(:,:,2) = img(:,:,2).*uint8(dime_img>0);
dime_img_col(:,:,3) = img(:,:,3).*uint8(dime_img>0);
imshow(dime_img_col),
title('Dimes')
pause
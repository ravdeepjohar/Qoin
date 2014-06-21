% Displays an image showing only the pennies from the original image

penny_img= img_thresholded_labeled;
penny_ind = find(~penny_logical);
for j = 1:length(penny_ind), 
    reg = iterator(penny_ind(j)); 
    penny_img(penny_img == reg)=0;
end
penny_img_col(:,:,1) = img(:,:,1).*uint8(penny_img>0);
penny_img_col(:,:,2) = img(:,:,2).*uint8(penny_img>0);
penny_img_col(:,:,3) = img(:,:,3).*uint8(penny_img>0);
figure,
imshow(penny_img_col),
title('Pennies')
pause
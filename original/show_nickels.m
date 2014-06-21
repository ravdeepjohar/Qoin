% Displays an image showing only the nickels from the original image

nickel_img= false(size(img_thresholded_labeled));
nickel_ind = find(nickel_logical);
for j = 1:length(nickel_ind), 
    reg = nq_iterator(nickel_ind(j)); 
    nickel_img(img_thresholded_labeled == reg)=true;
end
nickel_img_col(:,:,1) = img(:,:,1).*uint8(nickel_img>0);
nickel_img_col(:,:,2) = img(:,:,2).*uint8(nickel_img>0);
nickel_img_col(:,:,3) = img(:,:,3).*uint8(nickel_img>0);
figure,
imshow(nickel_img_col),
title('Nickels')
pause
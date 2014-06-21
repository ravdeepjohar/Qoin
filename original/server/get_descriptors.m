function [F D] = get_descriptors(img)
hsvimg = rgb2hsv(img);
himg = hsvimg(:,:,1);

% Determine upper and lower thresholds for background
[counts x] = imhist(himg);
start = find(counts == max(counts));
tmp = find(counts < max(counts)/50);
upper_thresh = x(min(tmp(find(tmp>start))))+.02;
lower_thresh = x(max(tmp(find(tmp<start))))-.02;
img_binary = (himg>upper_thresh) + (himg<lower_thresh);
img_binary = imclose(img_binary,strel('disk',10));
img_binary =imfill(img_binary,'holes');

% Reverse effects of closing operation possibly including some of
% background
% g = 0.05;
% img_binary = img_binary .* ((himg>(upper_thresh*(1-g))) + (himg<((1+g)*lower_thresh)));

img_labeled = bwlabel(img_binary);
img_reg = regionprops(img_labeled,'Area','Eccentricity');

% Reverse effects of closing operation possibly including some of
% background
% g = 0;
% img_labeled = img_labeled .* ((himg>(upper_thresh*(1-g))) + (himg<((1+g)*lower_thresh)));

label = find_coins(img_reg);
coin_image(:,:,1) = img(:,:,1).*uint8(img_labeled == label); 
coin_image(:,:,2) = img(:,:,2).*uint8(img_labeled == label);
coin_image(:,:,3) = img(:,:,3).*uint8(img_labeled == label);
[F,D] = VL_SIFT(single(rgb2gray(coin_image)));
if (size(D,2)>100)
    descriptor_norm = zeros(1,size(D,2));
    [tmp inds] = sort(descriptor_norm);
    D = D(:,inds((end-100):end));
    F = F(:,inds((end-100):end));
end
figure
imshow(coin_image)
hold on
plot(F(1,:),F(2,:),'yo')
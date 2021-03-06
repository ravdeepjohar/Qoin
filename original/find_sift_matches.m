function [best_match_coin_id best_match_label] = find_sift_matches(img,img_labeled,iterator)

% Determines identity of one coin in image using best match of descriptors
% of all coins in image with descriptors of all 8 template images (4 coin 
% types x 2 sides of coin)

% INPUTS:

% img - original rgb image

% img_labeled - labeled thresholded image

% iterator - array of labels of all regions in labeled thresholded image
% that are coins


% OUTPUTS:

% best_match_coin_id - identity of coin in image that provides the best 
% SIFT match with some template image ([1 2 3 4] <--> [penny nickel dime quarter])

% best_match_label - label of region in labeled thresholded image
% corresponding to the coin that proveds the best SIFT match with some
% template image

load descriptor_template %load descriptors of 8 template images with which to compare each coin 
num_coin_types = size(descriptor_template,2);
matches = zeros(1,num_coin_types);
max_matches=zeros(1,length(iterator));
coin_ids = zeros(length(iterator));
for j = 1:length(iterator)
    label = iterator(j);
    coin_image(:,:,1) = img(:,:,1).*uint8(img_labeled == label);
    coin_image(:,:,2) = img(:,:,2).*uint8(img_labeled == label);
    coin_image(:,:,3) = img(:,:,3).*uint8(img_labeled == label);
    [F,D] = VL_SIFT(single(rgb2gray(coin_image)));
    if (size(D,2)>100)
        descriptor_norm = zeros(1,size(D,2));
        [tmp inds] = sort(descriptor_norm);
        D = D(:,inds((end-100):end));
    end
    for coin = 1:num_coin_types
        descriptor = descriptor_template{coin};
        match = vl_ubcmatch(D, descriptor,4);
        matches(coin) = size(match,2);
    end
    max_matches(j) = max(matches);
    coin_ids(j) = ceil(find(matches == max(matches),1)/2);
end
index = find(max_matches == max(max_matches),1);
best_match_label = iterator(index);
best_match_coin_id = coin_ids(index);
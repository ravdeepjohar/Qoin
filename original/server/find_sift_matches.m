function [best_match_coin_id best_match_label] = find_sift_matches(img,img_labeled,iterator)
load descriptor_template
num_coin_types = size(descriptor_template,2);
matches = zeros(1,num_coin_types);
max_matches=zeros(1,length(iterator));
coin_ids = zeros(length(iterator));
for j = 1:length(iterator)
    label = iterator(j);
    coin_image(:,:,1) = img(:,:,1).*uint8(img_labeled == label);
    coin_image(:,:,2) = img(:,:,2).*uint8(img_labeled == label);
    coin_image(:,:,3) = img(:,:,3).*uint8(img_labeled == label);
%     imshow(coin_image)
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
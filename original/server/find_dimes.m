function [nq_iterator dime_radius nq_radii num_dimes dime_logical] = find_dimes(non_penny_radii,penny_radius,non_penny_iterator) 
dime_logical = false(1,length(non_penny_iterator));
num_dimes = 0;
for k = 1:length(non_penny_iterator)
    if (sum(non_penny_radii(k)-penny_radius) < 0)
        num_dimes = num_dimes + 1;
        dime_logical(k) = true;
    end
end
if (num_dimes > 0)
    dime_radius = mean(non_penny_radii(dime_logical));
else
    dime_radius = 0;
end
if (num_dimes < length(non_penny_radii))
    nq_iterator = non_penny_iterator(~dime_logical);
    nq_radii = non_penny_radii(:,~dime_logical);
else
    nq_iterator = [];
    nq_radii=[];
end
function [nq_iterator dime_radius nq_radii num_dimes dime_logical] = find_dimes(non_penny_radii,penny_radius,non_penny_iterator) 

% Finds dimes in images based on their radius being less than the radius of
% the penny

% INPUTS:

% non_penny_radii - array of radii of all coins that are not pennies

% penny_radius - radius of penny

% non_penny_iterator: array of labels of all regions that are nickels,
% dimes, or quarters


% OUTPUTS:

% nq_iterator - array of labels of all regions that are nickels or quarters

% dime_radius - radius of dime

% num_dimes - number of coins that are dimes

% dime_logical - logical array where index i is true if region with label
% equal to non_penny_iterator(i) is a dime

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
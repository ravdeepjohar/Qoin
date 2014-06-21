function iterator = find_coins(region)
iterator = 1:length(region);
for j = iterator
    if ((region(j).Area<10000) || (region(j).Eccentricity>0.6))
        iterator(j) = 0;
    end
end
iterator = iterator(iterator>0);
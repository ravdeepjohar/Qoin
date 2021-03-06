function [penny_logical num_pennies] = find_pennies(hue_img,sat_img,img_thresholded_labeled,iterator)
num_coins = length(iterator);
coin_hue = zeros(1,num_coins);
coin_sat = zeros(1,num_coins);

% Find threshold saturation and hue values that minimize mean square
% difference between values and threshold
hues = hue_img.*(img_thresholded_labeled>0);
hues = hues(hues>0);
sats = sat_img.*(img_thresholded_labeled>0);
sats = sats((sats>0) & (sats<1));
hue_thresh = determineThresh(hues);
sat_thresh = determineThresh(sats);

% Determine ranked hue and saturation value for each coin
for j = 1:num_coins
    reg = iterator(j);
    current_hue = hue_img.*(img_thresholded_labeled == reg);
    current_hue = current_hue(current_hue>0);
    hue_sorted = sort(current_hue);
    coin_hue(j) = hue_sorted(round(.75*length(hue_sorted)));
    current_sat = sat_img.*(img_thresholded_labeled == reg);
    current_sat = current_sat((current_sat>0) & (current_sat <1));
    sat_sorted = sort(current_sat);
    coin_sat(j) = sat_sorted(round(.25*length(sat_sorted)));
end

% Compute penny likelihood score
penny_score = coin_hue - hue_thresh + sat_thresh - coin_sat;

if (num_coins == 1)
    penny_logical = (coin_hue<.1) && (coin_sat>.5);
    num_pennies = sum(penny_logical);
else
    if ((min(coin_hue)>.25) || (max(coin_sat)<.3))
        %Determine if no pennies are present
        penny_logical = zeros(size(penny_score));
        num_pennies = 0;
    else
        if ((max(coin_hue)<.1) || (min(coin_sat)>.5))
            %Determine if all coins are pennies
            penny_logical = ones(size(penny_score));
            num_pennies = length(penny_logical);
        else

            penny_logical = penny_score<0;
            num_pennies = sum(penny_logical);
            penny_score_sorted  = sort(penny_score);

            % Compensate threshold computation so that equal numbers of pennies and
            % nonpennies are used
            if(num_pennies>.66*length(penny_logical))
                penny_logical = penny_score<determineThresh(penny_score_sorted((2*num_pennies-num_coins+1):end));
            end
            if(num_pennies<.33*length(penny_logical))
                penny_logical = penny_score<determineThresh(penny_score_sorted(1:(num_coins-2*num_pennies+1)));
            end
            num_pennies = sum(penny_logical);
        end
    end
end
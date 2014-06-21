function [num_nickels nickel_logical num_quarters quarter_logical] = identify_nq(nq_coin_radii,nq_radii)
% rad2thresh = nq_radii;
% max_diam_nq = max(nq_radii);
% min_diam_nq = min(nq_radii);
% if (max_diam_nq(1) < nq_coin_radii(2))
%     rad2thresh = [rad2thresh nq_coin_radii(2)];
% end
% % if (max_diam_nq(2) < nickel_quarter_diameters(2,2))
% %     y_diam2thresh = [y_diam2thresh nickel_quarter_diameters(2,2)];
% % end
% if (min_diam_nq(1) > nq_coin_radii(1))
%     rad2thresh = [rad2thresh nq_coin_radii(1)];
% end
% % if (min_diam_nq(2) > nickel_quarter_diameters(2,1))
% %     y_diam2thresh = [y_diam2thresh nickel_quarter_diameters(2,1)];
% % end
% radius_threshold = determineThresh(rad2thresh);
% quarter_logical = nq_radii>radius_threshold;
% num_quarters = sum(quarter_logical);
% nickel_logical = nq_radii<radius_threshold;
% num_nickels = sum(nickel_logical);

quarter_logical = abs(nq_radii-nq_coin_radii(2))<abs(nq_radii-nq_coin_radii(1))
nickel_logical = ~quarter_logical
num_quarters = sum(quarter_logical);
num_nickels = sum(nickel_logical);



% [y_thresh accuracy_y] = graythresh(y_diam2thresh/max_y);
% thresh = [max_x*x_thresh; max_y*y_thresh];
% accuracy = mean([accuracy_x accuracy_y]);
% num_nickels_and_quarters = length(nq_radii);
% num_quarters = sum(sum(est_diam_nq - repmat(thresh,1,num_nickels_and_quarters))>0);
% num_nickels = num_nickels_and_quarters-num_quarters;

% coin_count = zeros(1,3);
% for j = iterator
%     imshow(img_labeled == j);
%     [y_ind x_ind] = find(img_labeled == j);
%     coin_diams = [max(x_ind)-min(x_ind); max(y_ind)-min(y_ind)];
%     errors = sum((diameters-repmat(coin_diams,1,3)).^2);
%     coin_count = coin_count + (errors == min(errors));
%     errors_sorted = sort(errors);
%     uncertainty(j) = ((errors_sorted(2)-errors_sorted(1))/errors_sorted(1));
% end
% num_nickels = coin_count(1);
% num_dimes = coin_count(2);
% num_quarters = coin_count(3);
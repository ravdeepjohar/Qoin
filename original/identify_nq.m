function [num_nickels nickel_logical num_quarters quarter_logical] = identify_nq(nq_coin_radii,nq_radii)

% Identifies nickels and quarters based on difference between radius of each
% coin and estimated nickel and quarter radii

% INPUTS:

% nq_coin_radii - array of radii of all nickels and quarters in image

% nq_radii: array of estimated radii of nickels and quarters


% OUTPUTS:

% num_nickels = number of coins that are nickels

% nickel_logical - logical array where index i is true if region with label
% equal to nq_iterator(i) is a nickel

% num_quarters = number of coins that are quarters

% nickel_logical - logical array where index i is true if region with label
% equal to nq_iterator(i) is a quarter

quarter_logical = abs(nq_radii-nq_coin_radii(2))<abs(nq_radii-nq_coin_radii(1));
nickel_logical = ~quarter_logical;
num_quarters = sum(quarter_logical);
num_nickels = sum(nickel_logical);

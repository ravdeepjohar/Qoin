function [diameters_x diameters_y] = assign_diameters(penny_diam_x,penny_diam_y,absolute_diam);
diameters_x = (penny_diam_x/(absolute_diam(1)))*absolute_diam;
diameters_y = (penny_diam_y/(absolute_diam(1)))*absolute_diam;
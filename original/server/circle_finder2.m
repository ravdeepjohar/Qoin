clear all, close all, clc
img = imread('coins11.jpg');
hsvimg = rgb2hsv(img);
quarter_rad_x = (900-440)/2;
quarter_rad_y = (900-440)/2;
% ref_col = [.6694 .94 .88]';
% for j = 25:50,
%     for k = 75:(75+2*quarter_rad_x)
%         hsvimg(j,k,:) = ref_col;
%     end
% end
% for j = 75:(75+2*quarter_rad_y),
%     for k = 25:50
%         hsvimg(j,k,:) = ref_col;
%     end
% end
% imshow(hsv2rgb(hsvimg))
himg = hsvimg(:,:,1);
simg = hsvimg(:,:,2);
ref_mask = (himg>.5) .* (himg<.75);
ref_mask = bwareaopen(ref_mask,250);
ref_labeled = bwlabel(ref_mask);
ref_props = regionprops(ref_labeled,'Eccentricity','MajorAxisLength','MinorAxisLength');
% figure, imshow(ref_mask)
% for j = 1:length(ref_props)
%     if(ref_props(j).Eccentricity>.95)
%         [c d] = find(ref_labeled == j);
%         xlength = max(d)-min(d);
%         ylength = max(c)-min(c);
%         if (ylength/xlength > 5)
%             quarter_rad_y = ylength/2
%         end
%         if (xlength/ylength > 5)
%             quarter_rad_x = xlength/2
%         end
%     end
% end
dime_rad_x = round((.705/.955)*quarter_rad_x);
nickel_rad_x = round((.835/.955)*quarter_rad_x);
penny_rad_x = round((0.75/0.955)*quarter_rad_x);
dime_rad_y = round((.705/.955)*quarter_rad_y);
nickel_rad_y = round((.835/.955)*quarter_rad_y);
penny_rad_y = round((0.75/0.955)*quarter_rad_y);

% Determine upper and lower thresholds for background
[counts x] = imhist(himg);
start = find(counts == max(counts));
tmp = find(counts < max(counts)/50);
upper_thresh = x(min(tmp(find(tmp>start))))+.01;
lower_thresh = x(max(tmp(find(tmp<start))))-.01;
img_binary = (himg>upper_thresh) + (himg<lower_thresh);
img_binary = imclose(img_binary,strel('disk',round(quarter_rad_x/25)));
% img_binary =imfill(img_binary,'holes');

% Reverse effects of closing operation possibly including some of
% background
g = 0.05;
img_binary = img_binary .* ((himg>(upper_thresh*(1-g))) + (himg<((1+g)*lower_thresh)));

% Intialize counter 
numquarters = 0;
numnickels = 0;
numdimes = 0;
numpennys = 0;


img_labeled = bwlabel(img_binary);
img_reg = regionprops(img_labeled,'MajorAxisLength','Eccentricity');

% Reverse effects of closing operation possibly including some of
% background
g = 0.01;
img_binary = img_binary .* ((himg>(upper_thresh*(1-g))) + (himg<((1+g)*lower_thresh)));

img_hue_cell = {};
xlength_arr = [];
ylength_arr = [];
ratios = [];
current_img_hues = [];
for j = 1:length(img_reg)
    if ((img_reg(j).MajorAxisLength>0.8*2*dime_rad_x) && (img_reg(j).Eccentricity<0.6))
        
%         subplot(121)
%         imshow(img_binary)
%         subplot(122)
        current_img_bw = img_labeled == j;
        current_img_bw = current_img_bw.*img_binary;
        [b a] = find(current_img_bw);
        xlength = max(a)-min(a);
        ylength = max(b)-min(b);
        current_img_color = uint8(zeros(size(img)));
        current_img_color(:,:,1) = img(:,:,1).*uint8(current_img_bw);
        current_img_color(:,:,2) = img(:,:,2).*uint8(current_img_bw);
        current_img_color(:,:,3) = img(:,:,3).*uint8(current_img_bw);
        figure
        subplot(121)
        imshow(current_img_color)
%         current_img_hsv = rgb2hsv(current_img_color);
        current_img_hue = simg.*current_img_bw;
        current_img_hue = current_img_hue((current_img_hue>0) & (current_img_hue ~= 1));
        img_hue_cell{length(img_hue_cell)+1} = current_img_hue';
%         current_img_hues = [current_img_hues current_img_hue'];
%         penny_threshold = 0.075;
%         ratio = (length(find((current_img_hue>penny_threshold) .* (current_img_hue<lower_thresh))) + length(find((current_img_hue>upper_thresh))))/...
%             (length(find((current_img_hue<penny_threshold))))
%          ratios = [ratios ratio];
        subplot(122)
        imhist(current_img_hue(find(current_img_hue>0)))
%         length(find(hsvimg1a>.3333))
% %         (.075*length(find(hsvimg1a)))
%         xlength
%         ylength
%         mean(hsvimg1a(find((hsvimg1a<0.75).*(hsvimg1a>0))));
%         sqrt(((xlength/2-penny_rad_x)/penny_rad_x)^2+((ylength/2-penny_rad_y)/penny_rad_y)^2);
%         if ((ratio < .2 ) && (sqrt(((xlength/2-penny_rad_x)/penny_rad_x)^2+((ylength/2-penny_rad_y)/penny_rad_y)^2)<.25))
%             numpennys = numpennys + 1;
%          else
            xlength_arr = [xlength_arr xlength];
            ylength_arr = [ylength_arr ylength];
%             2*[quarter_rad_x nickel_rad_x dime_rad_x]
%             2*[quarter_rad_y nickel_rad_y dime_rad_y]
%             img_reg(j).Area
%             pi*[quarter_rad_x nickel_rad_x dime_rad_x].*[quarter_rad_y nickel_rad_y dime_rad_y]
%             dist = sqrt((xlength-(2*[quarter_rad_x nickel_rad_x dime_rad_x])).^2+(ylength-(2*[quarter_rad_y nickel_rad_y dime_rad_y])).^2);
%             coin_id = find(dist == min(dist));
%             if (coin_id == 1)
%                 numquarters = numquarters +1;
%             end
%             if (coin_id == 2)
%                 numnickels = numnickels +1;
%             end
%             if (coin_id == 3)
%                 numdimes = numdimes +1;
%             end
%          end
    end
end
[n x] = hist([img_hue_cell{:}],1000);
[a b c d] = extrema(diff(n));
ind_low = min(d(find(c<min(c)/4)));
ind_high = max(b(find(a>max(a)/4)));
n_range = n(ind_low:ind_high);
x_range = x(ind_low:ind_high);
penny_threshold = x_range(find(n_range == min(n_range)))
% penny_threshold = mean([x(min(d(find(c<min(c)/10)))),x(max(b(find(a>max(a)/10))))]);
for j = 1:length(xlength_arr)
%     xlength_arr(j)
    if(xlength_arr(j)>2*quarter_rad_x)
        quarter_rad_x = ((numquarters+numdimes+1)*quarter_rad_x+xlength_arr(j)/2)/(numdimes+numquarters+2);
        quarter_rad_y = ((numquarters+numdimes+1)*quarter_rad_y+ylength_arr(j)/2)/(numdimes+numquarters+2);
        dime_rad_x = round((.705/.955)*quarter_rad_x);
        nickel_rad_x = round((.835/.955)*quarter_rad_x);
        dime_rad_y = round((.705/.955)*quarter_rad_y);
        nickel_rad_y = round((.835/.955)*quarter_rad_y);
        numquarters = numquarters+1;
    else
        if(xlength_arr(j)<2*dime_rad_x)
            dime_rad_x = ((numquarters+1)*dime_rad_x+xlength_arr(j)/2)/(numdimes+numquarters+2);
            dime_rad_y = ((numquarters+1)*dime_rad_y+ylength_arr(j)/2)/(numdimes+numquarters+2);
            quarter_rad_x = round((.955/.705)*dime_rad_x);
            quarter_rad_y = round((.955/.705)*dime_rad_y);
            nickel_rad_x = round((.835/.955)*quarter_rad_x);
            nickel_rad_y = round((.835/.955)*quarter_rad_y);
            numdimes = numdimes + 1;
        end
    end
end
numquarters = 0;
numdimes = 0;
radii_x = [dime_rad_x penny_rad_x nickel_rad_x quarter_rad_x];
radii_y = [dime_rad_y penny_rad_y nickel_rad_y quarter_rad_y];
for j = 1:length(xlength_arr)
    current_img_hue = img_hue_cell{j};
    ratio = (length(find((current_img_hue>penny_threshold) .* (current_img_hue<lower_thresh))) + length(find((current_img_hue>upper_thresh))))/...
    (length(find((current_img_hue<penny_threshold))))
    penny_rad_dists = sqrt(((xlength_arr(j)/2-radii_x)./radii_x).^2+((ylength_arr(j)/2-radii_y)./radii_y).^2);
    if ((ratio<.2) && ((min(penny_rad_dists)/penny_rad_dists(2))>.25))
        numpennys = numpennys+1;
    else
        dist = sqrt((xlength_arr(j)-(2*[quarter_rad_x nickel_rad_x dime_rad_x])).^2+(ylength_arr(j)-(2*[quarter_rad_y nickel_rad_y dime_rad_y])).^2);
        coin_id = find(dist == min(dist));
        if (coin_id == 1)
            numquarters = numquarters +1;
        end
        if (coin_id == 2)
            numnickels = numnickels +1;
        end
        if (coin_id == 3)
            numdimes = numdimes +1;
        end
    end
end
% figure,
% imhist(new_img_regg)
numpennys
numdimes
numnickels
numquarters
dollar_value = [.01 .05 .1 .25]*[numpennys numnickels numdimes numquarters]';
% im_size(1) = size(img,1);
% im_size(2) = size(img,2);
% for j = 1:im_size(1)
%     for k = 1:im_size(2)
%         pixel = img(j,k,:);
%         bin = zeros(1,3);
%         for col = 1:3
%             [tmp bin(col)] = min(abs(double(pixel(col)) - bin_centers));
%         end
%         img_penny(j,k) = classifier(bin(1),bin(2),bin(3));
%     end
% end
% 
% max(max(bwlabel(~imerode(imdilate(penny_img,ones(penny_rad,penny_rad)),ones(penny_rad,penny_rad)))))
% 
% for rad_ind = 1:length(rads)
%     rad = rads(rad_ind)
% close all, img = imread('fourcoinsgreen.jpg'); img =255*uint8(im2bw(img(:,:,1),graythresh(img(:,:,1))));
% %        imshow(img);
%        imgBW = edge(img);
%        [y0detect,x0detect,Accumulator] = houghcircle(imgBW,rad,rad);
% %        figure;
% %        imshow(imgBW);
% %        hold on;
% %        plot(x0detect(:),y0detect(:),'x','LineWidth',2,'Color','yellow');
%        points_found(rad_ind) = length(x0detect(:));
% %        figure;
% %        imagesc(Accumulator);
% %        if length(x0detect)>maxpoints
% %            current_rad = rad;
% %            maxpoints = length(x0detect);
% %        end
% %        if length(x0detect)==maxpoints
% %            current_rad = [current_rad rad];
% %            maxpoints = length(x0detect);
% %        end
% %        rad
% %        length(x0detect)
% %        current_rad
% %        maxpoints
% end
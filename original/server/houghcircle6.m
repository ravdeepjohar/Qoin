function transform = houghcircle(Imbinary,r)

% Adapted from code written by
%       Amin Sarafraz
%       Photogrammetry & Computer Vision Devision
%       Geomatics Department,Faculty of Engineering
%       University of Tehran,Iran
%       sarafraz@geomatics.ut.ac.ir


imSize = size(Imbinary);
region = [1,1,imSize(2),imSize(1)];   

transform = zeros(imSize);
xmin = region(1); xmax = xmin + region(3) - 1;
ymin = region(2); ymax = ymin + region(4) - 1;
[yIndex xIndex] = find(Imbinary);
% loop through edge points
for cnt = 1:length(xIndex) 
    xCenter = xIndex(cnt); yCenter = yIndex(cnt);
    xmx=xCenter-r; xpx=xCenter+r;
    ypx=yCenter+r; ymx=yCenter-r;    
    % skip this point if circle is completely outside region
    if xpx<xmin || xmx>xmax || ypx<ymin || ymx>ymax, continue; end   
    if ypx<=imSize(1) && ymx>=1 && xpx<=imSize(2) && xmx>=1 % circle is completely inside region    
        x = 1;
        y = r;
        d = 5/4 - r;
        transform(ypx,xCenter) = transform(ypx,xCenter) + 1; 
        transform(ymx,xCenter) = transform(ymx,xCenter) + 1;  
        transform(yCenter,xpx) = transform(yCenter,xpx) + 1;
        transform(yCenter,xmx) = transform(yCenter,xmx) + 1;
        while y > x           
            xpx = xCenter+x; xmx = xCenter-x; 
            ypy = yCenter+y; ymy = yCenter-y;
            ypx = yCenter+x; ymx = yCenter-x;
            xpy = xCenter+y; xmy = xCenter-y;
            transform(ypy,xpx) = transform(ypy,xpx) + 1;
            transform(ymy,xpx) = transform(ymy,xpx) + 1;
            transform(ypy,xmx) = transform(ypy,xmx) + 1;
            transform(ymy,xmx) = transform(ymy,xmx) + 1;
            transform(ypx,xpy) = transform(ypx,xpy) + 1;
            transform(ymx,xpy) = transform(ymx,xpy) + 1;
            transform(ypx,xmy) = transform(ypx,xmy) + 1;
            transform(ymx,xmy) = transform(ymx,xmy) + 1;
            if d < 0
                d = d + x * 2 + 3;
	            x = x + 1;
            else
                d = d + (x - y) * 2 + 5;
	            x = x + 1;
	            y = y - 1;
            end    
        end 
        if x == y
            xpx = xCenter+x; xmx = xCenter-x;
            ypy = yCenter+y; ymy = yCenter-y;
            transform(ypy,xpx) = transform(ypy,xpx) + 1;
            transform(ymy,xpx) = transform(ymy,xpx) + 1;
            transform(ypy,xmx) = transform(ypy,xmx) + 1;
            transform(ymy,xmx) = transform(ymy,xmx) + 1;
        end
    else % circle is partly outside region - need boundary checking  
        ypxin = ypx>=ymin & ypx<=ymax;
        ymxin = ymx>=ymin & ymx<=ymax;
        xpxin = xpx>=xmin & xpx<=xmax;
        xmxin = xmx>=xmin & xmx<=xmax;
        if ypxin, transform(ypx,xCenter) = transform(ypx,xCenter) + 1; end 
        if ymxin, transform(ymx,xCenter) = transform(ymx,xCenter) + 1; end  
        if xpxin, transform(yCenter,xpx) = transform(yCenter,xpx) + 1; end 
        if xmxin, transform(yCenter,xmx) = transform(yCenter,xmx) + 1; end
        x = 1;
        y = r;
        d = 5/4 - r;
        while y > x         
            xpx = xCenter+x; xpxin = xpx>=xmin & xpx<=xmax;
            xmx = xCenter-x; xmxin = xmx>=xmin & xmx<=xmax;
            ypy = yCenter+y; ypyin = ypy>=ymin & ypy<=ymax;
            ymy = yCenter-y; ymyin = ymy>=ymin & ymy<=ymax;
            ypx = yCenter+x; ypxin = ypx>=ymin & ypx<=ymax;
            ymx = yCenter-x; ymxin = ymx>=ymin & ymx<=ymax;
            xpy = xCenter+y; xpyin = xpy>=xmin & xpy<=xmax;
            xmy = xCenter-y; xmyin = xmy>=xmin & xmy<=xmax;
            if ypyin && xpxin, transform(ypy,xpx) = transform(ypy,xpx) + 1; end
            if ymyin && xpxin, transform(ymy,xpx) = transform(ymy,xpx) + 1; end
            if ypyin && xmxin, transform(ypy,xmx) = transform(ypy,xmx) + 1; end
            if ymyin && xmxin, transform(ymy,xmx) = transform(ymy,xmx) + 1; end
            if ypxin && xpyin, transform(ypx,xpy) = transform(ypx,xpy) + 1; end
            if ymxin && xpyin, transform(ymx,xpy) = transform(ymx,xpy) + 1; end
            if ypxin && xmyin, transform(ypx,xmy) = transform(ypx,xmy) + 1; end
            if ymxin && xmyin, transform(ymx,xmy) = transform(ymx,xmy) + 1; end
            if d < 0
                d = d + x * 2 + 3;
	            x = x + 1;
            else
                d = d + (x - y) * 2 + 5;
	            x = x + 1;
	            y = y - 1;
            end  
        end 
        if x == y
            xpx = xCenter+x; xpxin = xpx>=xmin & xpx<=xmax;
            xmx = xCenter-x; xmxin = xmx>=xmin & xmx<=xmax;
            ypy = yCenter+y; ypyin = ypy>=ymin & ypy<=ymax;
            ymy = yCenter-y; ymyin = ymy>=ymin & ymy<=ymax;
            if ypyin && xpxin, transform(ypy,xpx) = transform(ypy,xpx) + 1; end
            if ymyin && xpxin, transform(ymy,xpx) = transform(ymy,xpx) + 1; end
            if ypyin && xmxin, transform(ypy,xmx) = transform(ypy,xmx) + 1; end
            if ymyin && xmxin, transform(ymy,xmx) = transform(ymy,xmx) + 1; end
        end
    end
end

function threshold = determineThresh(arr)
% Find threshold value that minimize mean square
% difference between data and threshold
x = min(arr):.01:max(arr);
score = zeros(1,length(x));
for j = 1:length(x),
    score(j) = sum((arr-x(j)).^2);
end
threshold = x(find(score == min(score)));
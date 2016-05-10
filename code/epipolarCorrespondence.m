function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
%% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q2.6 - Todo:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q2_6.mat
%
%           Explain your methods and optimization in your writeup
%% Get the box for the first image
box_size = [45, 45]; % Size of box
h=fspecial('gaussian',[5 5], 3); 
box1 = im1(y1-box_size(1):y1+box_size(2), x1-box_size(1):x1+box_size(2));
% Use gaussian blur
box1 = imfilter(box1, h);
%% Get the interpolated line
x1 = round(x1);
y1 = round(y1);
v(1) = x1;
v(2) = y1;
v(3) = 1;
l = F * v';
% Convert it to a unit vector
s = sqrt(l(1)^2+l(2)^2);
l = l/s;
%% Get the x and y interpolated values for the second image
p1_prox = 15; % How far from the first image point you search
y_interp = y1-p1_prox:1:y1 + p1_prox;
x_interp = round(-(l(2) * y_interp(:) + l(3))/l(1));
%% Loop through the window and find the best results
bestX = 0;
bestY = 0;
min = inf;
for i = 1:size(x_interp,1)
    % Get the box in the second image
    if(y_interp(i) - box_size(1) < 1 ||...
            y_interp(i) + box_size(1) > size(im1,1) || ...
            x_interp(i) - box_size(2) < 1 || ...
            x_interp(i) + box_size(2) > size(im1,2))
        continue
    else
        box2 = im2(y_interp(i) - box_size(1):y_interp(i) + box_size(1), ...
                   x_interp(i) - box_size(2):x_interp(i) + box_size(2));
        % Blur
        box2 = imfilter(box2, h);
        % Get the sum of squared differences
        sum_squared_dist = sum((box1(:) - box2(:)).^2);
        if(sum_squared_dist < min)
            bestX = x_interp(i);
            bestY = y_interp(i);
            min = sum_squared_dist;
        end
    end
end
x2 = bestX;
y2 = bestY;
end

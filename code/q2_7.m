%% Description
% viewTemple.m
% This is a function that runs the whole functions in order to find all of
% the 3D points in order to plot them
clear;
clc;
warning('off'); % Supress warnings
%% Load all of the pertinent values
load('q2_1.mat'); % loads proper F
load('q2_5.mat'); % loads proper M2
load('../data/templeCoords.mat'); % loads the temple coordinates
im1 = im2double(rgb2gray(imread('../data/im1.png')));% Get first image
im2 = im2double(rgb2gray(imread('../data/im2.png'))); % Get second image
load('../data/intrinsics.mat'); % Load intrinisics
%% Get the point correspondences
x2 = zeros(size(x1)); % Preallocate
y2 = zeros(size(y1)); % Preallocate
for i = 1:size(x2,1)
    [x2(i), y2(i)] = epipolarCorrespondence(im1, im2, F, x1(i), y1(i));
end
%% Get the triangulated points
p1 = [x1 y1];
p2 = [x2 y2];
M1 = [1, 0, 0, 0;
      0, 1, 0, 0;
      0, 0, 1, 0];
P = triangulate(K1*M1, p1, M2, p2);
%% Show the scatter plot
figure;
im2 = imread('../data/im2.png');
imshow(im2);
hold on;
scatter(x1, y1);
scatter(x2,y2, 'r');
hold off;
figure;
scatter3(P(:,1), P(:,2), P(:,3));
%% Save the information
save('q2_7.mat', 'F', 'M1', 'M2');

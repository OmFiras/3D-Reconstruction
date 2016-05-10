function [ F ] = eightpoint( pts1, pts2, M )
%% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup
%% Manage the input data
% Scale the coordinates
one = ones(size(pts1,1),1);
T = [2/M,   0,  -1;
     0,   2/M,  -1;
     0,     0,   1]; 
pts1 = [pts1, one]*T;
pts2 = [pts2, one]*T;
%% Generate the A matrix where AF = 0
A = [pts1(:,1).*pts2(:,1), ...
     pts1(:,1).*pts2(:,2), ...
     pts1(:,1), ...
     pts1(:,2).*pts2(:,1), ...
     pts1(:,2).*pts2(:,2), ...
     pts1(:,2), ...
     pts2(:,1), ...
     pts2(:,2), ...
     one];
%% Get the eigenvectors and eigenvalues of the A matrix
[U,S,V] = svd(A);
%% Get and rescale the F matrix
F = V(:, size(V,2));
F = reshape(F, [3,3])';
[U,S,V] = svd(F);
S(3,3) = 0;
F = U*S*V';
F = refineF(F, pts1, pts2);
F = T'*F*T; % Unscale
end
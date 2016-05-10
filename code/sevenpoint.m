function [ F ] = sevenpoint( pts1, pts2, M )
%% sevenpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2 - Todo:
%     Implement the sevenpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup
%% Manage the input data
% Scale the coordinates
one = ones(size(pts1,1),1);
T = [2/M,   0,  -1;
     0,   2/M,  -1;
     0,     0,  1]; 
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
%% Get the two possible fundamental matrices
f2 = V(:, size(V,2)); % Last vector in V
f1 = V(:, size(V,2) - 1); % Second to last vector in V
F1 = reshape(f1, [3,3])';
F2 = reshape(f2, [3,3])';
%% Solve the polynomial
% Find an alpha s.t. det(alpha*F1 + (1-alpha)*F2) = 0
syms alph
% Solve for alphas
alphas = double(solve(det(alph * F1 + (1-alph)*F2) == 0, alph));
alpha_choice = real(alphas); % Prune off the imaginary part
F = cell(1,3); % Preallocate
if(size(alpha_choice,1) ~= 0)
    for i = 1:size(alpha_choice)
        F{i} = alpha_choice(i)*F1 + (1-alpha_choice(i))*F2;
        [U,S,V] = svd(F{i});
        S(3,3) = 0;
        F{i} = U*S*V';
        F{i} = refineF(double(F{i}), pts1, pts2);
        F{i} = T'*F{i}*T; % Unscale
    end
else
    disp('Too many solutions');
    F = alphas % display the alphas
end
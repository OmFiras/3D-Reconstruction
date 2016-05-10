 function [ F ] = ransacF( pts1, pts2, M )
%% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.X - Extra Credit:
%     Implement RANSAC
%     Generate a matrix F from some '../data/some_corresp_noisy.mat'
%          - using sevenpoint
%          - using ransac

%     In your writeup, describe your algorith, how you determined which
%     points are inliers, and any other optimizations you made
%% Get the initial conditions
nIter = 100;
tol = 0.000000001;
rng(0, 'twister'); % Initialize random number generator
mostIn = 0;
bestF = [];
bestInliersP1 = [];
bestInliersP2 = [];
%% Run the RANSAC algorithm in order to generate the best possible H matrix
for i = 1:nIter % Run for certain iterations
    % Get a random match
    no_random = 7;
    randI = randi([1, size(pts1,1)],1,no_random);
    % Compute the H for the point match
    p1 = pts1(randI, 1:2);
    p2 = pts2(randI, 1:2);
    inliersP1 = p1;
    inliersP2 = p2;
    F = sevenpoint(p1, p2, M);
    for k = size(F,2)
        % For each F count the number of inliers
        inliersP1 = p1;
        inliersP2 = p2;
        no_in = 0;
        for j = 1:size(pts1,1)
            d1 = abs([pts2(j,:),1] * F{k} * [pts1(j,:), 1]'); % Get the reprojection error for x2 on x1
            d2 = abs([pts1(j,:),1] * F{k}' * [pts2(j,:),1]');
            score = d1^2 + d2^2;
            if(score < tol)
                no_in = no_in + 1;
                inliersP1 = [inliersP1; pts1(j,:)];
                inliersP2 = [inliersP2; pts2(j,:)];
            end
        end
        if(no_in > mostIn)
            mostIn = no_in
            bestInliersP1 = inliersP1;
            bestInliersP2 = inliersP2;
            bestF = F{k};
        end
    end
end
%% Use the best inliers to compute the new F
F = sevenpoint(bestInliersP1, bestInliersP2, M);
mostIn = 0;
bestF = [];
bestInliersP1 = [];
bestInliersP2 = [];
for k = size(F,2)
    % For each F count the number of inliers
    no_in = 0;
    for j = 1:size(pts1,1)
        d1 = abs([pts2(j,:),1] * F{k} * [pts1(j,:), 1]'); % Get the reprojection error for x2 on x1
        d2 = abs([pts1(j,:),1] * F{k}' * [pts2(j,:),1]');
        score = d1^2 + d2^2;
        if(score < tol)
            no_in = no_in + 1;
            inliersP1 = [inliersP1; pts1(j,:)];
            inliersP2 = [inliersP2; pts2(j,:)];
        end
    end
    if(no_in > mostIn)
        mostIn = no_in
        bestInliersP1 = inliersP1;
        bestInliersP2 = inliersP2;
        bestF = F{k};
    end
end

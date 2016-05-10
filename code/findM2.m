%% Q2.5 - Todo:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       4. Save the correct M2, p1, p2, R and P to q2_5.mat
%% Load the data
load('../data/some_corresp.mat');
load('../data/intrinsics.mat');
load('q2_1.mat');
%% Get the Ms
M1 = [1, 0, 0, 0;
      0, 1, 0, 0;
      0, 0, 1, 0];
M1 = K1 * M1;
M2s = essentialMatrix(F, K1, K2);
M2s_noK = M2s;
for i = 1:size(M2s,3)
    M2s(:,:,i) = K2 * M2s(:,:,i); 
end
%% Find the correct M
next_index = [];
for i = 1:size(M2s,3)
    % Get the P points
    P = triangulate(M1, pts1, M2s(:,:,i), pts2);
    if(all(P(:,3)) > 0)
        next_index = [next_index; i];
        break;
    end
end 
for i = 1:size(next_index,1)
    Rt = K2 \ M2s(:,:,i);
    P2 = - Rt*P;
    if(all(P2(:,3)) > 0)
        M2 = M2s_noK(:,:,next_index(i));
        break
    end
end
%% Save the data
p1 = pts1;
p2 = pts2;
save('q2_5.mat', 'M2', 'p1', 'p2', 'P');
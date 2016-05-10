function [ M2s ] = essentialMatrix( F, K1, K2 )
%% essentialMatrix:
%    F - Fundamental Matrix
%    K1 - Camera Matrix 1
%    K2 - Camera Matrix 2

% Q2.3 - Todo:
%       Compute the M matrix for camera 2
%
%       Write the computed M matrix in your writeup
%% Get the essential matrix
E = K2' * F * K1;
save('E.mat', 'E');
%% Get M2
M2s = camera2(E);
end


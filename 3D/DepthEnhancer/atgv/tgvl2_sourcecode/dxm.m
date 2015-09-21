function [dx] = dxm(u)
[M N] = size(u);
dx = [u(:,1:end-1) zeros(M,1)] - [zeros(M,1) u(:,1:end-1)];

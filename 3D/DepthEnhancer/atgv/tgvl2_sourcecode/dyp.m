function [dy] = dyp(u)
[M N] = size(u);
dy = [u(2:end,:); u(end,:)] - u;
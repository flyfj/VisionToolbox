
%   TGV2-L2 Depth Image Upsampling Testfile
%
%   Author: David Ferstl
%
%   If you use this file or package for your work, please refer to the
%   following papers:
% 
%   [1] David Ferstl, Christian Reinbacher, Rene Ranftl, Matthias Rüther 
%       and Horst Bischof, Image Guided Depth Upsampling using Anisotropic
%       Total Generalized Variation, ICCV 2013.
%
%   License:
%     Copyright (C) 2013 Institute for Computer Graphics and Vision,
%                      Graz University of Technology
% 
%     This program is free software; you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation; either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see
%     <http://www.gnu.org/licenses/>.

% use noisy of clean input data
noisy = true;
downsample_method = 'bicubic';

% upsampling factor 1/2/3/4
uf = 2;
    
% read high-res rgb and depth
disp_gt = double(imread('test_imgs/art_big.png'));
gray_gt_ = im2double(rgb2gray(imread('test_imgs/view1.png')));

smin = min(disp_gt(:));
smax = max(disp_gt(:));
    
[M, N] = size(disp_gt);
[Mmb, Nmb] = size(gray_gt_);

dd = [Mmb - M; Nmb - N];
    
gray_gt = gray_gt_(dd(1)/2+1:end-dd(1)/2, dd(2)/2+1:end-dd(2)/2);
        
if(noisy)
    factor = 1;
    disp_res_n = double(imread(['test_imgs/depth_' num2str(uf) '_n.png']));
else
    factor = 600;
    disp_res_n = imresize(disp_gt{d}, 1/(2^uf), downsample_method);
end

ours = zeros(M,N);
ours(2^uf-(2^uf/2):2^uf:end, 2^uf-(2^uf/2):2^uf:end) = disp_res_n;

bicubic = imresize(disp_res_n, 2^uf, 'bicubic');
bilinear = imresize(disp_res_n, 2^uf, 'bilinear');
nearest_nb = imresize(disp_res_n, 2^uf, 'nearest');

weights = zeros(M,N);
weights(ours > 0) = 1;

% calculate rmse for common interpolation methods
mse_bicubic = sum(sum(sqrt((double(disp_gt)-double(bicubic)).^2))) / numel(disp_gt);
mse_bilinear = sum(sum(sqrt((double(disp_gt)-double(bilinear)).^2))) / numel(disp_gt);
mse_nearest = sum(sum(sqrt((double(disp_gt)-double(nearest_nb)).^2))) / numel(disp_gt);

% normalize input depth map 
d_min = min(ours(ours>0));
d_max = max(ours(ours>0));
    
ours_norm = (ours-d_min)/(d_max-d_min);
ours_norm(ours_norm < 0) = 0;
ours_norm(ours_norm > 1) = 1;

%% tgv l2

timestep_lambda = 1;

tgv_alpha = [17 1.2];

tensor_ab = [9 0.85];

lambda_tgvl2 = 40;

% iteration number
maxits = 200;
disp(' ---- ');

check = round(maxits/100);
% check = maxits+10;
     
upsampling_result_norm = upsamplingTensorTGVL2(ours_norm, ours_norm, ...
weights.*lambda_tgvl2, gray_gt, tensor_ab, tgv_alpha./factor, timestep_lambda, maxits, ...
check, 0.1, 1);

upsampling_result = uint8(upsampling_result_norm*(d_max-d_min)+d_min);

mse_ours = sum(sum(sqrt((double(disp_gt)-double(upsampling_result)).^2))) / numel(disp_gt);

figure;
subplot(231); imshow(disp_gt,[smin smax]); title(sprintf('groundtruth %dx%d',size(disp_gt)));
subplot(232); imshow(upsampling_result,[smin smax]); title('ours');
subplot(233); imshow(disp_res_n,[smin smax]); title(sprintf('input %dx%d', size(disp_res_n)));
subplot(234); imshow(nearest_nb,[smin smax]); title('nearest');
subplot(235); imshow(bilinear,[smin smax]); title('bilinear');
subplot(236); imshow(bicubic,[smin smax]); title('bicubic');
colormap(jet);
impixelinfo;
drawnow;

fprintf(1,'\n-- TGV2 - L2 \n');
disp(['mse_bicubic  = ' num2str(mse_bicubic)]);
disp(['mse_bilinear = ' num2str(mse_bilinear)]);
disp(['mse_nearest  = ' num2str(mse_nearest)]);
fprintf(1,'-- OURS: \n');
disp(['mse         =  ' num2str(mse_ours)]);

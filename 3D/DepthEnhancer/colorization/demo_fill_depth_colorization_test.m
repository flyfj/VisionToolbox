
%% load rgbd images
% DATASET_PATH = '~/data1/kinect/spatial_relations_data/labeled_data.mat';
% load(DATASET_PATH, 'images', 'rawDepths');

DATASET_PATH = 'F:\Depth\Kinect1\2015_07_06_11_22_34\';
%DATASET_PATH = 'F:\Depth\Kinect2\2015_6_24_9_53_58\';
IMG_NAME = '10'; % 83
imgRgb = imread([DATASET_PATH IMG_NAME '_color.png']);
imgDepthAbs = load([DATASET_PATH IMG_NAME '_rawdepth.dmap']);
assert(size(imgRgb,1)==size(imgDepthAbs,1) && size(imgRgb,2)==size(imgDepthAbs,2));
% convert to meter
imgDepthAbs = imgDepthAbs / 1000;

%%
imageInd = 1;

%imgRgb = images(:,:,:,imageInd);
%imgDepthAbs = rawDepths(:,:,imageInd);

% Crop the images to include the areas where we have depth information.
% imgRgb = crop_image(imgRgb);
% imgDepthAbs = crop_image(imgDepthAbs);

imgRgb = double(imgRgb) ./ 255;
imgDepthFilled = fill_depth_colorization(imgRgb, double(imgDepthAbs));

figure(1);
subplot(1,3,1); imagesc(imgRgb);
subplot(1,3,2); imagesc(imgDepthAbs);
subplot(1,3,3); imagesc(imgDepthFilled);
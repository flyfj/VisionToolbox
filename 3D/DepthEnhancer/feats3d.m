% process 3d features
addpath(genpath('.'));

DATASET_PATH = 'F:\Depth\NYUDepth2\images_depth\';
% DATASET_PATH = 'F:\Depth\Kinect1\2015_07_06_11_22_34\';
% DATASET_PATH = 'F:\Depth\Kinect2\2015_6_24_9_53_58\';
IMG_NAME = 'depth_000009.mat';
imgDepthAbs = load([DATASET_PATH IMG_NAME]);
imgDepthAbs = imgDepthOrig;
% imgRgb = imread([DATASET_PATH IMG_NAME '_color.png']);
% imgDepthAbs = load([DATASET_PATH IMG_NAME '_rawdepth.dmap']);
[h,w] = size(imgDepthAbs);

% improve depth
% new_depth = fill_depth_cross_bf(imgRgb, double(imgDepthAbs./1000)) .* 1000;
% new_depth = fill_depth_colorization(double(imgRgb)./255, double(imgDepthAbs), 1);

[projectionMask, projectionSize] = get_projection_mask();

% output one point array or a matrix
pts = depth2pcl(imgDepthAbs, 'Kinect1', true);
pts(:,2) = -pts(:,2);
% visualize point cloud
figure
plot3(pts(:,1), pts(:,2), pts(:,3), 'r.')

[imgplanes, imgnormals, ~] = compNormals(pts);

% compute normals
% subsample
samps = 1:3:size(pts,1);
length(samps)
% pts = pts(samps,:);

% find nearest neighbor
[idx] = knnsearch(pts, pts, 'k', 20);

% compute normals
normals = zeros(length(idx),3);
for i=1:size(pts,1)
    normals(i,:) = normnd(pts(idx(i,:),:));
%     if (normals(i,:).*pts(i,:))>0
%         normals(i,:) = - normals(i,:);
%     end
end
disp('normal vectors computed.');

disp3d = false;
if disp3d
    % visualize
    figure
    quiver3(pts(:,1), pts(:,2), pts(:,3), normals(:,1), normals(:,2), normals(:,3), 'AutoScaleFactor', 1.2)
else
    % convert back to image
    img_normals = reshape(normals, w, h, 3);
    img_normals = permute(img_normals, [2, 1, 3]);
%     cnt = 0;
%     for r=1:h
%         for c=1:w
%             img_normals(r,c,:) = normals()
%         end
%     end
    figure
    subplot(1,2,1)
    imshow(new_depth,[])
    subplot(1,2,2)
    imshow(img_normals, [])
end




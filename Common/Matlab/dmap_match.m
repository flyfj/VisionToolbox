


%% init
addpath('C:\vlfeat-0.9.20-bin\toolbox\');
vl_setup

img_dir = 'F:\3D\ModelNet\test_db_depth\';
db_dir = 'F:\3D\ModelNet\depth_hog\';
query_dir = 'F:\3D\ModelNet\kinect_query\';
new_sz = [64 64];

%% visualize hog
cellSize = 8;
imgfn = 'E:\frame_320.png';
img = imread(imgfn);
img = imresize(img, new_sz);
figure
subplot(1, 2, 1)
imagesc(img)
hog = vl_hog(single(img), cellSize, 'verbose');
% render hog
imhog = vl_hog('render', hog, 'verbose');
subplot(1, 2, 2)
imagesc(imhog);
colormap gray ;

%% extract image and feature

imgfns = dir([img_dir '*_depth.png']);
[m,n] = size(imgfns);
%img_pixel = zeros(m, 64*64);
img_hogs = zeros(m, 1984);
img_files = cell(m, 1);
for i=1:m
    curfn = [img_dir imgfns(i).name];
    img_files{i,1} = imgfns(i).name;
    curimg = imread(curfn);
    curimg = imresize(curimg, new_sz);
%     img_pixel(i, :) = curimg(:)';
    % compute hog
    cellSize = 8;
    hog = vl_hog(single(curimg), cellSize, 'verbose');
    % render hog
%     imhog = vl_hog('render', hog, 'verbose') ;
%     clf ; imagesc(imhog) ; colormap gray ;
%     pause
    img_hogs(i, :) = hog(:)';
    
    disp([num2str(i) '|' num2str(m)]);
end

% save
save('query_fns.mat', 'img_files', '-v7.3');
% save('img_data.mat', 'img_pixel', '-v7.3');
save('query_hog.mat', 'img_hogs', '-v7.3');


%% match object depth map

% load query
query_dir = '';
qfns = dir([query_dir '*.png']);
query_files = cell(size(qfns,1), 1);
query_pixel = [];
query_hogs = [];
for i=1:size(qfns,1)
    curfn = [query_dir qfns(i).name];
    query_files{i,1} = curfn;
    curimg = imread(curfn);
    curimg = rgb2gray(curimg);
    query_pixel = [query_pixel; curimg(:)'];
    % compute hog
    cellSize = 8;
    hog = vl_hog(single(curimg), cellSize, 'verbose');
    query_hogs = [query_hogs; hog(:)'];
end


%% HOG L2

depth_hog = load([db_dir 'depth_hog.mat']);
depth_hog = depth_hog.img_hogs;
img_fns = load([db_dir 'img_fns.mat']);
img_fns = img_fns.img_files;
img_fns = img_fns.';
% append root dir
for i=1:length(img_fns)
    img_fns{i} = [img_dir img_fns{i}];
end

%% test
fns = dir([query_dir '*_depth.png']);
query_fns = cell(length(fns), 1);
ranked_res_fns = cell(length(query_fns), size(img_fns,2));
for i=1:1 %length(fns)
    query_dir = img_dir;
    cur_qfn = [query_dir 'table__table_000000165__7.png'];
    curimg = imread(cur_qfn);
    curimg = imresize(curimg, new_sz);
    % compute hog
    cellSize = 8;
    hog = vl_hog(single(curimg), cellSize, 'verbose');
    qhog = hog(:)';
    qhog_mat = repmat(qhog, size(depth_hog,1), 1);
    dists = abs(qhog_mat - depth_hog).^2;
    dists = sum(dists, 2);
    dists = sqrt(dists);
    [Y,I] = sort(dists, 1);
    query_fns{i,1} = cur_qfn;
    ranked_res_fns(i,:) = img_fns(1,I);
    disp(num2str(i));
end
%%
 visualize_search_res('res.html', query_fns, ranked_res_fns, 50);


%% 
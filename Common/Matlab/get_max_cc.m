
%% extract maximum connected component from image

root_dir = 'F:\3D\ModelNet\full_depth\';
save_dir = 'F:\3D\ModelNet\full_depth\';
to_resize = false;
norm_sz = [64 64];    % [256, 256]

dmap_list_file = 'f:\3D\ModelNet\depth_view_list.txt';
fns = importdata(dmap_list_file);

% classify images based on filename
% fns = dir([root_dir '*.png']);
fn_num = size(fns, 1);
parfor i=1:fn_num
    cur_fn = fns{i};
    cur_fn_path = cur_fn; %[root_dir cur_fn];
    if exist(cur_fn_path, 'file') == 0
        continue;
    end
    img = imread(cur_fn_path);
    grayimg = rgb2gray(img);
    [imgh, imgw] = size(grayimg);
    binimg = grayimg > 0;
    % get object bounding box
    stats = regionprops(binimg, 'Area', 'BoundingBox');
    if(size(stats,1) == 0)
        continue;
    end
    cc_sz = zeros(size(stats,1), 1);
    for j=1:size(cc_sz,1)
        cc_sz(j) = stats(j).Area;
    end
    [~, maxid] = max(cc_sz);
    % tighten object, normalize size
    newimg = imcrop(grayimg, stats(maxid).BoundingBox);
    if to_resize
        newimg = imresize(newimg, norm_sz);
    end
    % save
    save_fn = [cur_fn '_cc.jpg'];
    imwrite(newimg, save_fn);
    %imwrite(newimg, [save_dir cur_fn]);
    
    disp([num2str(i) '/' num2str(fn_num)]);
end

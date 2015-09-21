function sunrgbd_kv1_convertor(img_dir, save_dir)
% process nyu2 and b3d

% img_dir = 'F:\Depth\SUN_RGBD\SUNRGBD\SUNRGBD\kv1\NYUdata\';
% save_dir = 'F:\Depth\SUN_RGBD\Separated\Kinect1\NYU2\';

cate_name_counts = containers.Map();
imgs = dir([img_dir '*']);
imgs(1:3) = [];
for i=1:length(imgs)
    folder = imgs(i).name;
    % find image name
    tmp = dir([img_dir folder '\image\*.jpg']);
    fn = tmp(1).name(1:end-4);
    % create image folder
    mkdir(save_dir, fn);
    cur_save_dir = [save_dir fn '\'];
    % copy color image
    cimg_fn = [img_dir folder '\image\' fn '.jpg'];
    save_fn = [cur_save_dir fn '_color.png'];
    copyfile(cimg_fn, save_fn);
    % copy and convert depth image
    depth_fn = [img_dir folder '\depth_bfx\' fn '.png'];
    depth = imread(depth_fn);
    depth = double(depth) ./ 10;
    save_fn = [cur_save_dir fn '_depthnew.png'];
    copyfile(depth_fn, save_fn);
    % convert depth and save
    save_fn = sprintf('%s%s_depthnew.dmap', cur_save_dir, fn);
    if(~exist(save_fn, 'file'))
        save_dmap(depth, save_fn);
    end
    % save ground truth. mask file naming: imgname__category__num__mask.png
    gt = load([img_dir folder '\seg.mat']);
    cnt = 0;
    for j=1:length(gt.names)
        catename = gt.names{j};
        catename(~isletter(catename)) = [];
        mask = gt.seglabel==j;
        if(sum(mask(:)) == 0)
            continue;
        end
        % separate each disjoint region as a unique object instance
        cc = bwconncomp(mask);
        for k=1:cc.NumObjects
            save_fn = sprintf('%s%s__%s__%d__mask.png', cur_save_dir, fn, catename, cnt);
            cur_mask = zeros(size(mask));
            cur_mask(cc.PixelIdxList{k}) = 1;
            % count category object
            if ~isKey(cate_name_counts, catename)
                cate_name_counts(catename) = 0;
            end
            cate_name_counts(catename) = cate_name_counts(catename) + 1;
            imwrite(cur_mask, save_fn, 'png');
            cnt = cnt + 1;
        end
    end
    
    fprintf('%d/%d done.\n', i, length(imgs));
end

end
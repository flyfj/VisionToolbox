function sunrgbd_kv2_convertor(img_dir, save_dir)

% img_dir = 'F:\Depth\SUN_RGBD\SUNRGBD\SUNRGBD\kv2\align_kv2\';
% save_dir = 'F:\Depth\SUN_RGBD\Separated\Kinect2\align_kv2\';

% there are duplicate image names in different folders,
% need to rename each image
cate_name_counts = containers.Map();
imgs = dir([img_dir '*']);
imgs(1:3) = [];
for i=870:length(imgs)
    folder = imgs(i).name;
    % find image file
    tmp = dir([img_dir folder '\image\*.jpg']);
    imgfn = tmp(1).name(1:end-4);
    % create save folder
    fn = num2str(i-1);
    mkdir(save_dir, fn);
    cur_save_dir = [save_dir fn '\'];
    % copy color image
    cimg_fn = [img_dir folder '\image\' imgfn '.jpg'];
    save_fn = [cur_save_dir fn '_color.png'];
    copyfile(cimg_fn, save_fn);
    % copy and convert depth image
    depth_fn = [img_dir folder '\depth_bfx\' imgfn '.png'];
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
            if(sum(cur_mask(:)) < 100)
                continue;
            end
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

%%
%save([save_dir 'kv2_data_cates.mat'], 'cate_name_counts');
fprintf('conversion ends. category names and counts are saved in file.\n');

end
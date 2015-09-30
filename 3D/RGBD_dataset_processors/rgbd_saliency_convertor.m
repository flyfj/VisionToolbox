function rgbd_saliency_convertor(img_dir, depth_dir, gt_dir, save_dir)

img_dir = 'F:\Depth\RGBD_Saliency\RGB\';
depth_dir = 'F:\Depth\RGBD_Saliency\Depth\smoothedDepth\';
gt_dir = 'F:\Depth\RGBD_Saliency\groundtruth\';
save_dir = 'F:\Depth\RGBD_Saliency\converted\';

imgs = dir([img_dir '*.jpg']);
for i=1:length(imgs)
    fn = imgs(i).name(1:end-4);
    % create image folder
    mkdir(save_dir, fn);
    cur_save_dir = [save_dir fn '\'];
    % copy color image
    cimg_fn = [img_dir fn '.jpg'];
    save_fn = [cur_save_dir fn '_color.png'];
    copyfile(cimg_fn, save_fn);
    % copy and convert depth image
    depth_fn = [depth_dir fn '_Depth.mat'];
    depth = load(depth_fn);
    depth = depth.smoothedDepth;
    imwrite(mat2gray(depth), [cur_save_dir fn '_depthnew.png']);
    depth = double(depth) ./ 10;
    % convert depth and save
    save_fn = sprintf('%s%s_depthnew.dmap', cur_save_dir, fn);
    if(~exist(save_fn, 'file'))
        save_dmap(depth, save_fn);
    end
    % ground truth. mask file naming: imgname__category__num__mask.png
    gt_fn = [gt_dir fn '.jpg'];
    gt = imread(gt_fn);
    gt = gt > 128;
    % separate each disjoint region as a unique object instance
    cnt = 0;
    cc = bwconncomp(gt);
    for k=1:cc.NumObjects
        save_fn = sprintf('%s%s__any__%d__mask.png', cur_save_dir, fn, cnt);
        cur_mask = zeros(size(gt));
        cur_mask(cc.PixelIdxList{k}) = 1;
        imwrite(cur_mask, save_fn, 'png');
        cnt = cnt + 1;
    end
    
    fprintf('%d/%d done.\n', i, length(imgs));
end

end

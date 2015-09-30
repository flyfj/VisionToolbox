function osd_convertor( root_dir, save_dir )
%OSD_CONVERTOR Summary of this function goes here
%   Detailed explanation goes here

img_dir = [root_dir 'image_color\'];
depth_dir = [root_dir 'disparity\'];
gt_dir = [root_dir 'annotation\'];

cate_name_counts = containers.Map();
imgs = dir([img_dir '*.png']);
for i=1:length(imgs)
    folder = imgs(i).name;
    fn = folder(1:end-4);
    % create image folder
    mkdir(save_dir, fn);
    cur_save_dir = [save_dir fn '\'];
    % copy color image
    cimg_fn = [img_dir folder];
    save_fn = [cur_save_dir fn '_color.png'];
    copyfile(cimg_fn, save_fn);
    % copy and convert depth image
    depth_fn = [depth_dir folder];
    depth = imread(depth_fn);
    save_fn = [cur_save_dir fn '_depthnew.png'];
    copyfile(depth_fn, save_fn);
    % convert depth and save
    save_fn = sprintf('%s%s_depthnew.dmap', cur_save_dir, fn);
    if(~exist(save_fn, 'file'))
        save_dmap(depth, save_fn);
    end
    % save ground truth. mask file naming: imgname__category__num__mask.png
    gt = imread([gt_dir folder]);
    ids = unique(gt(:));
    cnt = 0;
    for j=1:length(ids)
        % remove background
        if ids(j) == 0
            continue;
        end
        mask = gt==ids(j);
        if(sum(mask(:)) == 0)
            continue;
        end
        catename = 'any';
        % separate each disjoint region as a unique object instance
        cc = bwconncomp(mask);
        for k=1:cc.NumObjects
            save_fn = sprintf('%s%s__%s__%d__mask.png', cur_save_dir, fn, catename, cnt);
            cur_mask = zeros(size(mask));
            cur_mask(cc.PixelIdxList{k}) = 1;
            % count category object
%             if ~isKey(cate_name_counts, catename)
%                 cate_name_counts(catename) = 0;
%             end
            %cate_name_counts(catename) = cate_name_counts(catename) + 1;
            imwrite(cur_mask, save_fn, 'png');
            cnt = cnt + 1;
        end
    end
    
    fprintf('%d/%d done.\n', i, length(imgs));
end


end


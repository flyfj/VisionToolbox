
function batch_extract_skeleton(indir)

%     indir = 'C:\Users\feng\Projects\Skeletonization_code\in1\';
%     indir = 'K:\RGBD\Saliency\converted\';
% 
%     outdir = 'C:\Users\feng\Projects\Skeletonization_code\out1\';
    exformat = 'png';
    %{
    erode = 1;
    method = 'erode';
    radius = 10;
    %}
    %%{
    erode = 0;
    method = 'dilate_skel';
    radius = 2;
    %}

    img_folders = dir(indir);
    img_folders(1:2) = [];
    for i = 1:size(img_folders,1)
        cur_img_folder = [indir img_folders(i).name '\'];
        % remove all skeleton files first
        delete([cur_img_folder '*ske.png']);
        % get all mask files
        mask_fns = dir([cur_img_folder '*__mask.png']);
        for j=1:length(mask_fns)
            cur_mask_name = mask_fns(j).name(1:end-8);
            cur_mask_fn = [cur_img_folder mask_fns(j).name];
            cur_fg_mask_fn = [cur_img_folder cur_mask_name 'fgske.png'];
            cur_bg_mask_fn = [cur_img_folder cur_mask_name 'bgske.png'];
    %         if exist(cur_fg_mask_fn, 'file')
    %             continue;
    %         end
            M = imread(cur_mask_fn);
            if length(size(M)) == 3
                M = rgb2gray(M);
            end
            M = M > 0;
            [F,B] = BinarySelectionToSkeletonStrokeMasks(M,erode,radius);
            imwrite(F, cur_fg_mask_fn, exformat);
            imwrite(B, cur_bg_mask_fn, exformat);
        end
        fprintf('%d/%d\n', i, size(img_folders,1));
    end
end


% exname = 'audience_L'
% BinarySelectionToSkeletonStrokeMasksRunEx(indir,exname,exformat,outdir,erode,radius);
% 
% exname = 'audience_R'
% BinarySelectionToSkeletonStrokeMasksRunEx(indir,exname,exformat,outdir,erode,radius);
% 
% exname = 'bamboo_L'
% BinarySelectionToSkeletonStrokeMasksRunEx(indir,exname,exformat,outdir,erode,radius);
% 



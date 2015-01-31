
% given a list of box, crop depth patch from depth map
data_root = 'F:\src\res\proposal_saliency\laptop1\';
box_fns = dir([data_root '*.txt']);
[m,n] = size(box_fns);

for i=1:m
    boxes = load([data_root box_fns(i).name]);
    parts = strsplit(box_fns(i).name, '.');
    dmapfn = [data_root parts{1} '.jpg_depth.png'];
    dmap = imread(dmapfn);
    for j=1:size(boxes,1)
        patch = imcrop(dmap, boxes(j, 1:4));
        savefn = [parts{1} '.jpg_' num2str(j-1) '_depth.png'];
        imwrite(patch, [data_root savefn]);
    end
end
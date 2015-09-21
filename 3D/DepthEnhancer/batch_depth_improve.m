% improve depth map in batch

addpath(genpath('.'));

data_dir = 'F:\Depth\Kinect2\2015_7_9_13_22_13\';
startid = 0;
endid = 347;

method = 'colorization';

for i=startid:endid
    try
        img_rgb = imread([data_dir num2str(i) '_color.png']);
        img_depth = load([data_dir num2str(i) '_rawdepth.dmap']);
    catch me
        continue;
    end
    imgsavefn = [data_dir num2str(i) '_depthnew.png'];
    datasavefn = [data_dir num2str(i) '_newdepth.dmap'];
    
    switch method
        case 'cross-bf'
            img_depth = img_depth / 1000;
            new_depth = fill_depth_cross_bf(img_rgb, img_depth);
        case 'colorization'
            img_rgb = double(img_rgb) ./ 255;
            img_depth = img_depth / 1000;
            new_depth = fill_depth_colorization(img_rgb, img_depth);
        case 'atgv'
            break;
    end
    
    imwrite(new_depth, imgsavefn);
    save_dmaps(new_depth, datasavefn);
    disp(['saved dmap: ' num2str(i)]);
    
%     figure
%     subplot(1,3,1)
%     imshow(img_rgb)
%     subplot(1,3,2)
%     imshow(img_depth)
%     subplot(1,3,3)
%     imshow(new_depth)

    
%     overlay_edge(img_rgb, img_depth, true)
%     overlay_edge(img_rgb, new_depth, true)
    
end

function edge_overlay = overlay_edge(img_rgb, img_depth, show)

% edge detection
edge_rgb = edge(rgb2gray(img_rgb), 'Canny');
edge_depth = edge(img_depth, 'Canny');

red_mask = ones([size(edge_rgb), 3]);
red_mask(:,:,1) = 255;
blue_mask = ones([size(edge_rgb), 3]);
blue_mask(:,:,2) = 255;

edge_overlay = repmat(edge_rgb, [1 1 3]) .* red_mask + repmat(edge_depth, [1 1 3]) .* blue_mask;

if show
    figure
    subplot(1,4,1)
    imshow(img_rgb)
    subplot(1,4,2)
    imshow(edge_rgb)
    subplot(1,4,3)
    imshow(img_depth, [])
    subplot(1,4,4)
    imshow(edge_depth)
    figure
    imshow(uint8(edge_overlay))
end


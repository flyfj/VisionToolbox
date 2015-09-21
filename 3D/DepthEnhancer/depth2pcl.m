function [ pts ] = depth2pcl( img_depth_mm, type, vectorize )
%DEPTH2PCL Summary of this function goes here
%   Detailed explanation goes here

switch type
    case 'Kinect1'
        focal = 525.0;
        sz = [640 480];
    case 'Kinect2'
        focal = 366.154;
        sz = [512 424];
end

[h, w] = size(img_depth_mm);

if ~vectorize
    pts = zeros(h, w, 3);
    cnt = 1;
    for r=1:h
        for c=1:w
            if img_depth_mm(r,c) ~= 0
                pts(r,c,1) = (c-w/2)*img_depth_mm(r,c) / focal / 1000;
                pts(r,c,2) = (r-h/2)*img_depth_mm(r,c) / focal / 1000;
                pts(r,c,3) = img_depth_mm(r,c) / 1000;
            end
            cnt = cnt + 1;
        end
    end
else
    pts = zeros(w*h, 3);
    cnt = 1;
    for r=1:h
        for c=1:w
            if img_depth_mm(r,c) ~= 0
                pts(cnt,1) = (c-w/2)*img_depth_mm(r,c) / focal / 1000;
                pts(cnt,2) = (r-h/2)*img_depth_mm(r,c) / focal / 1000;
                pts(cnt,3) = img_depth_mm(r,c) / 1000;
            end
            cnt = cnt + 1;
        end
    end
end


end


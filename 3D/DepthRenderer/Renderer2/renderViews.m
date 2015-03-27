function renderViews(offfn, outpath) 
% render an off file into depth maps
% the generated files are put in the folder prefix
% output file names look like bottle_000000856.obj_19_reverse.png, where the .obj part is the name of the 3d model.
% of course, you need to use off here, which is even more convenient for ModelNet

if ~exist('outpath', 'var'); outpath = '.'; end
if ~exist('offfn', 'var'); offfn = 'chair000009.off'; end
if exist(outpath, 'file'); return; end


divide1 = 15;
divide2 = 15;
divide3 = 15;
new_sz = [64 64];
% save image pixels into a mat file
% data field is for image pixels; pose field is for angles
depth_mat.data = zeros(divide1*divide2*divide3, new_sz(1)*new_sz(2));
depth_mat.pose = zeros(divide1*divide2*divide3, 3);
% loop through different rotation angles
xzrots = linspace(-pi, pi, divide1); xzrotlen = length(xzrots);
% yzrots = [0]; yzrotlen = 1;
yzrots = linspace(-pi / 2, pi / 2, divide2); yzrotlen = length(yzrots);
rot2ds = linspace(0, 360, divide3); rot2dlen = length(rot2ds);
for xzroti = 1: xzrotlen
    for yzroti = 1: yzrotlen
        %fprintf('xzroti = %d, yzroti = %d, \nxzrot = %f\n \nyzrots = %f\n', ...
            %xzroti, yzroti, xzrots(xzroti), yzrots(yzroti));
        depth = off2im(offfn, 2, xzrots(xzroti), yzrots(yzroti));
        % normalization
        if size(depth,1)*size(depth,2) == 0
            continue;
        end
        depth = depth - min(depth(:));
        depth = 1 - depth / max(depth(:));
        [~, fnwoext, ~] = fileparts(offfn);
        for rot2di = 1: rot2dlen
            count = (xzroti - 1) * yzrotlen * rot2dlen + (yzroti - 1) * rot2dlen + rot2di; 
            depth2 = imrotate(depth, rot2ds(rot2di), 'loose');
            depth2 = autocrop(depth2);
            depth2 = imresize(depth2, new_sz);
            depth2 = mat2gray(depth2);
            %save_fn = sprintf('%s/%s__%d.png', outpath, fnwoext, count);
            depth_mat.data(count, :) = depth2(:);
            depth_mat.pose(count, :) = [xzrots(xzroti) yzrots(yzroti) rot2ds(rot2di)];
%             imwrite(depth2, save_fn);
            fprintf('%s %d\n', fnwoext, count);
        end
    end
end

% save to mat
save(outpath, 'depth_mat');

end

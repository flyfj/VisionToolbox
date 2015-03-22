function renderViews(offfn, outpath) 
% render an off file into depth maps
% the generated files are put in the folder prefix
% output file names look like bottle_000000856.obj_19_reverse.png, where the .obj part is the name of the 3d model.
% of course, you need to use off here, which is even more convenient for ModelNet

if ~exist('outpath', 'var'); outpath = '.'; end
if ~exist('offfn', 'var'); offfn = 'chair000009.off'; end
% parallel stuffs
p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p); parpool('local'); end
divide1 = 20;
divide2 = 20;
divide3 = 20;
% loop through different rotation angles
xzrots = linspace(-pi, pi, divide1); xzrotlen = length(xzrots);
% yzrots = [0]; yzrotlen = 1;
yzrots = linspace(-pi / 2, pi / 2, divide2); yzrotlen = length(yzrots);
rot2ds = linspace(0, 360, divide3); rot2dlen = length(rot2ds);
parfor xzroti = 1: xzrotlen
    for yzroti = 1: yzrotlen
        %fprintf('xzroti = %d, yzroti = %d, \nxzrot = %f\n \nyzrots = %f\n', ...
            %xzroti, yzroti, xzrots(xzroti), yzrots(yzroti));
        depth = off2im(offfn, 2, xzrots(xzroti), yzrots(yzroti));
        % normalization
        depth = depth - min(depth(:));
        depth = 1 - depth / max(depth(:));
        [~, fnwoext, ~] = fileparts(offfn);
        for rot2di = 1: rot2dlen
            count = (xzroti - 1) * yzrotlen * rot2dlen + (yzroti - 1) * rot2dlen + rot2di; 
            depth2 = imrotate(depth, rot2ds(rot2di), 'loose');
            depth2 = autocrop(depth2);
            depth2 = imresize(depth2, [28, 28]);
            imwrite(depth2, sprintf('%s/%s__%d.png', outpath, fnwoext, count));
            fprintf('%s %d\n', fnwoext, count);
        end
    end
end

end

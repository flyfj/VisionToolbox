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
% loop through different rotation angles
xzrots = linspace(-pi*2, pi*2, 10); xzrotlen = length(xzrots);
% yzrots = [0]; yzrotlen = 1;
yzrots = linspace(-pi*2, pi*2, 10); yzrotlen = length(yzrots);
parfor xzroti = 1: xzrotlen
    for yzroti = 1: yzrotlen
        count = (xzroti - 1) * yzrotlen + yzroti; 
        depth = off2im(offfn, 2, xzrots(xzroti), yzrots(yzroti));
        % normalization
        % treat maximum value as invalid
        sort_dmap = sort(depth(:), 'descend');
        if length(sort_dmap) < 2
            continue;
        end
        depth(depth==sort_dmap(1)) = 0;
        depth = depth / sort_dmap(2);
        % form save file: catename__objname__viewnum.png
        parts = strsplit(offfn, '/');
        %[~, fnwoext, ~] = fileparts(offfn);
        save_fn = sprintf('%s/%s__%s__%d.png', outpath, parts{length(parts)-2}, parts{length(parts)-1}, count);
        if exist(save_fn, 'file')
            continue;
        end
        imwrite(depth, save_fn);
    end
end

end
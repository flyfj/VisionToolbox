outdir = '/mnt/hgfs/DataHouse/3D/ModelNet/test_db_depth/';
indir = '/mnt/hgfs/DataHouse/3D/ModelNet/full/';
fns = arrayfun(@(x)([indir, '/', x.name]), dir([indir, '/*.off']), 'UniformOutput', false);

for i = 1: length(fns)
    fn = fns{i};
    renderViews(fn, outdir);
end

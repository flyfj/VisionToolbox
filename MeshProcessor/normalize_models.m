

model_dir = 'F:\src\models\ModelNetUpsampled\';
save_dir = 'F:\src\models\modelnet_normalized\';

fns = dir([model_dir '*.obj']);
[m, n] = size(fns);

parfor i=1:m
    curfn = [model_dir fns(i).name];
    curmodel = read_wobj(curfn);
    % center
    meanv = mean(curmodel.vertices, 1);
    curmodel.vertices = curmodel.vertices - repmat(meanv, size(curmodel.vertices, 1), 1);
    % normalize, divide max vertex norm
    vertex_norms = sqrt(sum(curmodel.vertices.^2, 2));
    max_norm = max(vertex_norms);
    curmodel.vertices = curmodel.vertices ./ max_norm;
    % save back
    savefn = [save_dir fns(i).name];
    write_wobj(curmodel, savefn);
    disp(['processed ' curfn]);
end
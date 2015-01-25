
addpath('../obj_toolbox/');

model_file = 'F:\3D\ModelNet\model_list.txt';
model_dir = 'f:\3D\ModelNet\full\';
save_dir = 'F:\3D\ModelNet\full_normalized\';

fns = importdata(model_file);
[m, n] = size(fns);

parfor i=1:m
    curfn = [model_dir fns{i,1} '.obj'];
    if(exist(curfn, 'file') == 0)
        continue;
    end
    curmodel = read_wobj(curfn);
    % center
    meanv = mean(curmodel.vertices, 1);
    curmodel.vertices = curmodel.vertices - repmat(meanv, size(curmodel.vertices, 1), 1);
    % normalize, divide max vertex norm
    vertex_norms = sqrt(sum(curmodel.vertices.^2, 2));
    max_norm = max(vertex_norms);
    curmodel.vertices = curmodel.vertices ./ max_norm;
    % save back
    savefn = [model_dir fns{i,1} '_norm.obj'];
    write_wobj(curmodel, savefn);
    
    disp(['processed ' curfn]);
end
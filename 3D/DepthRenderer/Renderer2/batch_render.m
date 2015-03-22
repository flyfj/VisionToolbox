
% batch render depth views from models
data_root = '/mnt/hgfs/DataHouse/3D/ModelNet/full/';
res_dir = '/mnt/hgfs/DataHouse/3D/ModelNet/test_db_depth/';
model_list = 'model_list_nonempty.txt';

mkdir(res_dir)

fns = importdata(model_list);
[m,n] = size(fns);

for i=29:length(fns)
    % create folder for current object views
    cur_model_fn = [data_root fns{i}];
    parts = strsplit(cur_model_fn, '/');
    cur_res_dir = [res_dir parts{8} '__' parts{9} '/'];
    mkdir(cur_res_dir);
    % render
    renderViews(cur_model_fn, cur_res_dir);
    disp([num2str(i) '/' num2str(m)]);
end

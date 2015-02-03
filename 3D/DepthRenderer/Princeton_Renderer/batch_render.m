
% batch render depth views from models
data_root = '/mnt/hgfs/DataHouse/3D/ModelNet/full/';
res_dir = '/mnt/hgfs/DataHouse/3D/ModelNet/test_db_depth2/';
model_list = 'model_list_nonempty.txt';

fns = importdata(model_list);
[m,n] = size(fns);

for i=1:m
    cur_model_fn = [data_root fns{i}];
    renderViews(cur_model_fn, res_dir);
    disp([num2str(i) '/' num2str(m)]);
end


% batch render depth views from models
data_root = '/mnt/hgfs/DataHouse/3D/ModelNet/full/';
res_dir = '/mnt/hgfs/DataHouse/3D/ModelNet/test_db_depth_all/';
model_list = 'model_list_100_nonempty.txt';

mkdir(res_dir)

fns = importdata(model_list);
[m,n] = size(fns);

% parallel stuffs
p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p); parpool('local'); end

parfor i=1:length(fns)
    % create folder for current object views
    cur_model_fn = [data_root fns{i}];
    parts = strsplit(cur_model_fn, '/');
    %cur_res_dir = [res_dir parts{8} '__' parts{9} '/'];
    %mkdir(cur_res_dir);
    % render
    save_fn = [res_dir parts{8} '__' parts{9} '.mat'];
    renderViews(cur_model_fn, save_fn);
    disp([num2str(i) '/' num2str(m)]);
end

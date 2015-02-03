
import os

root = 'F:/3D/ModelNet/test_db_depth/'
save_fn = 'E:/Projects/Github/dnn_jie/caffe/examples/modelnet_depth/train_files.txt'
prefix = '/mnt/hgfs/DataHouse/3D/ModelNet/test_db_depth/'

dmapfns = os.listdir(root)

with open(save_fn, 'w') as f:
    cls_id = 0
    name_mapper = {}
    for fn in dmapfns:
        parts = fn.split('__')
        cate_name = parts[0]
        if cate_name not in name_mapper:
            name_mapper[cate_name] = cls_id
            cls_id += 1
        f.write(prefix + fn + ' ' + str(name_mapper[cate_name]) + '\n')

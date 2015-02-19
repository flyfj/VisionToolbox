
import os
import random

root = 'F:/3D/ModelNet/test_db_depth2/'
train_fn = 'E:/Projects/Github/dnn_jie/caffe_tasks/modelnet_depth/train_files.txt'
test_fn = 'E:/Projects/Github/dnn_jie/caffe_tasks/modelnet_depth/test_files.txt'
prefix = '/mnt/hgfs/DataHouse/3D/ModelNet/test_db_depth2/'


dmapfns = os.listdir(root)

# organize all files
cate_fns = {}
for fn in dmapfns:
    parts = fn.split('__')
    cate_name = parts[0]
    if cate_name not in cate_fns:
        cate_fns[cate_name] = [fn]
    else:
        cate_fns[cate_name].append(fn)

# create train and test file list
with open(train_fn, 'w') as train_out:
    with open(test_fn, 'w') as test_out:
        cnt = -1
        for cate, fns in cate_fns.iteritems():
            cnt += 1
            random.shuffle(fns)
            for i in range(0, len(fns)):
                if i < len(fns)*0.8:
                    train_out.write(prefix + fns[i] + ' ' + str(cnt) + '\n')
                else:
                    test_out.write(prefix + fns[i] + ' ' + str(cnt) + '\n')

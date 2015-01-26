
import os
import glob

root = 'F:/3D/ModelNet/full_depth/'
save_fn = 'F:/3D/ModelNet/depth_view_list.txt'

fns = os.listdir(root)
with open(save_fn, 'w') as f:
    for cate in fns:
        cur_cate_path = root + cate + '/'
        objs = os.listdir(cur_cate_path)
        for obj in objs:
            obj_dir = cur_cate_path + obj + '/'
            views = os.listdir(obj_dir)
            for view in views:
                if os.path.splitext(view)[1] == '.jpg':
                    continue
                f.write(obj_dir + view + '\n')
            print 'finish ', obj
        print 'finish ', cate

print 'done'
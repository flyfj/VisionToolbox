# select subset from modelnet

'''
1. randomly pick 150 categories
2. for each category, randomly pick 10 objects
3. for each object, synthesize 7x7x7 depth views
'''

import os
import random
import math

model_root = 'F:/3D/ModelNet/full/'

# get all categories
cates = os.listdir(model_root)
print 'total category number: ', len(cates)

# select categories
sel_cate_num = 150
sel_cate_ids = random.sample(range(len(cates)), sel_cate_num)
print sel_cate_ids

sel_obj_num = 10
with open('model_list_nonempty.txt', 'w') as file:
    # select objects and save to file
    for cate_id in sel_cate_ids:
        cur_cate_name = cates[cate_id]
        cur_dir = model_root + cur_cate_name + '/'
        cur_objs = os.listdir(cur_dir)
        random.shuffle(cur_objs)
        valid_num = 0
        for idx in range(len(cur_objs)):
            # check if model file exists and is non-empty
            sel_obj_fn = cur_cate_name + '/' + cur_objs[idx] + '/' + cur_objs[idx]
            model_fn = model_root + sel_obj_fn + '.off'
            try:
                if os.path.getsize(model_fn) > 0:
                    file.write(sel_obj_fn + '\n')
                    valid_num += 1
                    if valid_num == sel_obj_num:
                        break
            except Exception:
                pass
    
        print 'finished ' + cur_cate_name

print 'done'
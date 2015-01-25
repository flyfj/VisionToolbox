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
with open('model_list.txt', 'w') as file:
    # select objects and save to file
    for cate_id in sel_cate_ids:
        cur_cate_name = cates[cate_id]
        cur_dir = model_root + cur_cate_name + '/'
        cur_objs = os.listdir(cur_dir)
        sel_obj_ids = random.sample(range(len(cur_objs)), min(len(cur_objs), sel_obj_num))
        for obj_id in sel_obj_ids:
            sel_obj_fn = cur_cate_name + '/' + cur_objs[obj_id] + '/' + cur_objs[obj_id]
            file.write(sel_obj_fn + '\n')
        print 'finished ' + cur_cate_name

print 'done'
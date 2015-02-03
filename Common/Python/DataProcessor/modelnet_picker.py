# select subset from downloaded modelnet models

'''
1. randomly pick 150 categories
2. for each category, randomly pick 10 objects
3. for each object, synthesize 7x7x7 depth views
'''

import os
import random
import math

model_root = 'F:/3D/ModelNet/full/'
subset_root = 'f:/3D/ModelNet/test_db_2/'

sel_cate_list = ['bowl', 'banana', 'box', 'mug', 'cup', 'keyboard', 'coffee_cup']

# get all categories
cates = os.listdir(model_root)
print 'total category number: ', len(cates)

# select categories
sel_cate_num = 46
random.shuffle(cates)
for cur_cate in cates:
    if cur_cate not in sel_cate_list:
        sel_cate_list.append(cur_cate)
        if len(sel_cate_list) == sel_cate_num:
            break

sel_obj_num = 20
with open('model_list_nonempty.txt', 'w') as file:
    # select objects and save to file
    for cur_cate_name in sel_cate_list:
        cur_dir = model_root + cur_cate_name + '/'
        # list all objects
        cur_objs = os.listdir(cur_dir)
        random.shuffle(cur_objs)
        valid_num = 0
        for cur_obj in cur_objs:
            # check if model file exists and is non-empty
            sel_obj_fn = cur_cate_name + '/' + cur_obj
            model_fn = model_root + sel_obj_fn + '/' + cur_obj + '.off'
            try:
                if os.path.getsize(model_fn) > 0:
                    write_obj_fn = sel_obj_fn + '/' + cur_obj + '.off'
                    file.write(write_obj_fn + '\n')
                    valid_num += 1
                    if valid_num == sel_obj_num:
                        break
            except Exception:
                pass
    
        print 'finished ' + cur_cate_name

print 'done'
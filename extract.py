import os
import re

path = '/root/second.pytorch/second/train_loss.txt'
path_w = '/root/second.pytorch/second/csv_loss.csv'

i=0
with open(path) as log:
    lines = log.readlines()

if not os.path.isfile(path_w):
    with open(path_w, mode='w') as f:
        f.write('step,cls_loss,loc_loss'+'\n')
else:
    with open(path_w, mode='a') as f:
        f.write('step,cls_loss,loc_loss'+'\n')
        for line in lines:
            step = re.findall('step=*(\d+)',line)
            cls_loss = re.findall('cls_loss=*(\d+)',line)
            loc_loss = re.findall('loc_loss=*(\d+)',line)
            print(line,len(step))
            if step or cls_loss or loc_loss:
                f.write(step[i] + ',' + cls_loss[i] + ',' + loc_loss[i] + '\n')
                i=i+1
log.close()
f.close()
~             

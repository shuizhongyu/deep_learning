# coding=utf-8
# 训练样本和检验样本生成脚本F:\deeplearning_image\code\darknet-master\darknet-master\data\VOCtrainval_06-Nov-2007\VOCdevkit\VOC2007\JPEGImages
# 这个小脚本是用来打开图片文件所在文件夹，随机抽取90%用于训练的图片的名称保存在tain_num.txt，其余的用于验证的图片保存在val_num.txt

import os
import numpy as np
import random
from random import choice
from os import listdir, getcwd
from os.path import join

if __name__ == '__main__':
    source_folder = '/userhome/darknet/data/VOC2018/JPEGImages/'  # 地址是所有图片的保存地点
    dest = '/userhome/darknet/data/VOC2018/ImageSets/Segmentation/train_num.txt'  # 保存train.txt的地址
    dest2 = '/userhome/darknet/data/VOC2018/ImageSets/Segmentation/val_num.txt'  # 保存val.txt的地址
    file_list = os.listdir(source_folder)  # 赋值图片所在文件夹的文件列表
    train_file = open(dest, 'a')  # 打开文件
    val_file = open(dest2, 'a')  # 打开文件
    file_list1 = random.sample(file_list, round(1.0* len(file_list)))
    file_list2 = list(set(file_list).difference(set(file_list1)))

    for file_obj in file_list1:  # 访问文件列表中的每一个文件
        file_path = os.path.join(source_folder, file_obj)
        # file_path保存每一个文件的完整路径
        file_name, file_extend = os.path.splitext(file_obj)
        # file_name 保存文件的名字，file_extend保存文件扩展名
        #file_num = int(file_name)
        train_file.write(file_name + '\n')  # 

    for file_obj in file_list2:
        file_path = os.path.join(source_folder, file_obj)
        # file_path保存每一个文件的完整路径
        file_name, file_extend = os.path.splitext(file_obj)
        # file_name 保存文件的名字，file_extend保存文件扩展名
        #file_num = int(file_name)
        val_file.write(file_name + '\n')  # 其余的文件保存在val.txt里面

    train_file.close()  # 关闭文件
    val_file.close()

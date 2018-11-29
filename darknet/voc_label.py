# coding:utf-8
import xml.etree.ElementTree as ET
import pickle
import os
from os import listdir, getcwd
from os.path import join

classes = ["p", "u"]

def convert(size, box):
    dw = 1./size[0]
    dh = 1./size[1]
    x = (box[0] + box[1])/2.0
    y = (box[2] + box[3])/2.0
    w = box[1] - box[0]
    h = box[3] - box[2]
    x = x*dw
    w = w*dw
    y = y*dh
    h = h*dh
    return (x,y,w,h)

def convert_annotation(image_id):
    in_file = open('/userhome/darknet/data/VOC2018/Annotations/%s.xml'%(image_id),errors='ignore')
    out_file = open('/userhome/darknet/data/VOC2018/labels/%s.txt'%(image_id),'w')
    tree=ET.parse(in_file)
    root = tree.getroot()
    size = root.find('size')
    w = int(size.find('width').text)
    h = int(size.find('height').text)

    for obj in root.iter('object'):
        difficult = obj.find('difficult').text
        cls = obj.find('name').text
        if cls not in classes or int(difficult) == 1:
            continue
        cls_id = classes.index(cls)
        xmlbox = obj.find('bndbox')
        b = (float(xmlbox.find('xmin').text), float(xmlbox.find('xmax').text), float(xmlbox.find('ymin').text), float(xmlbox.find('ymax').text))
        bb = convert((w,h), b)
        out_file.write(str(cls_id) + " " + " ".join([str(a) for a in bb]) + '\n')

wd = getcwd()

image_ids = open('/userhome/darknet/data/VOC2018/ImageSets/Segmentation/train_num.txt').read().strip().split()  #如果是训练集数据打开这一行，注释下一行
#image_ids = open('F:/darknet/darknet-master/darknet-master/build/darknet/x64/data/VOC2018/ImageSets/Segmentation/val_num.txt').read().strip().split()  #如果是验证数据集数据打开这一行，注释上一行

list_file = open('/userhome/darknet/data/VOC2018/ImageSets/Segmentation/train_path.txt', 'w')     #把结果写入到indrared_train.txt文件中，如果是训练集数据打开这一行，注释下一行
#list_file = open('F:/darknet/darknet-master/darknet-master/build/darknet/x64/data/VOC2018/ImageSets/Segmentation/val_path.txt', 'w')     #把结果写入到indrared_train.txt文件中，如果是验证数据集数据打开这一行，注释上一行

for image_id in image_ids:
    list_file.write('/userhome/darknet/data/VOC2018/JPEGImages/%s.jpg\n'%(image_id))  #把每一用于训练或验证的图片的完整的路径写入到train.txt中  这个文件会被voc.data yolo.c调用
    convert_annotation(image_id)   #把图片的名称id传给函数，用于把此图片对应的xml中的数据转换成yolo要求的txt格式
list_file.close() #关闭文件




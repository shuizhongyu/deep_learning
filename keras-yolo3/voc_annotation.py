import xml.etree.ElementTree as ET
from os import getcwd

sets=[('2007', 'train'), ('2007', 'val'), ('2007', 'test')]

#classes = ["aeroplane", "bicycle", "bird", "boat", "bottle", "bus", "car", "cat", "chair", "cow", "diningtable", "dog", "horse", "motorbike", "person", "pottedplant", "sheep", "sofa", "train", "tvmonitor"]
classes = ["p","u"]


##编码不对,会导致读xml错误
#import sys
#import imp
#imp.reload(sys)

def convert_annotation(image_id, list_file):
    in_file = open('./data/VOC2018/Annotations/%s.xml'%(image_id),encoding='UTF-8')
    #中文识别有问题,xml中有中文,为utf-8编码,这里却是ascii解析
    tree=ET.parse(in_file)
    root = tree.getroot()

    for obj in root.iter('object'):
        difficult = obj.find('difficult').text
        cls = obj.find('name').text
        if cls not in classes or int(difficult)==1:
            continue
        cls_id = classes.index(cls)
        xmlbox = obj.find('bndbox')
        b = (int(xmlbox.find('xmin').text), int(xmlbox.find('ymin').text), int(xmlbox.find('xmax').text), int(xmlbox.find('ymax').text))
        list_file.write(" " + ",".join([str(a) for a in b]) + ',' + str(cls_id))




wd = getcwd()

#for year, image_set in sets:
#    image_ids = open('VOCdevkit/VOC%s/ImageSets/Main/%s.txt'%(year, image_set)).read().strip().split()
#    list_file = open('%s_%s.txt'%(year, image_set), 'w')
#    for image_id in image_ids:
#        list_file.write('%s/VOCdevkit/VOC%s/JPEGImages/%s.jpg'%(wd, year, image_id))
#        convert_annotation(year, image_id, list_file)
#        list_file.write('\n')
#    list_file.close()

image_ids = open('/userhome/keras-yolo3/data/VOC2018/ImageSets/Main/train_num.txt')
list_file = open('/userhome/keras-yolo3/data/VOC2018/ImageSets/Main/train_path.txt', 'w')
for image_id in image_ids:
    #image_id中有\n,需要过滤
    #print(image_id)
    image_id=image_id[:-1]
    list_file.write('/userhome/keras-yolo3/data/VOC2018/JPEGImages/%s.jpg'%(image_id))
    convert_annotation(image_id, list_file)
    list_file.write('\n')
list_file.close()


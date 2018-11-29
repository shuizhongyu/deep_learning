from voc_eval_py3 import voc_eval

rec,prec,ap = voc_eval('/userhome/darknet/results/comp4_det_test_p.txt', '/userhome/darknet/data/VOC2018/Annotations/{}.xml', '/userhome/darknet/data/VOC2018/ImageSets/Segmentation/val_num.txt', 'p', '.')
print('rec',rec)
print('prec',prec)
print('ap',ap)

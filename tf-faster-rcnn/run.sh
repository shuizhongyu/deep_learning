#!/bin/bash

set -e

#apt-get install -y time
#apt-get -y install python3.6-tk
#pip install easydict
dpkg -i /userhome/deb/*deb
pip install /userhome/deb/easydict-1.8.tar.gz


cd /userhome/tf-faster-rcnn-master
./experiments/scripts/train_faster_rcnn.sh 0 pascal_voc vgg16 >log1 2>&1 
#nohup /userhome/tf-faster-rcnn-master/experiments/scripts/train_faster_rcnn.sh 0 pascal_voc vgg16 & 2>&1 >log1

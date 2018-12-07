set -e

#apt-get install -y time
#pip install easydict
#apt-get -y install python3.6-tk
dpkg -i /userhome/deb/*deb
pip install /userhome/deb/easydict-1.8.tar.gz


cd /userhome/tf-faster-rcnn-master
./experiments/scripts/test_faster_rcnn.sh 0 pascal_voc vgg16 2>&1 >log_test
#nohup /userhome/tf-faster-rcnn-master/experiments/scripts/train_faster_rcnn.sh 0 pascal_voc vgg16 & 2>&1 >log1

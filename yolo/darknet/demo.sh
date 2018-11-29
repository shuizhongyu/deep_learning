#!/bin/bash

#================================================================
#   Copyright (C) 2018 Sangfor Ltd. All rights reserved.
#
#   filename：demo.sh
#   author：ljx (jiaxinustc#gmail.com)
#   date：2018.11.29
#   description：
#
#================================================================

#name=99 #jpgname="ODF_test_"$name".jpg"
#./darknet detector test cfg/port_data.data cfg/yolov3_port.cfg backup/yolov3_port.backup data/TEST/$jpgname
#mv predictions.jpg "test_result/predictions"$name".jpg"
cd /userhome/darknet-test

for file in ./data/TEST/*;do
    ./darknet detector test cfg/port_data.data cfg/yolov3_port.cfg backup/yolov3_port.backup $file
    file2=`echo $file|tr -d -c '0-9'`
    mv predictions.jpg "test_result/odf/predictions"$file2".jpg"
done


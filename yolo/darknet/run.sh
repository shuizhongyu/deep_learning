#!/bin/sh
#/userhome/darknet/darknet detector train /userhome/darknet/cfg/port_data.data /userhome/darknet/cfg/yolov3_port.cfg /userhome/darknet/weights/darknet53.conv.74  > /userhome/darknet/sysout2.log
/userhome/darknet/darknet detector train /userhome/darknet/cfg/port_data.data /userhome/darknet/cfg/yolov3_port.cfg /userhome/darknet/backup/yolov3_port.backup  -gpus 0,1  >/userhome/darknet/sysout3.log 2>&1

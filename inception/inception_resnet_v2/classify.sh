#!/bin/bash
##将测试图片分类
#
##BOX
#cat box.csv |awk '$3>0.5{printf("%s \n",$1)}' | awk '{printf("cp %s ../test2_result/box/yes \n",$1)}' |bash
#cat box.csv |awk '$3<0.5{printf("%s \n",$1)}' | awk '{printf("cp %s ../test2_result/box/no \n",$1)}' |bash
#
###QR
#cat qr.csv |awk '$5>0.5{printf("%s \n",$1)}' | awk '{printf("cp %s ../test2_result/qr/yes \n",$1)}' |bash
#cat qr.csv |awk '$5<0.5{printf("%s \n",$1)}' | awk '{printf("cp %s ../test2_result/qr/no \n",$1)}' |bash
#
###hat
#cat hat.csv |awk '$7>$3&&$7>$5{printf("%s \n",$1)}' | awk '{printf("cp %s ../test2_result/hat/yes \n",$1)}' |bash
#cat hat.csv |awk '$3>$5&&$3>$7{printf("%s \n",$1)}' | awk '{printf("cp %s ../test2_result/hat/no \n",$1)}' |bash
#cat hat.csv |awk '$5>$3&&$5>$7{printf("%s \n",$1)}' | awk '{printf("cp %s ../test2_result/hat/other \n",$1)}' |bash

##line
cat line.csv |awk '$7>$3&&$7>$5{printf("%s \n",$1)}' | awk '{printf("cp %s ../test2_result/line/other \n",$1)}' |bash
cat line.csv |awk '$3>$5&&$3>$7{printf("%s \n",$1)}' | awk '{printf("cp %s ../test2_result/line/no \n",$1)}' |bash
cat line.csv |awk '$5>$3&&$5>$7{printf("%s \n",$1)}' | awk '{printf("cp %s ../test2_result/line/yes \n",$1)}' |bash

##hole
#cat hole.csv |awk '$3>0.5{printf("%s \n",$1)}' | awk '{printf("cp %s ../test2_result/hole/yes \n",$1)}' |bash
#cat hole.csv |awk '$3<0.5{printf("%s \n",$1)}' | awk '{printf("cp %s ../test2_result/hole/no \n",$1)}' |bash

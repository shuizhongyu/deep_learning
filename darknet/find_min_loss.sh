#!/bin/bash
#for darknet output

cat $1 |grep images|tail -n 20
cat $1 |grep images|awk '{printf("%s",$2)}'|tr "," "\n"|sort -n|head -n 10

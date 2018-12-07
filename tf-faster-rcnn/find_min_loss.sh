#!/bin/bash

cat $1|grep "loss:"|tail -n 10

cat $1|grep "loss:"|awk '{printf("%s\n",$7)}'|sort -n |head -n 10

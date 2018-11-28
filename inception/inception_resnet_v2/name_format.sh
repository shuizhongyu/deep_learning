#!/bin/bash

#纠正训练图片命名错误
#主要是空格和中文命名
#中文命名删除，空格改为下划线


echo $1

#show
#find $1 -name "* *"

#rm
find $1 -name "* *"|
while read name;do
        na=$(echo $name | tr ' ' '_')
        mv "$name" $na
done

#show
#find $1 |grep [^0-9a-zA-Z.\/\(\)._]
#rm
#find $1 |grep [^0-9a-zA-Z.\/\(\)._] | xargs rm

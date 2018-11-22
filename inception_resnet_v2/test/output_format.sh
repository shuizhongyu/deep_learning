#!/bin/bash
file=$1

cp $file $file"_bak"
sed -i s/{//g $file
sed -i s/}//g $file
sed -i s/:/,/g $file


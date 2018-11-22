#!/bin/bash


for jpg in `cat temp`;
do
        file $jpg | grep  -v JPEG
done


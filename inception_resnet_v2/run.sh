#!/bin/bash


cd this_dir
#python main.py >log1 2>&1
python3 main.py |tee log

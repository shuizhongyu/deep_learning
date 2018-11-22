#!/bin/bash
#使用训练好的模型对各个类别的训练图片进行测试，结果写到各个csv文件中


box:
	-rm model/model.pb
	ln -s /data/zhuangwei-zhijian/classification/test/script/model/box.pb model/model.pb
	sed -i "71c \ \ \ \ craterDir = \"/data/zhuangwei-zhijian/classification/test/test2/\"" test_interface.py
	-python3 test_interface.py > /dev/null
	cat output.csv | tr -d "[{}]"|tr ":" " "|tr "," " " > box.csv
	#cat box.csv | awk '$5<0.5{printf("cp %s ../box/\n",$1)}' | bash
qr:	
	rm model/model.pb
	ln -s /data/zhuangwei-zhijian/classification/test/script/model/qr.pb model/model.pb
	sed -i "71c \ \ \ \ craterDir = \"/data/zhuangwei-zhijian/classification/test/test2/\"" test_interface.py
	-python3 test_interface.py > /dev/null
	cat output.csv | tr -d "[{}]"|tr ":" " " |tr "," " "> qr.csv 
	#cat qr.csv | awk '$5>0.5{printf("cp %s ../qr/\n",$1)}' | bash
hat:	
	rm model/model.pb
	ln -s /data/zhuangwei-zhijian/classification/test/script/model/hat.pb model/model.pb
	sed -i "71c \ \ \ \ craterDir = \"/data/zhuangwei-zhijian/classification/test/test2/\"" test_interface.py
	sed -i "28c model_class = 3" predict.py
	sed -i "295c keywords_1 = [u'no',u'yes',u'other']" predict.py
	-python3 test_interface.py > /dev/null
	cat output.csv | tr -d "[{}]"|tr ":" " " |tr "," " "> hat.csv 
	sed -i "28c model_class = 2" predict.py
	sed -i "295c keywords_1 = [u'no',u'yes']" predict.py
line:	
	rm model/model.pb
	ln -s /data/zhuangwei-zhijian/classification/test/script/model/line.pb model/model.pb
	sed -i "71c \ \ \ \ craterDir = \"/data/zhuangwei-zhijian/classification/test/test2/\"" test_interface.py
	sed -i "28c model_class = 3" predict.py
	sed -i "295c keywords_1 = [u'no',u'yes',u'other']" predict.py
	-python3 test_interface.py > /dev/null
	cat output.csv | tr -d "[{}]"|tr ":" " " |tr "," " "> line.csv 
	sed -i "28c model_class = 2" predict.py
	sed -i "295c keywords_1 = [u'no',u'yes']" predict.py
	#cat line.csv | awk '$5>0.5{printf("cp %s ../line/\n",$1)}' | bash
hole:
	rm model/model.pb
	ln -s /data/zhuangwei-zhijian/classification/test/script/model/hole.pb model/model.pb
	sed -i "71c \ \ \ \ craterDir = \"/data/zhuangwei-zhijian/classification/test/test2/\"" test_interface.py
	-python3 test_interface.py > /dev/null
	cat output.csv | tr -d "[{}]"|tr ":" " "|tr "," " " > hole.csv 
	#cat hole.csv | awk '$5<0.5{printf("cp %s ../hole/\n",$1)}' | bash
	

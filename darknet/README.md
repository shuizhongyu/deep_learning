# Darknet Yolo3

## 来源：
from [darknet](https://github.com/pjreddie/darknet) and some official illustration [here](https://pjreddie.com/darknet/yolo/)

## 环境要求

不需要额外依赖。但如果需要用到opencv或者cuda/cudnn的话，可以安装后编译，需要在Makefile中开启编译。

如下：

```
GPU=1
CUDNN=1
OPENCV=1
```

make

## 数据说明

data文件夹中数据放置格式如下图：

```
VOC2018
├── Annotations 
├── ImageSets
│   ├── Layout
│   ├── Main
│   └── Segmentation
├── JPEGImages
└── labels 
```



- Annotations 存放标注的xml文件，标注使用精灵标注工具，导出格式为Pascal Voc，可以使用[LabelImg](https://github.com/tzutalin/labelImg)导入图片和标注进行查看

- ImageSets,Layout和Main两个文件夹没用到

  - Segmentation

    存放train_num.txt  train_path.txt  val_num.txt  val_path.txt等文件

    train为训练图片，val为测试图片，num中存放图片的名称，也就是不带后缀的，path中存放图片绝对路径

-  JPEGImages存放所有的图片，图片和其对应的标注名称是一致的，即和上面的Annotations和下面的labels文件内的文件一一对应

- labels存放转换格式后的标注，darknet不直接读取Pascal Voc格式的标注，需要转换格式

  转换后每个标注的格式为：类别，x_min,y_min,x_max,y_max



## 使用方法

### 准备

1. 标注格式转换

   - create_list.py可以按比例将所有图片分为train和val，然后生成train_num.txt和val_num.txt。

     需要修改其中的图片路径和保存生成文件的地址，和train、val的生成比例。或者直接shell命令生成更方便些。

   - voc_label.py根据上面生成的train_num.txt和val_num.txt，生成相应的train_path.txt和val_path.txt，然后将与num文件中名称一一对应的xml文件转换为darknet需要的格式。

     需要修改，45行要读取的train_num.txt路径，48行要写入的train_path.txt路径，52行的图片路径，24行的xml路径，25行的转换后文件存储位置。

2. 配置文件

   - cfg/port_data.data

     设置训练的类别数，train/val_path位置，类别名称存储文件位置，训练过程模型保存位置

   - cfg/port.names

     类别名称，此处为p\nu

   - cfg/yolov3_port.cfg

     训练过程中的所有参数和模型定义，如batch，subdivisions，learning_rate等,详细的意义解释参见yolov3参数.cfg

3. 初始权重

   darknet官网提供了一份，[here](https://pjreddie.com/media/files/yolov3.weights)，这个模型是训练好的，可以识别官网例子中的狗和自行车等种类。还有tiny版的，[here](https://pjreddie.com/media/files/yolov3-tiny.weights)。

## 训练

- ```
  ./darknet detector train ./cfg/port_data.data ./cfg/yolov3_port.cfg ./backup/yolov3_port.backup  -gpus 0,1
  ```

  分别传入了上述准备的配置文件，-gpus 0,1指定使用两块gpu来训练，可灵活设置。

  训练时配合nohup或者tmux等使用更佳。

- 训练输出：

  大量输出如下：

  ```
  Region 106 Avg IOU: 0.782028, Class: 0.998756, Obj: 0.844087, No Obj: 0.022358, .5R: 0.990291, .75R: 0.718447,  count: 103
  ```

  是对图中一块区域的目标检测训练输出。

  每做完一次迭代，输出如下：

  ```
  2658: 11.018111, 11.054621 avg, 0.001000 rate, 21.578353 seconds, 680448 images
  ```

  分别代表，训练轮次，loss，avg loss，学习率，此轮训练时间，训练图片数量。

  最重要的就是loss的值，越小代表效果越好。

- 查看输出

  一般输出太多是放在log中的，利用find_min_loss.sh来查看。

  ```
  ./find_min_loss.sh log
  ```

  会显示log中有images的行数，最后20行有image的行，和所有含有images行的排序的十个最小值，供观察当前的训练进度。

## 测试

- 查看单张识别效果

  ```
  ./darknet detect cfg/yolov3.cfg yolov3.weights data/dog.jpg
  ```

  使用yolov.cfg的模型，和yolov3.weights的权重来标注dog.jpg图片，会在当前路径下生成一张predictions.jpg的文件，里面框出了识别结果。

- 查看多张识别效果统计

  - 官方方法

    ```
    ./darknet detect cfg/yolov3.cfg yolov3.weights
    ```

    而后手动输入图片路径，即可显示。

  - 脚本方法

    demo.sh实现了这一过程，本质是多个单张测试，然后将输出的predictions.jpg重命名移动到对应位置。仅适合少量图片，否则及其浪费时间，大部分执行时间在重复的加载模型。

  - 结合

    利用管道文件给第一种方法传入文件路径，生成predictions.jpg后移走再传入下一个路径，这样节省了加载模型时间，也不需要修改源代码。



## 统计

- 输出目标检测结果

    ```
    ./darknet detector valid cfg/port_data.data cfg/yolov3_port.cfg 
    backup/yolov3.weights
    ```

    识别的图片路径，即为上文提到的val_path.txt。运行后会在results文件夹中生成comp4_det_test_p.txt  									comp4_det_test_u.txt两个文件，分别代表p和u的识别结果。格式如下：

    ```
    ODF_test_67 0.999993 355.733459 424.608612 459.423584 506.037018
    图片名称	概率		x，y坐标
    ```

- 然后用comput_map.py调用voc_eval_py3脚本输出map计算结果

    ```
    python comput_map.py
    ```

    需要修改comput_map.py中的comp4_det_test_p.txt，comp4_det_test_u.txt两个文件的路径，xml标注文件的路径，和类别的名称。

    voc_eval_py3中ovthresh需要修改，当前测试设为0.3，代表预测和实际重叠面积比例超过多少时算作正确。

    示例结果如下：

    ```
    ODF:p:ap 0.890292907681  u:ap 0.946686921977
    POS:p:ap 0.625251434026  u:ap 0.830854541247  
    ZDH:p:ap 0.970187220187   u:ap 0.951054725302
    ```


## 代码说明

待续
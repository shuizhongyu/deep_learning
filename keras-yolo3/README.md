# keras-yolo3

## 环境要求

- Python 3.5.2
- Keras 2.1.5
- tensorflow 1.6.0

## 数据说明

data目录格式与darknet中相同，但对标注的要求不同，需要将图片的绝对路径写在label的第一位，后面跟着所有此图片中的标注框的坐标。通过voc_annotation.py来转换之前的标注到现所需格式。

修改voc_annotation.py,准备训练需要信息

- 修改各种路径,data/VOC2018/ImageSets/Main/train_num.txt存放图片名称

  train_path.txt为指定格式

- 解析xml文件遇到中文出错 解决:open时指定为utf-8编码

## 使用方法

### 训练

- 训练使用的权重从darknet的权重转换而来，可以是从 [YOLO website](http://pjreddie.com/darknet/yolo/)下载的初始权重，也可以是自己训练过后的权重。转换方法：

  ```
  python convert.py yolov3.cfg yolov3.weights model_data/yolo.h5
  ```

  model_data/yolo.h5即为转换后keras可以使用的权重模型。

- train.py文件中，定义了训练所需要的参数，模型位置，数据位置，分类名称和数量等等，修改合理后可进行训练。自动划分train和val集合。

  ```
  python train.py
  or
  ./run.sh
  ```

  注意类脑上训练的话，需要用10.11.3.8:5000/user-images/dlcvimg:py2735-tensorflow-torch这个镜像，默认的deepo镜像会有错误。

- 训练后的模型位置在train.py中定义，model_path变量定义，现定位于logs/000下：

  ep006-loss154.434-val_loss144.457.h5为示例名称。

  训练经过一段时间后（大概三四天），会出现这样的训练结果trained_weights_stage_1.h5，这个应该是比之前更值得一用的结果了。

### 测试

class文件存类别，anchors文件存cfg中anchors参数，可以分为video检测和image检测.

```
python yolo_video.py --model darknet_model/yolo.h5 --classes ./darknet_model/port_classed.txt --anchors ./darknet_model/yolov3_anchors.txt --image
```

上面命令初始有问题，可以全替换原位置上的文件，然后测试：

```
python yolo_video.py --image
```

然后输入图片名称，会输出p和u的概率和检测位置,输入名称太麻烦，回头修改yolo_video.py文件

### 统计











# keras-yolo3

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](LICENSE)

## Introduction

A Keras implementation of YOLOv3 (Tensorflow backend) inspired by [allanzelener/YAD2K](https://github.com/allanzelener/YAD2K).

---

## Quick Start

1. Download YOLOv3 weights from [YOLO website](http://pjreddie.com/darknet/yolo/).
2. Convert the Darknet YOLO model to a Keras model.
3. Run YOLO detection.

```
wget https://pjreddie.com/media/files/yolov3.weights
python convert.py yolov3.cfg yolov3.weights model_data/yolo.h5
python yolo_video.py [OPTIONS...] --image, for image detection mode, OR
python yolo_video.py [video_path] [output_path (optional)]
```

For Tiny YOLOv3, just do in a similar way, just specify model path and anchor path with `--model model_file` and `--anchors anchor_file`.

### Usage
Use --help to see usage of yolo_video.py:
```
usage: yolo_video.py [-h] [--model MODEL] [--anchors ANCHORS]
                     [--classes CLASSES] [--gpu_num GPU_NUM] [--image]
                     [--input] [--output]

positional arguments:
  --input        Video input path
  --output       Video output path

optional arguments:
  -h, --help         show this help message and exit
  --model MODEL      path to model weight file, default model_data/yolo.h5
  --anchors ANCHORS  path to anchor definitions, default
                     model_data/yolo_anchors.txt
  --classes CLASSES  path to class definitions, default
                     model_data/coco_classes.txt
  --gpu_num GPU_NUM  Number of GPU to use, default 1
  --image            Image detection mode, will ignore all positional arguments
```
---

4. MultiGPU usage: use `--gpu_num N` to use N GPUs. It is passed to the [Keras multi_gpu_model()](https://keras.io/utils/#multi_gpu_model).

## Training

1. Generate your own annotation file and class names file.  
    One row for one image;  
    Row format: `image_file_path box1 box2 ... boxN`;  
    Box format: `x_min,y_min,x_max,y_max,class_id` (no space).  
    For VOC dataset, try `python voc_annotation.py`  
    Here is an example:
    ```
    path/to/img1.jpg 50,100,150,200,0 30,50,200,120,3
    path/to/img2.jpg 120,300,250,600,2
    ...
    ```

2. Make sure you have run `python convert.py -w yolov3.cfg yolov3.weights model_data/yolo_weights.h5`  
    The file model_data/yolo_weights.h5 is used to load pretrained weights.

3. Modify train.py and start training.  
    `python train.py`  
    Use your trained weights or checkpoint weights with command line option `--model model_file` when using yolo_video.py
    Remember to modify class path or anchor path, with `--classes class_file` and `--anchors anchor_file`.

If you want to use original pretrained weights for YOLOv3:  
​    1. `wget https://pjreddie.com/media/files/darknet53.conv.74`  
​    2. rename it as darknet53.weights  
​    3. `python convert.py -w darknet53.cfg darknet53.weights model_data/darknet53_weights.h5`  
​    4. use model_data/darknet53_weights.h5 in train.py

---

## Some issues to know

1. The test environment is
    - Python 3.5.2
    - Keras 2.1.5
    - tensorflow 1.6.0

2. Default anchors are used. If you use your own anchors, probably some changes are needed.

3. The inference result is not totally the same as Darknet but the difference is small.

4. The speed is slower than Darknet. Replacing PIL with opencv may help a little.

5. Always load pretrained weights and freeze layers in the first stage of training. Or try Darknet training. It's OK if there is a mismatch warning.

6. The training strategy is for reference only. Adjust it according to your dataset and your goal. And add further strategy if needed.

7. For speeding up the training process with frozen layers train_bottleneck.py can be used. It will compute the bottleneck features of the frozen model first and then only trains the last layers. This makes training on CPU possible in a reasonable time. See [this](https://blog.keras.io/building-powerful-image-classification-models-using-very-little-data.html) for more information on bottleneck features.

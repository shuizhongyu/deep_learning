# inception v4

## 来源：

代码使用[train_cnn_v1](https://github.com/MachineLP/train_arch/tree/master/train_cnn_v1)修改而来，添加了对inception resnet v2的支持、数据统计等。

## 环境要求

python3

tensorflow-gpu>=1.2

## 数据说明

box，line，hole，hat，qr。

line和hat为3类，其他为两类。

## 使用方法：
### 训  练：

###### ./run.sh

通过config.py设置参数,主要参数：

sample_dir：训练集目录，目录下是分类目录，每个分类目录中存放该类别图片。

num_classes：需要分类的数量

batch_size：每一批的训练量，内存不够的话减少此值。

arch_model:选择所使用模型，目前支持arch_inception_resnet_v2和arch_inception_v4

epoch：代数，一个batch_size为一代，共训练epoch代

checkpoint_path:ckpt文件路径，初始训练采用预训练模型，从[tensorflow官方](https://github.com/tensorflow/models/tree/master/research/slim)下载，后续使用训练出的ckpt文件进行继续训练。注意需要将初始ckpt文件放置在model文件夹之外，如model_bak，否则在训练保存的模型与初始模型名称重合时，会覆盖初始文件，导致训练错误。

### 可视化：

###### python vis_cam.py

暂时没有尝试过

### 测试：

###### python test_interface.py

主要修改两处来进行批量测试，71行处的craterDir代表测试的图片目录路径，目录下要求是目录而不是图片。

28行和295行代表类别和类别的名称，类别名称会乱序，也就是最终输出的csv文件中的结果不一定是该类别，所以这里要注意顺序，暂时不知道是什么顺序。

python predict.py可以进行单张测试。

### 统计：

###### ./statistic.sh box/line/hole/qr/hat 1/2：

1是根据output.csv计算每个概率段的比例，2是根据output.csv和里面图片的正确分类文件，如box_yes,box_no，来统计查全率和查准率。

如./statistic.sh box 1输出

box.csv
0%-10%    8798  87.98%
10%-20%   67    0.67%
20%-30%   65    0.65%
30%-40%   47    0.47%
40%-50%   30    0.30%
50%-60%   36    0.36%
60%-70%   38    0.38%
70%-80%   40    0.40%
80%-90%   81    0.81%
90%-100%  798   7.98%

./statistic.sh box 2输出

其中box表格左列代表模型预测的结果，横行代表其实际结果。

box:
--   yes  no
yes  929  64
no   50   8957
yes:
precision=93.55%  recall=94.89% 
no:
precision=99.44%  recall=99.29%

### 分类：

###### Makefile & classify.sh

## 代码说明

1. lib：

   （1）model：各网络实现，除了inception v4，inception resnet v2外还有其他网络，但运行暂时有问题。

   （2）data_aug： 用于图像增强， 里边包含两种方法。

   （3）grad_cam：可视化模块

   （4）img：加载训练数据

   （5）train：构建训练

   （6）utils：图片缩放等

      (7) loss： 策略：损失函数。

   （8）optimizer： 优化方法。

2. image：

   用于存放训练数据。

3. model：
   存放训练过程中保存的模型，存储最近的五次模型。

4. pretrain：
   迁移学习中的预训练模型。可在[tensorflow官方](https://github.com/tensorflow/models/tree/master/research/slim)下载。

5. config.py文件：
   调整训练过程的参数。包括训练数据目录，batch_size，分类数量，使用的网络模型，初始的ckpt文件。

6. main.py文件：
   启动训练: python main.py

7. vis_cam.py文件：
   可视化： python vis_cam.py

8. ckpt_pb.py文件：
   ckpt转pb的，pb文件用于图片分类的测试。

9. test文件：
   用于模型的测试，使用上面的pb文件，输出为output.csv，每行为图片路径，每类名称，每类概率。

10. run.sh:

   用于运行整个训练，添加一些自己环境需要的东西。

11. Makefile,classify.sh

    分类图片

12. name_format.sh 检验图片名称，主要是名称里有空格的和中文的。

13. format_test.sh 校验图片格式，只要jpg的。

14. statistic.sh统计一些数据

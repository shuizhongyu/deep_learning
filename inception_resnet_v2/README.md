# inception v4

## 来源：

代码使用[train_cnn_v1](https://github.com/MachineLP/train_arch/tree/master/train_cnn_v1)修改而来，添加了对inception resnet v2的支持、数据统计等。

## 环境要求

python3

tensorflow>=1.2

## 使用方法：
训  练： python main.py （通过config.py设置参数）

可视化：python vis_cam.py

测试：python test_interface.py

统计：

分类：

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

2. model：
   存放训练过程中保存的模型，存储最近的五次模型。

3. pretrain：
   迁移学习中的预训练模型。可在[tensorflow官方](https://github.com/tensorflow/models/tree/master/research/slim)下载。

4. config.py文件：
   调整训练过程的参数。包括训练数据目录，batch_size，分类数量，使用的网络模型，初始的ckpt文件。

5. main.py文件：
   启动训练: python main.py

6. vis_cam.py文件：
   可视化： python vis_cam.py

7. ckpt_pb.py文件：
   ckpt转pb的，pb文件用于图片分类的测试。

8. test文件：
   用于模型的测试，使用上面的pb文件，输出为output.csv，每行为图片路径，每类名称，每类概率。

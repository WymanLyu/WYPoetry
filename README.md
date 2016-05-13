# WYPoetry
纯OC无第三方库的一个读诗APP

## 亮点

#### 封装了数据库-实现对象与表的一一映射
```
    [Objc wy_save];  // 只要对对象调用save就可以存进去了，什么都不用做就完成了建表SQL等语句
    [Objc wy_delete];  // 只要对对象调用delete就可以删除沙盒了，什么都不用做就完成了删除字段的SQL语句
    NSArray array = [Objc wy_objs];  // 这样是获取沙盒中存储了的对象
```

* 实现思路

  * 通过Runtime获取类的属性，以类名为表名，属性名位字段建表 **目标是解耦-对象和表**

  * 分装了插入删除等语句，通过在分类中给元类添加关联属性完成 **目标是轻便性-在乎存储的结果**

#### 自定义HUD-针对性的自定义HUD

```
   [WYPoemHUD show];
   [WYPoemHUD dismiss];
   ...
```

* 实现思路
  * 在窗口添加单例的View
  * Quart2D画出自己APP的图像（此处还可以做重绘动画**但是不建议耗性能**）

### 原型图

利用Axure制作该APP的原型，只制作大体线框图及页面跳转（文件已上传）

![](https://github.com/WymanLyu/WYPoetry/blob/master/gifImage/product00.png)
![](https://github.com/WymanLyu/WYPoetry/blob/master/gifImage/product01.png)

### 展示

* 可以选择自动播放

![](https://github.com/WymanLyu/WYPoetry/blob/master/gifImage/AutoScrolle.gif)

```
  实现思路：
  1.每一行都是一个Cell
  2.添加定时器执行ScrollView的滚动
```


* 截图分享功能

![](https://github.com/WymanLyu/WYPoetry/blob/master/gifImage/ClipImage.gif)

```
  实现思路：
  1.在整个View上面添加滑动手势
  2.判断手势的状态（开始-滑动-停止）
  3.记录截取的frame，通过位图上下文绘制截图
  4.添加水印（通过NSString的绘制方法）
```

* 实现数据存储功能

![](https://github.com/WymanLyu/WYPoetry/blob/master/gifImage/DB.gif)

```
  实现思路：
  1.目标是将诗歌模型存储进沙盒，则可以用归档方式
  2.由于考虑二次开发，所以选择用数据库的方式，但是数据库一系列恶心繁琐的代码实在...
  3.封装数据库，通过类与表的映射完成自动存储
```
## 其他功能

* Python爬虫获取诗歌数据（爬虫代码已上传）

有空再写了...待跟新..


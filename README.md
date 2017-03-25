
<!-- toc-->
> 上周在虎哥的直播上承诺放出调研IconFont的调研经过，周末就坚持者写完这个吧。


# 调研原因

用户在APP Store下载需要的APP，APP包体积是一个用户比较敏感的用户，过大的APP会让用户产生不良的影响，比如:占用过大的手机存储空间。下载消耗较多网络流量(即便是wifi，后续也可能因为升级过程较为缓慢，导致用户长时间不升级，造成市面上的软件版本碎片化严重)。所以减少APP体积会带来很多正面影响。

# 掌链现状

> 我们以`掌上链家APP7.7.0`举例分析: 现在在Itunes Store下载额IPA体积大约在`91.1M`，即便``公司在iOS9之后新增了`APP Slicing`功能，在我自己的iPhone 6 Plus下载的APP安装包依然达到了`81.7M`. 安装包瘦身主要包含资源瘦身和代码段瘦身，这篇文主要调研资源瘦身。

_资源的主要部分就是图片，请看下面数据_

我们把iPA解压之后里面的`Assert.car`资源包的体积大约在`34.1M` 。 使用软件导出内部的资源文件发现`3X系列的图片`大小约为`18.1M`，`2X系列的图片`大小约为`19.4M`，两份加起来大于34.1M是因为软件导出的图片部分没有后缀名默认两份都会存在。所以可以看出我们的图片还是有很大的优化空间的。

相关数据请看以下图片
 ![](http://ompeszjl2.bkt.clouddn.com/%E5%8C%85%E4%BD%93%E7%A7%AF%E4%BC%98%E5%8C%96-iconFont%E8%B0%83%E7%A0%94/01.png)
 ![](http://ompeszjl2.bkt.clouddn.com/%E5%8C%85%E4%BD%93%E7%A7%AF%E4%BC%98%E5%8C%96-iconFont%E8%B0%83%E7%A0%94/02.png)
 ![](http://ompeszjl2.bkt.clouddn.com/%E5%8C%85%E4%BD%93%E7%A7%AF%E4%BC%98%E5%8C%96-iconFont%E8%B0%83%E7%A0%94/03.png)
 ![](http://ompeszjl2.bkt.clouddn.com/%E5%8C%85%E4%BD%93%E7%A7%AF%E4%BC%98%E5%8C%96-iconFont%E8%B0%83%E7%A0%94/04.png)
 ![](http://ompeszjl2.bkt.clouddn.com/%E5%8C%85%E4%BD%93%E7%A7%AF%E4%BC%98%E5%8C%96-iconFont%E8%B0%83%E7%A0%94/05.png)


# IconFont

首先要介绍下[矢量图](http://baike.baidu.com/link?url=GFEvj353kbrZkKiMUswo32x-flN8Z8hvaxbz7zfZ3SocI9j2upeHa0WEERA18ufDt3iD7MhM3PhR1Rd3sd1Up_sNQb7Nek0DI5-94Cz5MKIyURomGbYWndlPMQpgudaa)鉴于矢量图占用尺寸小，放大不失真，我们完全可用一套图来替换iOS传统的2x和3x系列图片，不仅仅是iOS，Android平台也不用切多份图了。

## 优点

1. 减小体积，字体文件比图片要小
2. 图标保真缩放，解决2x/3x乃至将来的nx图问题
3. 方便更改颜色大小，图片复用

## 不足

适用于纯色icon 需要维护字体库

# 字体管理

既然设计到字体，我们就要制作字体，制作字体有两种办法，一种是自己手动去做比如FontForge工具，另外一种是托管到阿里的[iconfont平台](http://www.iconfont.cn/)，我们的UE做字体设计完全没有意义，可以托管给平台。 托管给平台的好处:

1. 大大的降低了接入难度
2. 更方便项目管理。和RD对接更方便

而且iconFont可以和fontForge双重使用，FontForge工具可以再压缩这个字体文件。榨干最后一滴剩余空间。

# DEMO

在[iconfont平台](http://www.iconfont.cn/)建立一个项目，随便去购买几个图标(免费的即可)， ![06](http://ompeszjl2.bkt.clouddn.com/%E5%8C%85%E4%BD%93%E7%A7%AF%E4%BC%98%E5%8C%96-iconFont%E8%B0%83%E7%A0%94/06.png),解压后的文件夹有一个字体文件，双击安装 mac和windows都有对应的工具管理字体![07](http://ompeszjl2.bkt.clouddn.com/%E5%8C%85%E4%BD%93%E7%A7%AF%E4%BC%98%E5%8C%96-iconFont%E8%B0%83%E7%A0%94/07.png)。
 近20张icon只占用了10k的资源空间，占用空间极小
 ![08](http://ompeszjl2.bkt.clouddn.com/%E5%8C%85%E4%BD%93%E7%A7%AF%E4%BC%98%E5%8C%96-iconFont%E8%B0%83%E7%A0%94/08.png)

具体的代码我们这里不再赘述，后面的demo具体展示， 不过我们要讲一讲使用的方案

1. UILabel作为Icon
2. UIButton的titleLabel作为Icon
3. 根据字体生成UIImage 鉴于将我们本来的icon当作字体使用，会让我们在项目中添加的控件方式有所变化，而且不容易控制颜色和图标大小。所以我这里推荐第三种方案。

更详细的方案是我们建立字体组件。将这一块功能单独管理，便于后期迭代和维护，而且屏蔽底层使用直接暴露出对应的图片接口可以让上层无感使用。

# 后期如何接入

## 首期工作

这里建议拿掌链下手:原因有一下几点

1. 掌链面向实际用户，做出来的效果更明显
2. 掌链的APP安装包也最大，也最有瘦身的价值
3. 掌链在经过组件化之后资源管理方式较为整齐，后期处理可以分次，灰度过度。 首期可能要麻烦UI同学，整理之前图标的对应的SVG格式，创建对应的字体库文件。工作量可能较大(约千张icon)。组件负责同学建立对应组件。 推荐的模式是可以在IconFont建立项目组，UI为owner，RD为member，方便协作和通知。

## 后期维护

待稳定后，后续迭代更加简单，只需UI同学更新对应的图标，建立新字体，然后组件管理者可以更新。 对APP安装和UI与RD业务迭代效率都有很大提高。

# CODE

文件夹见DEMO

# 参考

## UI参考

<http://www.iconfont.cn> <https://icomoon.io> <http://fontello.com> <http://fontawesome.io/icons/>

## RD参考

Android：<https://github.com/mikepenz/Android-Iconics>

iOS： <https://github.com/PrideChung/FontAwesomeKit>

[使用IconFont减小iOS应用体积](http://johnwong.github.io/mobile/2015/04/03/using-icon-font-in-ios.html)

- - - -
  华丽的分割线 
- - - - 



# 沟通结果
经过沟通发现掌上链家并不太适合这样的方式，原因如下
1. 之前的icon很多是用ps做的 如果改用iconfont很多图层效果无法实现
2. 即便新的icon用Sketch制作矢量图，但是icon在掌链中能制作矢量图的占比较小，且对设计的人力要求过大。
3. 位图(png，jpg)等才是占用资源大户。
后期考虑的方案

1. 压缩大图 推荐使用[PPDUCK](http://ppduck.com/)(收费) [imageOption](https://imageoptim.com/mac)，[]tinyPng](https://www.baidu.com/link?url=KkC7lFY89TwZELeYuV93DGrVaUInl3IYeq69FIHm0vp6mG8NrKBif_ewcW-9aZKC&wd=&eqid=cf83ff7b00071ce80000000358d65ecf)
2. 删除重复资源(上海链家合并期间部分资源重复，但是由于工期太短没有剔除)
3. 替换旧icon ,且可以统一UI风格


# 尝试


>  我尝试使用了上面推荐的三个压缩软件进行压缩，对比如下
1. imageOption可以使图片减少30%左右，但是压缩巨慢，压缩2500张图片耗费12H以上并且，CPU一直维持在70%左右，但是图片是无损压缩，可以放心使用
2. PPDuck压缩2500张图片需要花费5分钟不到，效果达到了惊人的70%，但是缺点也很明显，收费😂😂😂,不过我已经买了会员，有需要统一处理大批量的同学可以私信我我,,无偿帮忙，一般这种需求不会经常出现，在某次做包体积优化的时候才会出现一次。
3. tinyPng，TinyPng的压缩也很厉害，缺点是需要上传图片到网站，再下载回来，也很耗时，且很麻烦，不过github有开源的工具TinyPng4MAC,可以使用。但是2500张经常会让程序Crash

# 总结

之所以写这篇文章，是想记录一下经过，并且向看这个文章的小伙伴没树立一个我自己的观点。无论技术有多优秀，我们最终是要落实到业务的，所以不要为了技术而技术，做事情要有始有终。很多人也会经常有困惑说我整天忙于业务，不知道如何提升，我这里想说的是所有人一开始就是做业务的，那些技术大牛更是，只有自己意识到自己的开发中涉及到的不足，私下补上自己的基本功，并且深入下去才能提高，一味的找理由说自己业务忙没时间学习都是借口(当然996这样无限制体力劳动的公司可以走人了)。

最后代码部分真的很简单 我就写了几行代码，最后放在GitHub上面供参考了； 





[原文地址](https://www.valiantcat.cn/index.php/2017/03/25/36.html)

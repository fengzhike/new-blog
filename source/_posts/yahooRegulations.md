---
title: Yahoo军规
date: 2017.12.08
tags: [前端, 性能优化]
categories: 性能优化
---

# Yahoo军规

在互联网盛行到的今天，各种网站给我们带来了很大的便利，不论是网站的使用者还是开发者，都希望网页尽快的呈现到人们的面前。在这方面，互联网的先行者 ***Yahoo*** 进行了探索并总结了34条规律，后来又补充一条，这就是开发者口中的**35条Yahoo军规**。下面我们分条介绍：

**内容部分**
* * *
## 一、尽量减少HTTP请求数量
从请求到页面呈现，80%的事件都花在了静态资源的请求上，图片、样式表、脚本文件、音频/视频、Flash等，都需要通过http请求从服务器上获取。我们知道，http的开销是很惊人的，减少http请求数量就很有必要了。

* **文件合并**，把相同类型文件比如js和css进行合并，可以减少http请求数量。也不宜过大，每个文件小于25k为佳。
* **CSS Sprites**，使用CSS Sprites把多张图片合成一张大图，然后结合background-image和background-position属性来定位要显示的部分。
* **图像映射**，把多张图片合并成单张图片，总大小一样，但是减少了http请求并加速了页面加载，不过适应场景比较苛刻，需要图片在页面中连续显示，比如导航条。不建议使用
* **行内图片（base64编码）**，用data:URL模式来吧图片嵌入页面。

## 二、减少DNS查找
域名系统建立了主机名和IP地址间的映射，就像电话簿上人名和号码的映射一样。当你在浏览器输入www.yahoo.com的时候，浏览器就会联系DNS解析器返回服务器的IP地址。DNS是有成本的，它需要20到120毫秒去查找给定主机名的IP地址。在DNS查找完成之前，浏览器无法从主机名下载任何东西。

可以用dns预解析方式，避免dns每次都花时间解析
```
<meta http-equiv="x-dns-prefetch-control" content = "on" />
<link rel="dns-prefetch" href="http://bdimg.share.baidu.com">
```
## 三、避免重定向
重定向用301和302状态码，下面是一个301状态码的HTTP头：

```
HTTP/1.1 301 Moved Permanently
      Location: http://example.com/newuri
      Content-Type: text/html
```
重定向的时候，浏览器跳转到指明的URL，这个过程会在HTTP请求头携带所有的信息。这种重定向显然是浪费资源的。

**url尾部省略'/'也是要重定向的**，开发人员要引起注意，链接地址最好完善
```
www.example.com  ---> www.example.com/
```
## 四、让Ajax可缓存
Ajax可以从服务器异步获取信息，有着比较好的体验，给Ajax配置可缓存能够提高性能。做好代码压缩，配置ETags等也能提高Ajax性能

## 五、延迟加载
可以做lazyload

## 六、预加载
可以通过预加载的方式减少加载时的耗时
```
<link rel="dns-prefetch" href="http://bdimg.share.baidu.com">
```
预加载有无条件加载、 有条件加载、 有预期加载三种情况，按需配置就好

## 七、减少DOM的数量
DOM的读写也是很耗性能的，能用css解决的尽量不用HTML解决，不要用无意义的div包裹。尽量使用语义化标签

## 八、跨域划分内容
把页面所需要的资源按域名划分为若干部分，最大限度地实现平行下载。例如html放在www.example.com，样式表放在static1.example.com,图片放在static2.example.com上。。。

## 九、尽量少使用frame
即使是空白的iframe，也需要比较长的时间加载，并且是阻塞性加载

## 十、杜绝404
HTTP请求的开销比较大，不要请求无用的响应

** css部分**
* * *
## 十一、避免使用css表达式
用css表达式动态设置css属性，虽然能实现一些好的效果，但是容易被攻击，对性能也有影响，例如：
```
background-color: expression( (new Date()).getHours()%2 ? "#B8D4FF" : "#F08A00" );
```

## 十二、选择&lt;link&gt;舍弃@import
为实现逐步渲染，css放在顶部更好，而在IE中用@import与在底部用<link>效果一样，所以最好不要用它。

## 十三、避免使用滤镜
IE专有的AlphaImageLoader滤镜可以用来修复IE7之前的版本中半透明PNG图片的问题。在图片加载过程中，这个滤镜会阻塞渲染，卡住浏览器，还会增加内存消耗而且是被应用到每个元素的，而不是每个图片，所以会存在一大堆问题。

最i好的方法是干脆不要用AlphaImageLoader，而优雅地降级到用在IE中支持性很好的PNG8图片来代替。如果非要用AlphaImageLoader，应该用下划线hack_filter来避免影响IE7及更高版本的用户。


## 十四、把样式表放在顶部
把样式表放到文档的HEAD部分能让页面逐步渲染，看起来加载更快。

**js部分**
* * *
## 十五、去除重复脚本
每个脚本文件，都要发一次http请求，重复脚本是浪费资源而且没有用的，要坚决杜绝

## 十六、尽量减少DOM访问
js访问DOM的过程是很慢的，为了让页面反应更加迅速，应该：
    - 缓存已访问过的元素的索引
    - 先"离线"更新节点，再把他们添加到DOM树
    - 尽量避免用js修复布局问题

## 十七、用智能的事件处理器
过多的频繁的事件处理器添加到了DOM树的不同元素上，会有页面反应不够灵敏。用类似事件委托的方法效果会更好

## 十八、把脚本放在底部
script标签的方式加载脚本是同步的，放在底部可以不用阻塞页面的渲染

## 十九、js和css放外边
用外部文件的方式加载js和css，下次渲染的时候，浏览器可以读取缓存，可以减少请求量，HTML文档也变小了

## 二十、压缩js和css
在压缩过程中，js和css文件中不必要的字符会被除去，是文件变小，从而提升加载速度。

## 二十一、优化图片
尝试把GIF格式转换成PNG格式，看看是否节省空间。在所有的PNG图片上运行pngcrush（或者其它PNG优化工具）

## 二十二、优化CSS Sprite

- 在Sprite图片中横向排列一般都比纵向排列的最终文件小
- 组合Sprite图片中的相似颜色可以保持低色数，最理想的是256色以下PNG8格式
- “对移动端友好”，不要在Sprite图片中留下太大的空隙。虽然不会在很大程度上影响图片文件的大小，但这样做可以节省用户代理把图片解压成像素映射时消耗的内存。100×100的图片是1万个像素，而1000×1000的图片就是100万个像素了。

## 二十三、不要用HTML缩放图片
img元素大小应该和图片大小一致，不要去缩放图片大小

## 二十四、用小的可缓存的favicon.ico
favicon.ico是放在服务器根目录的图片，浏览器会自动请求他，每次请求带上cookie不说，还会干扰下载顺序。所以要确保favicon.ico足够小，可缓存

## 二十五、减小cookie
浏览器向服务器发送的所有http请求，cookie都会一起发送，cookie大的话比较浪费资源。

## 二十六、静态资源放在不含cookie的域
把静态资源放在其他域下，这个域专门存放静态资源，可以不设cookie或者cookie设置成最小

**移动端**
* * *
## 二十七、单个文件小于25k
　这个限制是因为iPhone不能缓存大于25K的组件，注意这里指的是未压缩的大小。这就是为什么缩减内容本身也很重要，因为单纯的gzip可能不够。

## 二十八、将组件打包到一个复合文档里
把文件打包到一个复合文档里，可以用一个HTTP请求获取多个组件（iphone不支持）

**服务器**
* * *
## 二十九、Gzip组件
前端工程师可以想办法明显地缩短通过网络传输HTTP请求和响应的时间。毫无疑问，终端用户的带宽速度，网络服务商，对等交换点的距离等等，都是开发团队所无法控制的。但还有别的能够影响响应时间的因素，压缩可以通过减少HTTP响应的大小来缩短响应时间。

从HTTP/1.1开始，web客户端就有了支持压缩的Accept-Encoding HTTP请求头。

```
Accept-Encoding: gzip, deflate
```

　如果web服务器看到这个请求头，它就会用客户端列出的一种方式来压缩响应。web服务器通过Content-Encoding相应头来通知客户端。

```
Content-Encoding: gzip
```

尽可能多地用gzip压缩能够给页面减肥，这也是提升用户体验最简单的方法。

## 三十、避免图片src属性为空
如果scr的值为空，浏览器会向服务器发送请求，以下两种都要避免

```
//straight HTML
<img src=””>
//JavaScript
var img = new Image();
img.src = “”;
```

## 三十一、配置ETags
实体标签（ETags），是服务器和浏览器用来决定浏览器中组件与源服务器中组件是否匹配的一种机制，添加ETags可以提供一种实体验证机制比最后修改日期更加灵活。一个ETag是一个字符串，作为一个组件某一具体版本的唯一标识符。唯一的格式约束是字符串必须用引号括起来，源服务器用相应头中的ETag来指定组件的ETag：

```
HTTP/1.1 200 OK
      Last-Modified: Tue, 12 Dec 2006 03:03:59 GMT
      ETag: "10c24bc-4ab-457e1c1f"
      Content-Length: 12195
```

然后，如果浏览器必须验证一个组件，它用If-None-Match请求头来把ETag传回源服务器。如果ETags匹配成功，会返回一个304状态码，这样就减少了12195个字节的响应体。

```
GET /i/yahoo.gif HTTP/1.1
      Host: us.yimg.com
      If-Modified-Since: Tue, 12 Dec 2006 03:03:59 GMT
      If-None-Match: "10c24bc-4ab-457e1c1f"
      HTTP/1.1 304 Not Modified
```

## 三十二、对Ajax用GET请求
浏览器使用XMLHttpRequest发送POST请求时，通过一个两步的过程实现的：先发送HTTP头，再发送数据。而GET请求只需要发送一个TCP报文（除非cookie特别多）。

## 三十三、尽早清空缓冲区
当用户请求一个页面时，服务器需要用大约200到500毫秒来组装HTML页面，在这期间，浏览器闲等着数据到达。PHP中有一个flush()函数，允许给浏览器发送一部分已经准备完毕的HTML响应，以便浏览器可以在后台准备剩余部分的同时开始获取组件，好处主要体现在很忙的后台或者很“轻”的前端页面上（P.S. 也就是说，响应时耗主要在后台方面时最能体现优势）。

　　较理想的清空缓冲区的位置是HEAD后面，因为HTML的HEAD部分通常更容易生成，并且允许引入任何CSS和JavaScript文件，这样就可以让浏览器在后台还在处理的时候就开始并行获取组件。

例如：
```
... <!-- css, js -->
   </head>
   <?php flush(); ?>
   <body>
     ... <!-- content -->
```

## 三十四、使用CDN（内容分发网络）
CDN是一组分散在不同地理位置的web服务器，用来给用户更高效地发送内容，总是给用户选择hop最小或者响应最快的服务器

## 三十五、添上Expires或者Cache-Control HTTP头
这条规则有两个方面：
    - 对于静态组件：通过设置一个遥远的将来时间作为Expires来实现永不失效
    - 多余动态组件：用合适的Cache-ControlHTTP头来让浏览器进行条件性的请求

浏览器（和代理）用缓存来减少HTTP请求的数目和大小，让页面能够更快加载。web服务器通过有效期HTTP响应头来告诉客户端，页面的各个组件应该被缓存多久。用一个遥远的将来时间做有效期，告诉浏览器这个响应在20120年1月1日前不会改变。

```
Expires: Wen, 1 Jan 2010 20:00:00 GMT
```

如果你用的是Apache服务器，用ExpiresDefault指令来设置相对于当前日期的有效期。下面的例子设置了从请求时间起10年的有效期：

```
ExpiresDefault "access plus 10 years"
```
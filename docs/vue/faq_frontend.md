#### 1、如何解决移动端 Retina 屏 1px 像素问题 ？

   - 伪元素 + transform 实现

     > .border-1px:before{    content: '';    position: absolute;    top: 0;    height: 1px;    width: 100%;    background-color: #999;    transform-origin: 50% 0%; } @media only screen and (-webkit-min-device-pixel-ratio:2){    .border-1px:before{        transform: scaleY(0.5);    } } @media only screen and (-webkit-min-device-pixel-ratio:3){    .border-1px:before{        transform: scaleY(0.33);    } }
     >
     > 

##### 2、平方字体的高度设置

> 字体大小与字体高度有个比较规律的比值是1.4



> 待研究
>
> 1、spark连接obs处理数据
>
> 2、本地化obs对象存储
>
> 3、hybird开发、hybird容器

> hadoop服务区不需要使用raid
>
> raid分为:0 1 5 6 10
>
> raid5 至少3块硬盘，可用空间(n-1)*磁盘容量


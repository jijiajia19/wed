### html5

---

1. 物理像素px

2. 像素密度ppi

3. css像素 dips，与设备无关

   标准显示像素，1个css像素对应一个物理像素

4. DPR像素比，设备像素比（dpr） = 设备像素（分辨率）/设备独立像素（屏幕尺寸）

5. - 视觉视口(跟用户缩放操作有关，默认等同布局视口)
   - 布局视口(物理尺寸)980~1024
   - 理想视口

6. 不设置viewport是等比显示的，加入了不等比的情况是因为物理尺寸不一样 

7. 移动端 难点：适配

   - rem适配  计算rem过于复杂，优点：没有破坏完美视口

   - 百分比适配  页面元素众多，复杂时，不是理想的方案

   - viewport适配  缩减即所得，但是非完美视口

   - - 1物理像素适配

   - CSS3媒体查询

8. 移动端开发，先确定是否要适配，在确定适配方案

9. 移动端模板：

   	- meta标签
   	- 全面阻止默认行为
   	- 适配方案

10. 1.rem适配

   		rem单位：根标签的font-size所代表的值
   		---步骤
   			第一步  		创建style标签
   			第二三步		将根标签的font-size置为布局视口的宽/16
   			第四步  		将style标签添加到head中
   		---原理
   			改变一个元素在不同设备上的css像素的个数
   		---优缺点
   			优点：可以使用完美视口
   			缺点：px到rem的转化特别麻烦
   	2.viewport适配
   		---步骤
   			将所有设备的布局视口的宽置为设计图的宽度
   			第一步	定义设计图的宽度
   			第二步	确定系统缩放比例
   			第三步	选中viewport标签，改变其content值
   		---原理
   			改变不同设备上一个css像素跟物理像素的比例
   		---优缺点
   			优点：所量即所得
   			缺点：破坏了完美视口
   	3.百分比适配
   		百分比参照于谁
   	4.流体(弹性布局 flex)+固定 (不是适配)

11. ​    点击穿透的意思，就是如果一个绝对定位或者固定定位元素处于页面最顶层，对这个元素绑定一个点击事件，那么你点击这个点对应的下面凡是有点击事件或者a标签都会被触发执行。这里就不贴图了，自行脑补各种弹窗，这种情况还是非常多的。

    ​	在手持设备的浏览器上（本处主要指代iOS和Android系统上的webkit内核的浏览器和嵌入在应用程序里面的webview），由于两次连续“轻触”是“放大”的操作（即使你两次轻触的是一个链接或一个有click事件监听器的元素），所以在第一次被“轻触”后，浏览器需要先等一段时间，看看有没有所谓的“连续的第二次轻触”。如果有，则进行“放大”操作。没有，才敢放心地认为用户不是要放大，而是需要“click”至此才敢触发click事件，导致“短按（手指接触屏幕到离开屏幕的时间比较短）”的click事件通常约会延迟300ms左右。

    延迟来自判断双击和长按
    
12. 设计图一般都是640或者750px

13. CSS3特有的选择器，E > F 表示选择E元素的所有子F元素，与E F的区别在于，E F选择所有后代元素，>只选择一代。 没有<的用法。

    E+F表示HTML中紧随E的F元素。

    nth-child是个伪类的用法，如p:nth-child(2)就表示在p的父元素中选择位居第二位的p，这个可能不太好理解，自己试一试就知道了。







---

1、事件穿透

2、1px处理

---

## 移动端 H5 相关问题汇总：

 

- **1px 问题**
- **响应式布局**
- **iOS 滑动不流畅**
- **iOS 上拉边界下拉出现白色空白**
- **页面件放大或缩小不确定性行为**
- **click 点击穿透与延迟**
- **软键盘弹出将页面顶起来、收起未回落问题**
- **iPhone X 底部栏适配问题**
- **保存页面为图片和二维码问题和解决方案**
- **微信公众号 H5 分享问题**
- **H5 调用 SDK 相关问题及解决方案**
- **H5 调试相关方案与策略**

---

浮动：当容器的高度为auto，且容器的内容中有浮动（float为left或right）的元素，在这种情况下，容器的高度不能自动伸长以适应内容的高度，使得内容溢出到容器外面而影响（甚至破坏）布局的现象。这个现象叫浮动溢出
# maven同一个项目中，一个子模块引用另一个子模块的类的方法

本文链接：[https://blog.csdn.net/sunxiaoju/article/details/115799440](https://blog.csdn.net/sunxiaoju/article/details/115799440)

版权

1、首先在一个项目中创建两个子模块，如：

 ![](https://img-blog.csdnimg.cn/20210417182523408.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3N1bnhpYW9qdQ==,size_16,color_FFFFFF,t_70)

2、在common-[api](https://so.csdn.net/so/search?q=api)的pom.xml添加版本号，如：

![](https://img-blog.csdnimg.cn/20210417182557958.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3N1bnhpYW9qdQ==,size_16,color_FFFFFF,t_70)

3、在use-common-api的pom.[xml](https://so.csdn.net/so/search?q=xml)中添加如下依赖：

```XML
    <dependencies>        <dependency>            <groupId>com.best</groupId>            <artifactId>common-api</artifactId>            <version>1.0-SNAPSHOT</version>            <scope>compile</scope>        </dependency>    </dependencies>
```

注意：最关键的就是scope的值一定要是compile。

4、然后再common-api添加一个类，如：

![](https://img-blog.csdnimg.cn/20210417182840381.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3N1bnhpYW9qdQ==,size_16,color_FFFFFF,t_70)

5、最后在use-common-api使用Log类，如下图所示：

![](https://img-blog.csdnimg.cn/20210417182924863.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3N1bnhpYW9qdQ==,size_16,color_FFFFFF,t_70)

6、运行结果如下：

 ![](https://img-blog.csdnimg.cn/2021041718294612.png)
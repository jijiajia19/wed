

# BASE64使用场景



BASE64使用场景

Base64就是一种基于64个可打印字符来表示二进制数据的方法。

**Base64编码是从二进制到字符的过程**。

在项目中，将报文进行压缩、加密后，最后一步必然是使用base64编码，因为base64编码的字符串，更适合不同平台、不同语言的传输。

BASE64是编码, 不是压缩, 编码后只会增加字节数;（比之前多3分之一）
 算法简单, 几乎不会影响效率;
 算法可逆, 解码很方便, 不用于私密信息通信;
 虽然解码方便, 但毕竟编码了, 肉眼还是不能直接看出原始内容;
 加密后的字符串只有[0-9a-zA-Z+/=], 不可打印字符(包括转移字符)也可传输;


公钥证书也好，电子邮件数据也好，经常要用到Base64编码，那么为什么要作一下这样的编码呢？

我们知道在计算机中任何数据都是按ascii码存储的，而ascii码的128～255之间的值是不可见字符。
而在网络上交换数据时，比如说从A地传到B地，往往要经过多个路由设备，
由于不同的设备对字符的处理方式有一些不同，这样那些不可见字符就有可能被处理错误，这是不利于传输的。
所以就先把数据先做一个Base64编码，统统变成可见字符，这样出错的可能性就大降低了。

**使用场景：**

1）对证书来说，特别是根证书，一般都是作Base64编码的，因为它要在网上被许多人下载。

2）电子邮件的附件一般也作Base64编码的，因为一个附件数据往往是有不可见字符的。

 3）http协议当中的key value字段的值，必须进行URLEncode，
 因为一些特殊符号（等号或者空格）是有特殊含义的，造成混淆，解析失败，那么需要把这些值统一处理为可见字符，传输完再解析回来。*
*

4）xml格式的文件中如果想嵌入另一个xml文件。直接嵌入，那么各种标签（有两套xml标签）就混乱了，不容易被解析。怎么办？

1，把另一个xml编译成字节数组转换成逗号隔开的字符串。
2，编译成可见字符。

结果：2好些。因为1消耗的空间比原来多一倍，而2只是多三分之一。

5）网页中一些小图片可以直接以base64编码的方式嵌入。不用再用链接请求消耗资源。

 6）很多比较老的协议还是只支持纯文本的,比如SMTP协议。
 有时在一些特殊应用的场合，大多数消息是纯文本的，偶尔需要用这条纯文本通道传一张图片之类的情况发生的时候,就会用到base64

 7）http虽然也是纯文本协议，但是http有针对二进制数据做特殊的规定（mime），所以用http直接传输二进制数据是可行的。
 但是有些特殊情况，比如返回需要在json内部之类的。



---

主要传输中将不可见字符转变为可见字符，因为机器基础是ascii编码。
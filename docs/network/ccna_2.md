## STP生成树协议

> - 没有冗余的网络，风险高(redundancy)
> - reduancy 容易出现环路(广播风暴)
> - 单播会变成广播，单播回复的时候，就会打破环路(未知单播)



> 1. stp重点哪一条路会被block
>
> 2. 交换机的生成树是默认开启的
>
> 3. 协议：两边讲同样的语言



> stp协议封装的包：bpdu
>
> bpdu是frame
>
> bpdu类型区分，通过mac地址：0180.c200.0000，bpdu数据包包含生成树协议需要的参数
>
> 1. conf bpdu
> 2. tcn bpdu
>
> ---
>
> BLK port选取？
>
> 1. 802.1d stp最初的版本
>
>    - root brige
>
>      通电会选取root brige,bridge id=priority(32768 default)+mac (base mac address,using for elect)
>
>    - root port
>
>    - designated port
>
>    - elect blocking port
>
>    ![image-20211015183035586](C:\Users\Jacle\AppData\Roaming\Typora\typora-user-images\image-20211015183035586.png)


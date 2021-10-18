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
>    - root brige(选取完之后，从rb开始发送bpdu)
>
>      通电会选取root brige,bridge id=priority(32768 default)+mac (base mac address,using for elect)
>
>    - root port(面向rp的cost最小的端口，非rp自身端口)--面向作用：选取路径path
>
>      -- 仅仅入inbox叠加cost
>
>    - designated port
>
>    - elect blocking port
>
> 2. rp的选取(最低的数值)--(相同条件，看sender的bid，此时用来进行rp选取)
>
>    - cost最小,带宽速度问题
> - 每个交换机都有一个RP
>    - 相同的cost，此时比较sender的BID
> - send port priority (默认128)
>    - port id=send port priority+port number
> - 查看stp状态：show spanning-tree
>    - rp端口另一端一定是一个dp
> - rp的cost只会计算inside cost
>
> 

​                  

3、dp端口选取(指定端口)

> - 每个rb交换机端口都是dp
> - 每个物理链路都有一个dp
> - 最小的(交换机到根桥的路径)cost，最小的bid(priority+base mac)
>
> 4、最后剩下的就是blk port
>
> - 只能接受bpdu，无法发送
> - 其他类型的数据包，都会被丢弃



pvst+(show:ieee),rpvst(show:rstp),mpt

> pvst+:每个vlan都有个stp示例，报文头部新增vlan id
>
> ​	
>
> - 一条链路肯定有单个端口是DP，最多有一个RP
>
> - RP对应端口是DP

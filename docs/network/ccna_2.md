## 端口状态

1. disabled 不能发送和接收包，或者没有插线
2. blocking 只能接收bpdu，不能发送和接收其他的包
3. listening  可以发送和接收bpdu
4. learning  可以发送和接收bpdu，学习mac addess table
5. forwarding 转发，最终形态



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
>       定义：离root最近（cost）的端口
>
>    - cost最小,带宽速度问题
> - 每个交换机都有一个RP
>    - 相同的cost，此时比较sender的BID(priority+base mac)
> - send port priority (默认128)
>    - port id=send port priority+port number
      <<<<<<< HEAD
>
>    - 查看stp状态：show spanning-tree
>    

>    - rp端口另一端一定是一个dp
> - rp的cost只会计算inside cost
>
> 


​                  

3、dp端口选取(指定端口)

> - 每个rb交换机端口都是dp
> - 每个物理链路都有一个dp
> - 最小的(交换机到根桥的路径)cost，最小的bid(priority+base mac),这里的bid，不是sender bid
>
> 4、最后剩下的就是blk port
>
> - 只能接受bpdu，无法发送
> - 其他类型的数据包，都会被丢弃



## stp端口五种状态

---

1. disabled
2. blocking
3. listening
4. learning 能够发送bpdu包，除此之外还会学习mac地址，添加到mac地址表
5. forwarding 端口转发数据包

switch端口状态转换图；



## stp timer

---

非常重要

startup->blocking (20s)

​			 blocking (20s)[lost of bpdu]

  						->listening(15s)->learing(15s)->forwarding

所以普通用户需要等待50s，交换机收敛

root bridge每隔2s会向外发送 hello time数据包

### stp converge

---

blk端口的bpdu数据包保存20s，超过时间，或者接收的数据包不一样，此时会开始状态转换

30s\50s的情况；

如果网络链路发送变化，交换机会重新选举root，会首先认为自己是Root

此时发送的bpdu，block port会知道网络变化了，blk port会进行端口状态转换



30s的情况是，有blk端口的交换机，rp也丢失，此时不会等待20s，只有30s

switch的mac table默认储存300s，只有等mac address table情况，才会连通；时间：5分钟(switch mac address table timer)



## 解决五分钟问题

---

利用tcn bpdu数据包告诉网络；此时mac address timeout默认为15s，持续35s

此原理机制的重点：通知bpdu到整个网络；

- 2s每次发送的是conf bpdu
- 通知网络发送变化的是tcn bpdu(简化的数据包，只包含type)

topylogy_change(拓扑变化)的定义：

- 端口forwarding ，忽然不能转发了
- forwarding端口变为了design port，普通switch有了dp，表明不是单独的switch

root brige开始广播，通知网络发送改变，开始重新收敛,在此之前通过tcn，tca来得到网络拓扑改变通知;

- tcn是朝着root发送的

之后开始发送特殊的configuration bpdu（tc bit）通知整个网络,并且mac address table设置为默认15s，持续35s

---

特殊情况：rp断掉了，root会马上侦测到，此时马上发送tcn，此时立即设置mac address table reduce，因为此时rp无法收到tcn



## 新的问题TCN Flood

---

网络越大，TCN广播影响会特别大



## stp历史演变

---

pvst+(show:ieee),rpvst(show:rstp),mpt

> pvst+:每个vlan都有个stp示例，报文头部新增vlan id
>
> ​	
>
> - 一条链路肯定有单个端口是DP，一个switch一定有一个RP
>
> - RP对应端口是DP


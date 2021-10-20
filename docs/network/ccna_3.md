## STP Election Manipulation

对生成树数据流量的操控

STP认为修改转发路径

1. lowest BID  --控制rb选举
2. Lowest Path cost --控制dp\rp\blk端口
3. lowest Sender Bid (port priority)

> - priority 必须是4096的倍数,start from zero   --调整为root bridge
> - spaning-tree vlan 1 priority xxxx
> - spaning-tree vlan 1 root [primary|secondary] 随机减去一个值，不能固定root
> - no spannig-tree vlan 1 priority xxxx  



> cost必须在接口下修改
>
> - spanning-tree vlan 1 cost xxx (2096*n)

> port-priority参数设置
>
> - spanning-tree vlan 1 port-priority xxx(16*n)



pvst+：里面会存入vlan-ID



## legacy stp converage optimizations

老STP协议收敛优化

交换机上线，下线对整个网络的重新收敛有影响，因为TCN

port fast

> - 端口配置了PORT FAST，直接计入FORWARDING状态
> - 不会产生TCN，消灭TCN



## rapid STP

tcn是为了通知所有交换机的mac address table缓存时间修改；

mac address table是必须动态改变的；

一个交换机发现拓扑发送了变化，会把变化通知到这个网络；

flood tcn处理



机器卡机启动的时候，端口状态发送变化，会发送tcn；

port fast能够解决此问题;

port fast等价于edge port;

link type:

​	p2p--full duplex(rstp只能作用在此类型链路端口)

​	shared--half duplex 不会进行快速收敛

> port fast是pvst+独有的功能,连接终端，不发送tcn，从而不会进行网络收敛



> rstp从stp的五种状态变为了三种
>
> 角色名称：alternate和backup 都属于blk port状态

> rstp
>
> 1、failure detection:只有rb能够发送bpdu，比较慢收敛的因素之一
>
> rstp每个switch都能够发送bpdu(proposal),不同层级逐渐下发proposal；
>
> 从20s变为了6s
>
> 2、fast converage:
>
> ​      发送proposal agrement，返回aggrement；
>
> ​      syncronization process过程；
>
> ​      proposal aggrement shake过程
>
> 同步端口：
>
>       - edge port
>       - blk port
>
> ​	
>
> 3、forwarding端口变为blk端口
>
> 此时可以认为网络拓扑发送变化；
>
> 如果规定时间没有收到aggrement，我们的stp会采用timer来进行收敛;
>
> 

> rstp端口变为forwarding才认为是拓扑发生改变
>
> rstp交换机端口发送改变，会立即给相邻的交换机发送bpdu，来通知改变，进行sync,flush address table，重新学习；





## MSTP

对spanning-tree进行分组，pvst+要进行多次spt实例的配置;




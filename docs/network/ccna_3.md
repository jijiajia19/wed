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
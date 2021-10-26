## Router

多个网络（也可以同一个网络）之间路径选择；

1. 静态路由协议
2. 动态路由协议



路由表：

- 直连信息



> show ip route
>
> show ip int bri
>
> no shut配置之后激活端口



> 两个直连网段，可以不配置路由直接互通

> ping icmp协议里利用了两个类型

> 网卡判断是否是同网段，通过binary and 处理
>
> host通过arp广播来构建IP跟MAC的对应表
>
> - 默认网关：传输到不通网段，直接发送给网关
> - arp获取网关的mac地址
>
> 面试题：主机间通信流程?



## 静态路由

> ip route 20.20.20.0 255.255.255.0 100.100.100.2
>
> 建立ip路由
>
> 网络通信是双向的，要建立两个方向的路由
>
> --配置的是单个机器
>
> ip route 10.10.10.2 255.255.255.255 100.100.100.1



> 最长匹配原则：
>
> 选择子网掩码最长的路由——地址范围最小的路由



> 默认路由：
>
> 默认路由不是默认存在，需要自己手动配置
>
> 0.0.0.0/0是默认路由 任意目标地址都可以跟默认路由匹配
>
> ip route 0.0.0.0 0.0.0.0 100.100.100.1
>
> 注意：默认路由的next hop一定要可以连通

>rip协议里面，选择最优路由，会根据hop count来设定
>
>Router#traceroute 20.20.20.2
>
>Type escape sequence to abort.
>
>Tracing the route to 20.20.20.2
>
>
>
>  1   *     0 msec    0 msec    
>
>  2   *     1 msec    3 msec    
>
>Router#

> traceroute
>
> - icmp ttl多次exceed次数
> - udp   ttl最后一次返回是结束响应，不是exceed内容响应
>
> 





## vlan 网段

- 不通的网段是可以放置到一个vlan
- 为了方便管理，一般同网段放置到一个vlan
- 同vlan，同网段可以相互通信
- 二层网络，同vlan，不同网段不能通信



> - 交换机只要接端口的设备，才可以设置IP地址
> - 不通vlan通信通过路由实现（低效——路由端口数量少）



>vlan连接switch使用trunk
>
>router配置为子接口
>
>注意：利用子接口减少使用路由端口的数目

> Router(config)#int g0/0.30
>
> Router(config-subif)#
>
> %LINK-5-CHANGED: Interface GigabitEthernet0/0.30, changed state to up
>
> 
>
> %LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/0.30, changed state to up
>
> 
>
> Router(config-subif)#en
>
> Router(config-subif)#encapsulation do
>
> Router(config-subif)#encapsulation dot1Q 30
>
> Router(config-subif)#ip address 30.30.30.1 255.0.0.0



## 三层交换机

### 三种模式:

- 二层端口 switchport
- 三层端口 no switchport
- svi端口 interface vlan vlanId 逻辑上的三层接口，实现inverVLAN routing



> interface vlan 10
>
> ip address 10.10.10.1 255.0.0.0
>
> #类似于vlan的默认网关

> 三层交换机路由表无显示，此时需要打开开关 
>
> ip routing



## SVI

三层交换机的模式，三种模式可以共存

> 利用svi接口来互联vlan，原理：svi接口在路由上面是直连接口

> 如果路由网关接口不够，可以使用svi来处理vlan，或一般使用

> 子接口的配置方法（非三层交换机）
>
> interface GigabitEthernet0/0.10
>
>  encapsulation dot1Q 10
>
>  ip address 10.10.10.1 255.0.0.0
>
> !
>
> interface GigabitEthernet0/0.20
>
>  encapsulation dot1Q 20
>
>  ip address 20.20.20.1 255.0.0.0
>
> !
>
> interface GigabitEthernet0/0.30
>
>  encapsulation dot1Q 30
>
>  ip address 30.30.30.1 255.0.0.0



> 注意:
>
> svi需要绑定到指定端口
>
> svi上要设置vlan号
>
> 

## 动态路由

OSPF，打开此协议，路由器之间会相互通信，互通有无；

- RIP很少用
- EIGRP cisco专有
- OSPF
- BGP 用于公司或者ISP网络（广域网）
- ISIS 非常常见，ISP使用居多

> 动态路由类型：
>
> 	- distance vector--RIP 周期性交换路由表
> 	- link state OSPF--只发送变更信息,每个地点，都能找到最优路径
> 	- advanced distance vector 前两种融合



### AD

administrative distance (0-255)

静态路由的路径比OSPF小

[ad/metric]

OSPF-110

> 更改AD为255，路由此时不可用
>
> 配置出站接口，配置静态路由的AD就是0

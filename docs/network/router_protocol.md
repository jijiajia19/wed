## 路由协议

### RIP

---

1. RIP 路由矢量协议

   每隔30s更新路由表

   最多15hop

   

2. RIP分为两个版本，1，2

   version1 是有类路由  (IP地址要属于ABCD的一类，子网掩码是固定的) -无掩码信息的数据包

   version2 是无类路由 (可以对IP进行任意的子网划分) -有掩码信息的数据包

   

   同种路由协议ad一样，此时通过metric来进行衡量;

   RIP可以开启部分端口，其余不指定；

   > 只配置主类网络

3. loopback接口，逻辑的三层接口

   > rip连接的两个路由，连接端口要在同一网段，这样能够互通；
   >
   > 否则：无法进行rip路径获取
   
   > 最终每个路由器，都能够有一份完整的路由地图；

4. passive-interface不发送router update

5. 默认路由；0.0.0.0

   > 路由一定要配置默认路由

> 同一网段，网关要一致，否则无法通信；
>
> 不通网段，通过路由互联;

​			

> 默认路由可以动态注入，从而将网络上很多地址自动引入，不可能一个个单独配置静态路由;
>
> 默认可以匹配到所有IP地址
>
> 最简单的就是：ISP路由网关
>
> RIP:default-information originate  所有其他路由都会加上默认路由，最总汇总到这台路由;
>
> 
>
> 注意：汇总的那台路由，一定要设置双向路由，否则无法连通；
>
> 

6. RIP路由水平分割

   > 从路由学到路径，不能从路由在原路返回

7. 路由中毒

   > 发送路由更新：网络段不可达

> 只有直连的网段，才会发送metric为16的路由信息，此时表示不可达



### EIGRP

---

类型：混合协议，advanced distance vector

只会发送路由更新；

默认情况：带宽和延迟,但是可以设置其他的算法；

> 延迟在cisco中显示的是micro,micro second=delay*10



>route ei 1
>
>net 0.0.0.0 255.255.255.255
>
>show ip route eigrp
>
>show ip ei neigbour



- eigrp neighbour

  邻居发现;

  - 发送hello msg 默认5s
  - as number match 自治管理域
  - 相同的k value,identical metrics相同的metrics

- 配置EIGRP

- > 1. router eigrp [as-num]
  > 2. network ip wildcard-mask(255-掩码)

注：打断DNS解析，快捷键:ctrl+shift+6

> router ei 123
>
> network 10.255.1.0 0.0.0.3
>
> --其中可以配置IP地址、IP网段
>
> 可以把单个接口放置到EIGRP里面 
>
> --反掩码能够直接看出同网段地址

---三种配置方式:

- 单个地址开启
- 指定网段开启
- 所有端口均开启 0.0.0.0 255.255.255.255

不存在的IP会自动换位网段；

> Qcon=0表示邻居建立成功!
>
> show ip eigrp nei
>
> show ip route ei
>
> show ip ei topology



### 路由汇总

---

路由汇总为了减少路由表，自动将IP进行主类汇总；

如果汇总的一样，会产生环路；

> router ei 123
>
> no auto-summary

---

### EIGRP快速收敛

---

EI会自动计算一个备用路由

EI是在硬件上进行计算路由，速度更快

- 主路由
- 备路由
- 询问邻居路由

EI的三张表：

- nei table 存放直连的EI 路由
- topology table 存放所有的路由路径
- routing table 存放最优的路径

> FD:本地路由到达目标网段的metrics  存储在拓扑表
>
> RD/AD:下一跳路由到目标网段的最优路径
>
> Successor:最优路径
>
> FS: feasibility condition



> 本地路由器的RD，其实是下一跳的FD
>
> FC条件(备用路由条件):
>
> ​	RD<successor的FD
>
> 保证备用路由，之后的路径不会走自己，从而避免环路；
>
> 非完美的Condition:没有环路的路由不一定满足FC，不会作为备用路由



> EIGRP的Query和Reply，根据网络大小会响应时间会很长和很短
>
> EIGRP之间通过RD发送来计算FD

> metric越小越好



### eigrp passive interface

---

- passive接口不接收，不处理
- passive的路由邻居无法建立连接

> router ei 1
>
> passive-interface g0/0



> 注入默认路由:
>
> ​	ip route 0.0.0.0 0.0.0.0 34.34.34.4
>
>    通过单个接口来注入，是有方向的
>
> ​	int e0/1
>
> ​	ip summary-address ei 1 0.0.0.0 0.0.0.0
>
> 方法2：路由重分布，不通路由协议之间重分布



Load Balance

> eigrp也可以实现非等价的负载均衡
>
> 默认情况下4条负载均衡，metric一样
>
> 最优路径*因子=最大的路径数值，此时可以选择多条路径



---

通过改延迟来实现负载均衡的变化

> metric weights 参数，//来更改k delay的参数，k=0 就只有延迟参数的影响
>
> metric weights 0 0 0 1 0 0

注意：路由的K值一定要相同，否则无法建立eigrp的路由关系；



> show ip protocols 显示当前的路由协议
>
> 默认的variance=1



> 备用路由显示:show ip route
>
> 显示所有的路由:show ip route topology



### EIGRP 权限设置

---

eigrp之间信息查看通过MD5加密，并进行权限验证

> Router(config-router)#router eigrp 1
>
> Router(config-router)#key chain Key4eigrp
>
> Router(config-keychain)#key 1
>
> Router(config-keychain-key)#key-string cisco
>
> Router(config-keychain-key)#exit



> Router(config)#int g0/0
>
> Router(config-if)#ip authentication mode eigrp 1 md5 
>
> Router(config-if)#
>
> %DUAL-5-NBRCHANGE: IP-EIGRP(0) 1: Neighbor 10.1.1.2 (GigabitEthernet0/0) is down: authentication mode changed
>
> Router(config-if)#ip authentication key-chain  eigrp  1 Key4eigrp



---

# OSPF

- 带宽
- 层级 Hierachical
- 事件更新

可以支持大的网络设计，支持无类的IP设计；

两层：

- 主干区域(backbone area)
- 非主干区域(non-backbone area)



ASBR:连接外部的router

ABR：连接层级间的router

linkState:路由状态

linkStateExchange



OSPF邻居和毗邻关系

邻居：

- areaID
- stub area flag
- Auth password
- Hello and Dead intervals

邻接：

- 允许之间交换路由信息
- 依靠网络类型和配置
- 不是所有的邻居都要变为邻接

邻居变为邻接：

- 双向通信
- DD/DBD(database description)
- LSR( link state request)
- LSU(link state update)



定期发送hello发送个主播地址，发送评率不一样，跟类型有关

主播地址:224.0.0.5

OSPF网络类型：4种

10s:广播、点到点、

30s:非广播、点到多点

---

### OSPF Hello Protocol

ASBR:AS Boundary Routers(自治系统边界路由器)

ABR:必须有一个端口连接area0主干网区域的路由器

综上所述，ABSR一般是位于非OSPF区域和OSPF区域间互联的路由器，而ABR是OSPF种多个区域连接区域0间的路由器。

---

- Router ID 唯一识别的一串字符，代表一台路由器 （默认选择一个最大的物理IP地址）
- neighbors
- areaId
- DR BDR
- Auth



1. 双向通信:

​			Down->Attempt->Init->2Way

2. DD/DBD

​         ExState->Loading->Full

3. LSDB类似拓扑表

   LSDB:保存所有的路由信息

   LSA:路由信息

   路由表只保存最优的路由路径

---

OSPF网络类型：

1、广播类型

​    交换机相连路由(二层的广播网络)

   需要大量的资源维护邻接关系；

DR：主广播路由，只跟DR、BDR建立邻接关系

BDR：备份的DR，只跟DR、BDR建立邻接关系



2、DR的选举

​	优先级设置 ip ospf priority ?<0-255>

​	默认根据routerID进行选举

​	优先级为0，不会参加DR、BDR的选举



> show ip ospf g0/0/0
>
> show ip ospf neighbour
>
> p2p的路由网络类型，没有DR、BDR
>
> 跟点到点的接口有关系，跟网络拓扑没有多大的关系
>
> 更改了priority，不会进行立即收敛，网络减少flap，必须手动进行flap
>
> 



> LSA:存储在LSDB
>
> LSA其中的A表示advertisement宣告
>
> LSA类型:1\2\3\4\5\7主要的
>
> 3w学习方式：Who?What?Where?
>
> - 只有广播网络才会产生Type2 的LSA
>
> Type1:路由信息，在各自area的内部
>
> Type2:广播网,在area内部，针对广播网才会产生(可以理解为特例)
>
> 1\2产生于各自的区域
>
> 
>
> Type3:
>
> - summary路由信息,区域间路由更新，ABR整合信息发送，
> - 边界路由器会隐藏其他路由网络，同时也缩小了路由表的大小,inter-area-router
> - 覆盖在整个网络，通过边界路由器
> - 内部路由update信息
>
> 
>
> Type5:ASBR发送外部的路由信息，整个网络\ASBR，不会修改路由信息，直接转发，知道external AS的地址网段，路由端口地址
>
> Type4:ASBR summary汇总更新路由信息，告诉怎么到达ASBR,ABR产生到单个的区域里面。



### OSPF的Metrics

Metrics的基准(reference unit)是10^8（100Mbps）

- 可以修改reference，来区分1G\10G\100M
- 可以直接更改端口的OSPF Cost



### OSPF CONF

---

> router ospf 1
>
> router-id 1.1.1.1
>
> #有区域，跟eigrp区别之处
>
> network 10.0.0.0 0.255.255.255 area 0 
>
> 反掩码能够直接看出子网网段范围



> 子网掩码可以转换反掩码
>
> 反掩码不是都能转换为子网掩码
>
> 使用反掩码，比掩码更加灵活,具体支持看设备的操作系统版本



---

OSPF能够做到等价链路负载均衡 4条默认

OSPF无法做到费等价链路负载均衡

> Router#show ip protocols
>
> 
>
> Routing Protocol is "ospf 1"
>
>   Outgoing update filter list for all interfaces is not set 
>
>   Incoming update filter list for all interfaces is not set 
>
>   Router ID 192.168.10.49
>
>   Number of areas in this router is 1. 1 normal 0 stub 0 nssa
>
>   Maximum path: 4
>
>   Routing for Networks:
>
> ​    10.255.255.0 0.0.0.255 area 0
>
>   Routing Information Sources:  
>
> ​    Gateway         Distance      Last Update 
>
> ​    192.168.10.17        110      00:02:03
>
> ​    192.168.10.49        110      00:02:03
>
>   Distance: (default is 110)





显示ospf的信息

> Router#show ip ospf
>
>  Routing Process "ospf 1" with ID 192.168.10.49
>
>  Supports only single TOS(TOS0) routes
>
>  Supports opaque LSA
>
>  SPF schedule delay 5 secs, Hold time between two SPFs 10 secs
>
>  Minimum LSA interval 5 secs. Minimum LSA arrival 1 secs
>
>  Number of external LSA 0. Checksum Sum 0x000000
>
>  Number of opaque AS LSA 0. Checksum Sum 0x000000
>
>  Number of DCbitless external and opaque AS LSA 0
>
>  Number of DoNotAge external and opaque AS LSA 0
>
>  Number of areas in this router is 1. 1 normal 0 stub 0 nssa
>
>  External flood list length 0
>
> ​    Area BACKBONE(0)
>
> ​        Number of interfaces in this area is 2
>
> ​        Area has no authentication
>
> ​        SPF algorithm executed 4 times
>
> ​        Area ranges are
>
> ​        Number of LSA 5. Checksum Sum 0x029e0c
>
> ​        Number of opaque link LSA 0. Checksum Sum 0x000000
>
> ​        Number of DCbitless LSA 0
>
> ​        Number of indication LSA 0
>
> ​        Number of DoNotAge LSA 0
>
> ​        Flood list length 0



显示数据库的信息:

> Router#show ip ospf da
>
> ​            OSPF Router with ID (192.168.10.49) (Process ID 1)
>
> 
>
> ​                Router Link States (Area 0)
>
> 
>
> Link ID         ADV Router      Age         Seq#       Checksum Link count
>
> 192.168.10.17   192.168.10.17   1689        0x80000003 0x00533a 2
>
> 192.168.10.49   192.168.10.49   510         0x80000005 0x009484 2
>
> 192.168.10.65   192.168.10.65   510         0x80000002 0x00c171 1
>
> 
>
> ​                Net Link States (Area 0)
>
> Link ID         ADV Router      Age         Seq#       Checksum
>
> 10.255.255.9    192.168.10.49   682         0x80000002 0x00c9cd
>
> 10.255.255.82   192.168.10.49   510         0x80000003 0x002b10



> 根据database将OSPF拓扑图画出来，OSPF协议理解的高级部分；

---

> OSPF Passive Interface
>
> 会断开邻居关系，但是网络还是可达的，会对外宣称网络
>
> router ospf 1
>
> passive-interface g0/0

---

> OSPF Default Router Injection
>
> router ospf 1
>
> default-information originate
>
> default-information originate always

---

### ECMP Load Balance

> 更改端口的COST:
>
> int g0/0
>
> ip ospf cost 119

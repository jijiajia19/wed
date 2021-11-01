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

FD:最小的metrics

RD:下一跳最优路由metrics

Successor:最优路径

FS: feasibility condition






# 链路聚合

---

EtherChannel

port Aggregation 端口聚合

此处理知识是二层交换机区域：

- 提高带宽
- 提高冗余
- 速率没有增加，只是增加了吞吐量



PORTCHANNEL将多个端口捆绑为一个通道

配置都是2^n条链路

掉包：吞吐量大，实际吞吐小；



配置方法：

- PAGP 私有协议(mode:desire\auto，不能同为auto)

​        port channel启动后死掉，重新配置，或者重新启动

​       建议：default int g0/0

​      后续的配置都是在逻辑接口进行配置

> 端口起trunk 命令为
> switchport mode trunk //端口模式为trunk
> switchport trunk encapsulation dot1q //trunk协议封装为dot1q
>
> dot1q就是 IEEE 802.1Q协议，是vlan的一种封装方式，是公有协议。

> int rangef0/1-2
>
> channel-group 2 mode desire
>
> 
>
> Switch(config)#int po1
>
> Switch(config-if)#switchport trunk encapsulation dot1q 
>
> Switch(config-if)#switchport mode trunk
>
> 验证：
>
> show etherchannel summary 

- LACP配置方式

  - active
  - passive(不能同时为passive)

  

配置完之后，生成树只能看到逻辑结构，此时就不需要生成树了；



---

三层配置EtherChannel

> Switch(config-if)#int po2
>
> Switch(config-if)#ip address 192.168.1.2 255.255.255.0
>
> Switch(config-if)#no switchport 
>
> %LINEPROTO-5-UPDOWN: Line protocol on Interface Port-channel2, changed state to down
>
> %LINEPROTO-5-UPDOWN: Line protocol on Interface Port-channel2, changed state to up
>
> Switch(config-if)#ip address 192.168.1.2 255.255.255.0



---

路由器也是可以配置EtherChannel ，需要配置二层网卡

路由器配置EtherChannel，不能使用PAGP、LCAP协议，只能手动配置，不跑协议


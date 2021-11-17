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

---

### Router的channel-group的配置

> 只有物理接口配置了，逻辑接口配置后才能生效
>
> 
>
> Router(config)#interface port-channel 10
>
> Router(config-if)#ip address 150.1.1.1 255.255.255.252
>
> Router(config-if)#exit
>
> Router(config)#int range g0/0/1-2
>
> Router(config-if-range)#chan
>
> Router(config-if-range)#channel-group ?
>
>   <1-64>  Channel group number
>
> Router(config-if-range)#channel-group 10
>
> Router(config-if-range)#no sh
>
> 



三层交换机配置:

> Switch(config)#interface port-channel 10
>
> Switch(config-if)#int po10
>
> Switch(config-if)#ip address 150.1.1.2 255.255.255.252
>
> Switch(config-if)#no switchport 
>
> Switch(config-if)#ip address 150.1.1.2 255.255.255.252



> Switch(config-if)#int range f0/1-2
>
> Switch(config-if-range)#no switchport 
>
> Switch(config-if-range)#
>
> %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet0/1, changed state to down
>
> %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet0/1, changed state to up
>
> %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet0/2, changed state to down
>
> %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet0/2, changed state to up
>
> Switch(config-if-range)#channel-group 10 mode on



---

路由配置三层协议，交换机配置二层协议，问题？？？

也是可以的



> Switch(config)#int range f0/1-2
>
> Switch(config-if-range)#chan
>
> Switch(config-if-range)#chan
>
> Switch(config-if-range)#channel-group 10 mode ?
>
>   active     Enable LACP unconditionally
>
>   auto       Enable PAgP only if a PAgP device is detected
>
>   desirable  Enable PAgP unconditionally
>
>   on         Enable Etherchannel only
>
>   passive    Enable LACP only if a LACP device is detected
>
> Switch(config-if-range)#channel-group 10 mode on
>
> Switch(config-if-range)#
>
> Creating a port-channel interface Port-channel 10
>
> 
>
> %LINK-5-CHANGED: Interface Port-channel10, changed state to up
>
> 
>
> %LINEPROTO-5-UPDOWN: Line protocol on Interface Port-channel10, changed state to up
>
> 
>
> Switch(config-if-range)#exit
>
> Switch(config)#
>
> Switch(config)#int po10
>
> Switch(config-if)#swit
>
> Switch(config-if)#switchport  mode acc
>
> Switch(config-if)#switchport  mode access 
>
> Switch(config-if)#do show ether summ
>
> Flags:  D - down        P - in port-channel
>
> ​        I - stand-alone s - suspended
>
> ​        H - Hot-standby (LACP only)
>
> ​        R - Layer3      S - Layer2
>
> ​        U - in use      f - failed to allocate aggregator
>
> ​        u - unsuitable for bundling
>
> ​        w - waiting to be aggregated
>
> ​        d - default port
>
> 
>
> 
>
> Number of channel-groups in use: 1
>
> Number of aggregators:           1
>
> 
>
> Group  Port-channel  Protocol    Ports
>
> ------+-------------+-----------+----------------------------------------------
>
> 
>
> 10     Po10(SU)           -      Fa0/1(P) Fa0/2(P) 

## FHRP

FHRP:

- HSRP 使用虚拟IP来实现了网络的负载均衡（最多8个路由看成一个整体）
- VRRP 跟HSRP类似
- GLBP 真正的负载均衡

HSRP一般通过两个路由进行冗余；
角色：

> - active router
> - standby router
> -  virtual router
> - other routers
>   VIP对应vMAC：
>   version1:
>   0000.0c表示cisco
>   07.ac表示HSRP
>   0a,HSRP 每个组，组号（0-255）
>   version2:
>   9F.F表示HSRP
>   YYY表示组号（0-4096）



standby router收不到active router的hello timer就会切换角色；
timer的设置都是1:3

> TImer是主从之间监测心跳;

>  HSRP priority参数来设置active角色；
> derement-value默认是10
> 特别测试一下递件量跟priority余量的数值；
>
> HSRP确定如何切换;

> 注意：配置网络冗余、网络路由都要考虑发、收的两种情况；
> 环路需要配置两层HSRP


default g0/0删除接口下面的所有配置

> Router(config)#int g0/0/0
>
> Router(config-if)#ip address 1.1.1.2 255.255.255.0
>
> Router(config-if)#standby version 2
>
> Router(config-if)#standby 10 ip 1.1.1.10
>
> Router(config-if)#
>
> %HSRP-6-STATECHANGE: GigabitEthernet0/0/0 Grp 10 state Init -> Init
>
> Router(config-if)#
>
> %HSRP-6-STATECHANGE: GigabitEthernet0/0/0 Grp 10 state Speak -> Standby
>
> %HSRP-6-STATECHANGE: GigabitEthernet0/0/0 Grp 10 state Standby -> Active
>
> Router(config-if)#standby 10 priority 109
>
> Router(config-if)#standby  10 pre
>
> Router(config-if)#standby  10 preempt 
>
> Router(config-if)#standby 10 track GigabitEthernet0/0/1  10|20|30 切换priority减小值

> HSRP的配置(路由链路切换)：
>
>  - 两个或者多个路由联机为虚拟路由，需要配置虚拟IP
>  - 一个路由一个网段，一个HSRP就是一个网段
>  - 两个路由之间如果有交换机，可以互通，交换机会解包，再发送
>  - standby  10 preempt   故障切换后，自动恢复
>  - 备份路由不用设置tracer
>  - standby 1 timers 3 10//设置Hellotime为3秒，Holdtime为10秒，默认即为该值
## Cisco STP Tookkit

1. port fast

   - global
   - interface

2. bpdu filter(实际不使用，非常容易造成环路)

   - global
   - interface

   两种配置的效果不一样

   global模式下，只有portfast起作用,而且不能完全发送bpdu

   接口模式下，都是可以正常发送bpdu的



## BPDU Guard

能够组织单个交换机接入网络，阻止接收到BPDU

- global 需要开启portfast

  正常的端口portfast不应该接收到bpdu，如果接收到，bpdu guard会让接口变为error-disabled状态; 

- interface

> 交换机关闭端口后，会开始发送TCN BPDU



>   BPDU Guard（BPDU保护），简单的讲它的意义就是一个不该接收BPDU的端口，比如被启动了portfast的端口，一旦收到BPDU报文，那么BPDU保护功能将会立即关闭该端口，并将端口状态置为error-disabled状态。BPDU Guard的配置分为全局型的配置和接口级的配置，注意这两种配置将带来一些不同的效果。
>
>  
>
> 全局配置BPDU Guard
>
> 全局配置BPDU Guard将使用spanning-tree portfast bpduguard default的全局配置命令，能过命令不难看出，全局配置BPDU Guard功能是必须依附于portfast而存在的，因为一个被规划为portfast的端口默认情况下是不应该连二层接桥接类设备，一般用户连接桌面机和服务器，那么这样的端口是不应该接收BPDU报文的，如果在全局配置了BPDUGuard功能，当portfast端口一旦收到BPDU报文，那么该端口将被关闭并转入error-disabled状态。
>
> 在接口上的BPDU Guard配置
>
> 在接口模式下配置BPDU Guard是通过spanning-tree bpduguard enable接口配置命令来完成，注意在接口模式下启动BPDU Guard功能，不需要依赖portfast而存在，换言之，在接口模式下启动BPDU Guard功能时，无论该接口是一个什么接口，是否是portfast接口这些都不重要，只要管理员认为该接口不应该接收BPDU报文，那么就可以在接口上配置BPDUGuard功能，一旦这个接口被启动BPDUGuard功能后，它接收到BPDU报文，那么那么该端口将被关闭并转入error-disabled状态。
>
>  
>
> 注意：一旦某个端口被转入error-disabled状态，必须通过管理员手工重启并恢复该接口！
>
>  
>
>     如果在某些时候，出现这样一个题目：某台交换机由于某种原因在一些连接桌面机或者服务器的接口上是没有启动portfast功能的，此时需要一种保护机制，当这些端口一旦收到 BPDU报文就将被关闭被转入error-disabled状态，请问应该使用一种什么配置？回答是在接口上通过spanning-treebpduguard enable来完成。因为接口上的BPDU保护是不需要依赖于portfast功能的。
> 



## ROOT GUARD

Root Guard防止ROOT改变；

stp产生的时机：有转发端口；或者是连接了终端;


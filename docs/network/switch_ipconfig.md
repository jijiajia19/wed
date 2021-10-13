# cisco Switching-配置ip

# 配置IP

交换机里面只能跟vlan和三层交换机的端口（需要no switchport）配置

##   在vlan中配置

Switch>en

Switch#config terminal

Switch(config)＃interface vlan 1

Switch(config-if)# ip address 192.168.1.2 255.255.255.0

Switch(config-if)# no shutdown

##   在三层交换机端口配置

Switch>en

Switch#config terminal

Switch(config)#int f0/1

Switch(config-if)#no switchport

Switch(config-if)#ip add 192.168.32.1 255.255.255.0

Switch(config-if)#no shutdown



> no switchport这条命令的意思是：可以把二层接口改为三层接口，也就是说相当于一个路由器上的接口。no switch 实际上是no switchport的简写，而switchport就是交换口，也就是二层接口，这样no命令就意味着关闭二层接口并启用三层接口。
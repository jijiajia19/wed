- 创建TAP接口

```c
 sudo ip tuntap add tap-qemu mode tap
```

- 为新创建的网卡分配IP地址

```c
sudo ip addr add 192.168.1.1/24 dev tap-qemu
```

- 启动虚拟网卡工作

```c
sudo ip link set tap-qemu up
    
    
---
 New-VMSwitch -Name WSLBridge  -NetAdapterName WLAN
    
 [wsl2]
networkingMode=bridged # 桥接模式
vmSwitch=WSLBridge # 你想使用的网卡, 这里用的上面 <switch-name> 填的名字
ipv6=true # 启用 IPv
```





```shell
sudo ip addr add 192.168.0.116/24 dev eth0
```
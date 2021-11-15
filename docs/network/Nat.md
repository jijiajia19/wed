## 网络地址转换

network address translation

- 节省地址
- 屏蔽内部地址，安全



类型:

- static NAT 内部和外部IP的一对一映射
- Dynamic NAT  地址池进行映射分配
- NAT overloading(Port address translation) 通过端口确定IP地址



- inside zone
  - inside local分配给主机的私有地址
  - inside global 外部看来的地址
- outside zone

根据流量的方向来判定





> Source NAT
>
> -- 先创建inside zone\outside zone
>
> -- 可以单独进行部分地址转换



> NAT操作顺序
>
> - NAT Inside发送数据包，先路由后解析
> - NAT Outside先解析，后发送数据包



> NAT可以在边界路由器上进行私有数据转换
>
> Router(config)#int g0/0
>
> Router(config-if)#int g0/1
>
> Router(config-if)#ip nat inside
>
> Router(config-if)#int g0/1
>
> Router(config-if)#ip nat outside
>
> Router(config)#ip nat inside source static 192.168.100.1 12.12.12.1
>
> 

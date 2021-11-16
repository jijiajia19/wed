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
>
> show ip nat translation



> NAT能够少配置路由，通过更改地址，来实现路由之间互通
>
> 通过NAT，将一个端口的数据包，通过路由的另外一个端口发送出去
>
> - 从外部无法连接到真实的PC，因为通过NAT，只能访问的是路由器端口
> - 通过NAT，可以隐藏访问的服务器IP，发送包的IP地址

> ACL是可以嵌入到NAT的配置中去的
>
> > ip nat pool my_pool 100.0.0.10 100.0.0.20 netmask 255.255.255.0
> >
> > nat->interface
> >
> > nat->pool
> >
> > ip nat inside source list 10 pool my_pool
>
> >  通过静态路由宣告，从而知道反向路由地址
> >
> > 1. 创建一个静态路由
> >
> >    ip route 100.0.0.0 255.255.255.0 null 0
> >
> > 2. 通过eigrp宣告路由
> >
> >    network 100.0.0.0 0.0.0.255



> overload多对一
>
> ip nat inside source list 19 int g0/1 overload
>
> 通过添加随机端口来识别哪台机器的IP响应

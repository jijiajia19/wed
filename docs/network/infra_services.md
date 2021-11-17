# 基础服务

---

1. DHCP

   DHCP是二层的广播数据包

   Router可以做DHCP服务器

   ip地址、网关、DNS

   > ip dhcp exclude-address x.x.x.x
   >
   > ip dhcp pool dhcp1
   >
   > network x.x.x.x 255.255.255.0
   >
   > - default router x.x.x.x
   > - dns-server x.x.x.x

   DHCP Relay 处理不同网段的DHCP服务器去获取地址

   > ip help-address 1.1.1.1

2. DNS

   路由上配置DNS

   > ip name-server x.x.x.x

3. NTP

4. ROUTER

5. SWITCH

---

## 查看旁边连接的设备的协议

- CDP(可以看到设备的具体型号)

  > conf t
  >
  > cdp run 
  >
  > end
  >
  > show cdp nei

- LLDP

  > conf t
  >
  > lldp run 
  >
  > end
  >
  > show lldp nei



---

> Router(config)#ip dhcp excluded-address 1.1.1.1
>
> Router(config)#ip dhcp excluded-address 2.2.2.1
>
> Router(config)#ip dhcp excluded-address 1.1.1.254
>
> Router(dhcp-config)#network 1.1.1.0 255.255.255.0
>
> Router(dhcp-config)#default-router 1.1.1.1
>
> Router(dhcp-config)#dns-server 192.168.0.1

> Router(config)#ip dhcp pool dp2
>
> Router(dhcp-config)#network 2.2.2.0 255.255.255.0
>
> Router(dhcp-config)#default-router 1.1.1.1
>
> Router(dhcp-config)#default-router 2.2.2.1
>
> Router(dhcp-config)#dns-server
>
> Router(dhcp-config)#dns-server 192.168.0.1

>default-gateway是配置自己设备的默认网关。
>而default-router是服务器设备下发给其他设备的默认网关。

> Router(config)#int g0/0/0
>
> Router(config-if)#ip helper-address 1.1.1.1

> Router配置DNS地址:
>
> Router(config)#ip name-server 192.168.0.1
>
> Router#show hosts
>
> Default Domain is not set
>
> Name/address lookup uses domain service
>
> Name servers are 192.168.0.1
>
> 
>
> Codes: UN - unknown, EX - expired, OK - OK, ?? - revalidate
>
> ​       temp - temporary, perm - permanent
>
> ​       NA - Not Applicable None - Not defined
>
> 
>
> Host                      Port  Flags      Age Type   Address(es)
>
> www.ccna.com              None  (temp, OK)  0   IP      192.168.0.1

# IPV6

---

IPV6配置比IPV4更加便捷，配合更方便

128bit

16禁止表示*8分为8个段落

7个冒号进行分隔

> IPV6简写规则：
>
>  - 去除leading zero，开始的标号0
>
>  - 只能简写一个:0:0 -> ::
>
>  - 出现多个整体连续的0
>
>    :0:0:0:0->::



> IPV6地址种类:
>
> 公网地址-2000::/3，从此地址开始
>
> ISP最小的block是48
>
> ISP可以为32
>
> ISP最大的block是23

> 每个IPV6，必定有一个link-local address，它是自动产生的(FE80::/10)
>
> Global unicast 
>
> link-local FE80::/10
>
> unique local address(fc00::/7,fd00:/8)都是对的
>
> multicast FF00::/8
>
> anycast  DNS选择最快的host
>
> 实验地址 2001:DB8::/32

---

IPV6进行子网划分的时候，都划分为64，约定俗成

IPV6所有子网都是64位，将64-48=16位作为网络位



> 实验基本都用2001:DB8::/32



---

> ipv6 unicatst-routing
>
> ipv6 address
>
> show ipv6 route
>
> show ipv6 int s0/1/0

---

半自动方式配置IPV6

处理之前的数据是MAC-Address，得到subnet address

EUI64自动产生link-local地址和global unicast地址

手动配置prefix(可以指定prefix)和subnet，64位的那部分自动产生

1. 对半分加入FF:FE
2. 第七个bit进行反转,思科的设备才会进行0->1,1->0



> Router#conf t
>
> Enter configuration commands, one per line.  End with CNTL/Z.
>
> Router(config)#ipv
>
> Router(config)#ipv6  uni
>
> Router(config)#ipv6  unicast-routing 
>
> Router(config)#int s0/
>
> Router(config)#int s0/0/1
>
> %Invalid interface type and number
>
> Router(config)#int s0/1/0
>
> Router(config-if)#ipv6 address 2001:DB8:1111:2::/64 eui-64



LINK-local自动是通过EUI-64来创建的

NDP(邻居发现协议)

- router discovery
- address resolution
- duplicate address detection

自动设定，如果将prefix变为自动就可以全自动设定



---

全自动配置IPV6(RS and RA)

1. 先配置网关地址 
2. default还能够autoconfit 默认路由



NS and NA

DAD



---

DHCP v6

- stateful 记录何时分配了IP地址，有链路跟踪
- stateless 

有状态的DHCP不会将网关信息给使用者

DHCPv6只需要配置三个信息

DHCP Relay跟ip helper-address



无状态的DHCP值需要配置DNS



跟IPV4的DHCP配置量减少了很多

---








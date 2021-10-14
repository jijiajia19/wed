## 七层协议 、TCP/IP协议

IP、TCP、UDP协议；

telnet是通过协议来进行网络通信（远程登录），设置通信；telnet是明文传输的；

TFTP看不到文件内容，FTP能够看到文件目录；

SNMP网络设备检查协议；(solarwind)



## DNS domain namespace

--root domain(13个根域名)

--first level domain

--second level domain

> DNS recursion and iterative
>
> DNS递归，本地的DNS没有域名，会回溯到root顶级服务器；再次从其他域名访问；
>
> DNS迭代，一次遍历DNS根服务器进行域名查询;
>
> 实际过程中，迭代和递归是联合在一起使用；

## TCP三次握手

> tcp三次握手，sync、sync-ack、ack
>
> buffer是来协调发送个处理之间的速度；
>
> 为了放置缓冲溢出，要进行流量控制；datagram --数据包，diagram--数据图表;

数据序列、数据确认--因为数据文件切分为数据包，数据发送顺序是错乱的；

> **TCP建立连接**
>
> TCP建立连接，也就是我们常说的三次握手，它需要三步完成。在TCP的三次握手中，发送第一个SYN的一端执行的是主动打开。而接收这个SYN并发回下一个SYN的另一端执行的是被动打开。
>
> 这里以客户端向服务器发起连接来说明。
>
> **1) 第1步** ：客户端向服务器发送一个同步数据包请求建立连接，该数据包中，初始序列号（ISN）是客户端随机产生的一个值，确认号是0；
>
> **2) 第2步** ：服务器收到这个同步请求数据包后，会对客户端进行一个同步确认。这个数据包中，序列号（ISN）是服务器随机产生的一个值，确认号是客户端的初始序列号+1；
>
> **3) 第3步** ：客户端收到这个同步确认数据包后，再对服务器进行一个确认。该数据包中，序列号是上一个同步请求数据包中的确认号值，确认号是服务器的初始序列号+1。
>
> **注意** ：因为一个SYN将占用一个序号，所以要加1。
>
> 初始序列号（ISN）随时间而变化的，而且不同的操作系统也会有不同的实现方式，所以每个连接的初始序列号是不同的。TCP连接两端会在建立连接时，交互一些信息，如窗口大小、MSS等，以便为接着的数据传输做准备。
>
> RFC793指出ISN可以看作是一个32bit的计数器，每4ms加1，这样选择序号的目的在于防止在网络中被延迟的分组在以后被重复传输，而导致某个连接的一端对它作错误的判断。

window control--窗口控制；

tcp retransmission--重传机制；

> TCP头有24个字节，4个保留字节；
>
> TCP采用CRC校验；检验数据包的正确性；
>
> UDP头部8个字节；有自己的CRC校验；



数据链路层：使用最多的是以太网协议；（Frame）

IP地址32bit，MAC地址48bit

MAC地址中的TYPE决定传输的数据类型，最后以为是CRC校验码；

所有的MAC地址是在一个平面，没有层级之分；IP地址有层级之分；便于路由；



## IP地址

IP地址=网络地址+主机地址

根据网络的大小对网段进行分类；共分为五类；



arp：2.5层协议；建立IP和MAC的地址映射；

arp 建立对应关系；保存到本地；

--二层广播和三层广播；每个网段最后一位地址是保留作为广播；

通过arp协议来进行广播；

广播的数据包，目标地址(二层的目标MAC地址)都是FFFFFFFF,二层交换机都会转发出去；

单播和组播；

## 子网划分

> 子网划分借主机位的时候，此时IP地址就是无类别；
>
> 主机位=子网位+网络地址位;借位的那一位使用1来表示；
>
> 子网掩码能够识别地址是否是c类还是无类别IP地址; subnet mask能够区分是否是同一个网段；
>
> CIDR--数字表示网络位,eg /24
>
> /32--表示一个主机
>
> /30--最小的主机网段,2个
>
> /31-实际上最小的网段，0个主机--点对点，有些厂商可以配置/31，有写是不可以;
>
> subnet-zero 划分后的第一个网段;--默认开启之后，才能使用subnet-zero

  172.16.10.0/17 ,这是一个IP地址，结尾是0和255 不一定是一个网段，也可能是一个地址；



## 路由配置

> interface xxx/0
>
> ip address ip netmask
>
> no shutdown 开启端口


> router#write //将RAM中的当前配置存储到NVRAM中，下次路由器启动就是执行保存的配置
> router#Copy running-config startup-config //命令与write效果一样


> router(config)#int s0 //进入接口配置模式 serial 0 端口配置（如果是模块化的路由器前面加上槽位编号，例如serial0/0 代表这个路由器的0槽位上的第一个接口）
> router(config-if)#ip address xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx  //添加ip 地址和掩码
> router(config-if)#no shutdown //开启端口

## 机器配置

> usermode 只能查看
>
> privilege mode(<- enable)-- 可以设置系统时间
>
> config mode (<- config term)--完全配置路由系统
>
> > interface/line/router submode

> 系统启动的时候会找start-up configuration
>
> configuration register 寄存器，有时需要改写；不会立即生效;
>
> boot system命令启动哪个系统；
>
> ​	boot system flash  xxx.filename
>
>    Router(config)#boot system flash c2900-universalk9-mz.SPA.155-3.M4a.bin
>
>    Router(config)#do write

> copy tftp flash
>
> copy flash tftp

> reload 重启路由命令
>
> delete filename 删除文件





## console取消timeout设定

> Switch# config t
>
>  Enter configuration commands, one per line. End with CNTL/Z.
>
> Switch(config)# line console 0 //設定console介面
>
> Switch(config-line)# password 123456 //設定密碼
>
> Switch(config-line)# login //套用設定
>
> Switch(config-line)# exec-timeout 0 0 //取銷Timeout設定
>
> Switch(config-line)# logging synchronous //啟用游標跟隨





> 配置密码：可以设置no password取消特权密码
>
> 
>
> Switch(config)#username jijiajia password larryjacle
>
> Switch(config)#line vty 0 4
>
> Switch(config-line)#login local
>
> login local跟password同时配置，login local优先作用

## send message between switch

同交换机内部可以发消息,多个连接用户可以看到发送的消息;

应用：重启时通知其他连接用户；





## banner

> banner motd
>
> > Switch#conf t
> >
> > Enter configuration commands, one per line.  End with CNTL/Z.
> >
> > Switch(config)#banner motd
> >
> > % Incomplete command.
> >
> > Switch(config)#banner motd !
> >
> > Enter TEXT message.  End with the character '!'.
> >
> > hello login
> >
> > !
>
> banner login
> banner exec (packet tracer无法模拟此)

> R1#conf t R1(config)#service password-encryption 
>
> R1(config)#exit R1
>
> #show running-config
>
> 
>
> 取消系统口令加密
> cisco(config)# **no service password-encryption 
> **取消加密不会将已加密的口令恢复为可阅读文本，但是新设置的密码将会以明文存在



## 恢复系统 使用rom(ROM Monitor)

** 必须使用第一个接口连接服务器

恢复系统，原有配置文件也会被清空；

erase startup-contig 恢复出厂设置

copy tftp  running-config

copy startup-config tftp



> 配置寄存器位含义：
>
> 位号          十六进制含义
>
> 00-030x0000-0x000F         启动域在系统引导提示0x0001的参数0x0000逗留引导在EPROM 0x0002-0x000F的系统镜像指定默认网络引导文件名。
>
> 060x0040忽略NVRAM内容。
>
> 070x0080被启用的OEM位排除在引导程序消息的详细资料。
>
> 080x0100被禁用的中断。
>
> 100x0400与所有零的IP广播。
>
> 11-120x0800-0x1000控制台线路速度。
>
> 13 个0x2000引导程序默认ROM软件，如果网络引导程序发生故障。
>
> 140x4000IP广播没有净编号。
>
> 150x8000Enable (event)诊断消息和忽略NVRAM内容。
>
> 
>
> 配置寄存器的默认设置是0x2102。这表明[路由器](https://links.jianshu.com/go?to=http%3A%2F%2Fwww.lonlian.com%2Fproduct1%2Fproduct1_396_1.html)应该尝试从闪存装载Cisco IOS软件镜像和装载启动配置。



# IOS file 

> dir
>
> copy
>
> show file
>
> delete 
>
> erase
>
> cd/pwd
>
> mkdir/rmdir



shortcut:ctrl+a/e 光标跳转，ctrl+u 清除命令

# Line

line是一个虚拟概念,重点是cty(console)和vty(telnet/ssh)

show line查看外部登录的用户

show user 查看用户接入方式

一般允许3-5个console用户

配置console：

> line con 0
>
> password jacle
>
> login

> line con 0
>
> exe
>
> exec-timeout 0 10



> 二层交换机、三层路由器，也有三层交换机
>
> 

> 默认telnet无法连接，可以设置line模式下 no login



## 设置特权密码，密码加密

> enable algorithm-type scrypt  secret
>
> --此密码无法decrypt
>
> enable 专门指特权模式加密



##  密码恢复

配置文件默认从0x2102加载配置文件到ram,（启动的时候去寻找startup-configuration）

confreg 0x2142 返回一个空白的startup-configuration

处理完之后改回0x2102 confreg 0x2102



## 忘记密码

> 在ROM Monitor模式下配置寄存器
> rommon 1 > confreg 0x2142
> rommon 2 > reset
> 1.
> 2.
> 配置完寄存器后重启，进入特权模式(不用输入密码)输入以下命令：
>
> 登录后复制
> Router#copy startup-config running-config
> Router(config)# no enable password
>
> Router(config)# config-register 0x2102
> -----------------------------------

## Translating ""...domain server

> 思科模拟器Cisco Packet Tracer 在输错命令后，很长时间没有响应，然后出现
>
> Translating ""...domain server (255.255.255.255)
>
> % Unknown command or computer name, or unable to find computer address
>
> 解决方法是：在config#下输入以下命令即可消除提示
>
> **no ip domain-lookup**
>
> 如果网络中没有DNS服务器的话，那么在配置router的时候最好写上该句，因为在输入错误的命令的时，它会像查找域名一样，去搜DNS服务器，造成不必要的延时。

## 日志

> 开启console log：Router(config)#logging console
> 开启buffered log：Router(config)#logging buffered
> 开启日志到服务器(syslog)：Router(config)#logging 服务器IP地址
> 开启terminal log(Monitor log)：Router#terminal monitor
> 日志开启总开关(不开启就算配置也不起作用)：Router(config)#logging on
>
> 关闭console日志:no console logging
>
> syslog配置:logging 192.168.1.2
>
> logging sync 防止命令和日志混合错乱;

> 查看配置的日志：Router#show logging
> -----------------------------------





# 二层交换(重点：如何解决环路)

> repeater\hub\bridge
>
> 路由器分隔广播域，交换机分隔冲突域



> arp是存在客户端网卡里面
>
> 交换机存储的是端口和mac的映射表（类似bridge）
>
> arp -a 查看ip对应mac地址
>
> 网络故障，会重新计算最新路径，默认30s
>
> >- 每个switch内部timer定时flush mac address-table，会出现无法查询mac 路径的情况
> >
> >  重新ping，会产生arp，会继续生成 mac address-table
> >
> >- 纯粹是2层网络，我们才能够通过mac address-table来追踪路径
> >
> >- 交换机是通过mac address-table进行转发数据包



> 交换机主要依靠switch table
>
> switch table构建过程类似arp的mac-ip缓存表
>
> - 单个交换机收到未知单播帧的时候，会进行广播
> - 多个交换机（环路stp），会选择一条最优的路径



## vlan

> vlan增加广播域，但是减小了网络规模
>
> vlan一个交换机可以配置2-1005个，1006-4094都被内部预定了
>
> port分为两类
>
> > - access port --vlan绑定的端口 
> > - switch接收和发送，都是没有tag的
> > - truck port 多个vlan的连接端口
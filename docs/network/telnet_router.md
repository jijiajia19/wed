 ![](https://images2015.cnblogs.com/blog/1141171/201704/1141171-20170419085758524-1241458275.jpg)

　　如题也如图，本例以路由器为例（思科家交换机和路由器配置大同小异）

常规配置好路由器和pc后，保证二者ping得通

首先，打开telnet，加密码 

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

R1#conf t
Enter configuration commands, one per line.  End with CNTL/Z.
R1(config)#line vty 0 4                                    //vty虚拟端口允许0-4最多五个用户同时登陆
R1(config\-line)#password abc123
R1(config\-line)#login　　　　　　　　　　　　　　　　　　　　　　//开启验证
R1(config\-line)#exit
R1(config)#end
R1#
%SYS\-5\-CONFIG\_I: Configured from console by console

R1#show running　　　　　　　　　　　　　　　　　　　　　　　　　//查看配置
Building configuration...

Current configuration : 797 bytes
!
version 12.2
no service timestamps log datetime msec
no service timestamps debug datetime msec
no service password\-encryption
!
hostname R1
!
!
!
enable password 123456
!

!
!
ip cef
no ipv6 cef
!

!
!
!
!
interface FastEthernet0/0
 ip address 192.168.1.1 255.255.255.0
 duplex auto
 speed auto
!
interface FastEthernet1/0
 no ip address
 duplex auto
 speed auto
 shutdown
!
interface Serial2/0
 no ip address
 clock rate 2000000
 shutdown
!
interface Serial3/0
 no ip address
 clock rate 2000000
 shutdown
!
interface FastEthernet4/0
 no ip address
 shutdown
!
interface FastEthernet5/0
 no ip address
 shutdown
!
ip classless
!
ip flow\-export version 9
!

!
line con 0
!
line aux 0
!
line vty 0 4　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　//证明已开启telnet
 password abc123
 login
end

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

在pc 上启用cmd  进行telnet远程登陆，如图，可以登陆并进入路由器

 ![](https://images2015.cnblogs.com/blog/1141171/201704/1141171-20170419092447212-938845318.jpg)

然后在再关闭telnet

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

R1#conf t
Enter configuration commands, one per line.  End with CNTL/Z.
R1(config)#line vty 0 4
R1(config\-line)#transport input ?
  all     All protocols
  none    No protocols
  ssh     TCP/IP SSH protocol
  telnet  TCP/IP Telnet protocol
R1(config\-line)#transport input none          //关闭所有输入协议，ssh和telnet
R1(config\-line)#exit
R1(config)#end
R1#
%SYS\-5\-CONFIG\_I: Configured from console by console

R1#show running
Building configuration...

line con 0
!
line aux 0
!
line vty 0 4
 password abc123
 login
 transport input none
!
!
!
end

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

　　这时就不能telnet登陆了。

　　**小结：在使用transport命令的时候发现，旗下所指transport input all 包括ssh和telnet， 如果是none，则禁止了两个协议，如果要再次开启协议的话，我们可以用**


transport input telnet 或者 


transport input ssh

开启响应协议

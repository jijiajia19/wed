## 思科路由器密码分为五种

> 密码种类
>
>    用途
>
> 控制台端口密码（line）
>
> ​	通过控制台端口进入用户模式
>
> 辅助端口密码（line aux）
>
> ​	通过辅助端口进入用户模式
>
> Telnet密码（line vty）
>
> ​	通过Telnet进入用户模式
>
> 启用密码（enable）
>
> ​	控制用户进入特权模式，用于老式系统
>
> 启用加密密码（enable secret）
>
> ​	控制用户进入特权模式

 

### 1、启用密码和启用加密密码

在全局配置模式下：  
启用密码（10.3之前的老式系统）：

    R1(config)#enable password Password

启用加密密码（区分大小写）：

    R1(config)#enable secret Password

我们现在一般采用启用加密，示例：

    R1#conf t
    R1(config)#enable secret 12345
    R1(config)#^Z
    R1#disable
    R1>en
    Password: 
    R1#

从用户模式进入特权模式时我们需要敲enable，如果设置了上面两个密码其中一个，那么在敲enable时提示输入密码。  
他俩功能一样，但secret密码比password密码大一点，如果设置了secret密码，password密码就失效了。

### 2、辅助端口密码

辅助密码是对Cisco 路由器背面的辅助端口加密的密码，如果设置了辅助密码，那么通过辅助端口连接Cisco路由器时将要求输入正确的密码。  
辅助端口是给用户通过调制解调器（modem）来连接路由器用的。

    R1(config)#line aux 0
    R1(config-line)#password Password
    R1(config-line)#login

### 3、控制台端口密码

控制台console,就是我们用PC机通过超级终端和Cisco路由器连接的端口。它在路由器后面，要通过翻转电缆和PC连接。

    R1(config)#line console 0
    R1(config-line)#password Password
    R1(config-line)#login

还有两个命令：

    exec-timeout 0 0            //将控制台EXEC超时时间设为0，意味着永远不超时。默认为10分钟
    logging synchronous         //避免不断出现控制台消息（具体配置模式下）

### 4、Telnet密码

我们通过Telnet连上Cisco路由器时，被要求输入密码。

    R1(config)#line vty 0 ?
    <1-190> Last Line number
    <cr>
    R1(config)#line vty 0 190        //允许同时有191个终端远程登陆
    R1(config-line)#password Password
    R1(config-line)#login

当然，你也可以通过`no login`命令路由器允许建立无口令验证的telnet连接，只要你不担心安全方面的问题。

### 5、设置SSH

补充一下，我们推荐使用SSH而不是Telnet，因为SSH使用加密密钥来发送数据，而Telnet使用非加密数据流明文发送用户名和密码。

    Router(config)#hostname R1
    R1(config)#ip domain-name 123.com             //设置域名
    R1(config)#username R1 password 123           
    R1(config)#crypto key generate rsa            //生成保护会话的加密密钥
    The name for the keys will be: R1.123.com
    Choose the size of the key modulus in the range of 360 to 2048 for your
      General Purpose Keys. Choosing a key modulus greater than 512 may take
      a few minutes.
    
    How many bits in the modulus [512]: 1024
    % Generating 1024 bit RSA keys, keys will be non-exportable...[OK]
    
    R1(config)#
    *Mar  1 04:22:08.826: %SSH-5-ENABLED: SSH 1.99 has been enabled
    R1(config)#ip ssh version 2                   //启用SSH第2版
    R1(config)#line vty 0 190
    R1(config-line)#transport input ssh           //也可以带上telnet

### 6、对密码加密

默认情况下，只有启用加密密码是加密的，要对用户模式密码和启用密码加密，需要手工配置。  
执行`show running-config`命令时，将看到除启用加密密码外的其他所有密码，通过`service password-encryption`命令来给它们加密。

    R1#conf t
    R1(config)#service password-encryption
    R1(config)#exit
    R1#show running-config
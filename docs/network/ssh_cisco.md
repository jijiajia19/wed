### 0x00:拿到设备Console线调试设备

* * *

console线：一头连设备console口，一头连电脑（现在的电脑基本上没有RS232，需要用USB转RS232线，记得装好驱动）

> 选好串口，波特率：9600，数据位：8，停止位：1，其他：None

    Switch>enable
    Switch#configure terminal
    Switch(config)#enable secret cisco      #设置密码
    Switch(config)#hostname SW              #设置主机名


### 0x01:配置SSH

> 首先配置管理地址

    SW(config)#interface vlan 1
    SW(config-if)#ip address 192.168.1.1 255.255.255.0
    SW(config-if)#no shutdown


> 查看SSH状态

    SW#show ip ssh
    SSH Disabled - version 1.99
    %Please create RSA keys (of atleast 768 bits size) to enable SSH v2.
    Authentication timeout: 120 secs; Authentication retries: 3


> 配置SSH

    SW#configure terminal 
    Enter configuration commands, one per line.  End with CNTL/Z.
    SW(config)#ip ssh time-out 30 #设置超时秒数
    SW(config)#ip ssh authentication-retries 3 #设置认证次数
    SW(config)#ip domain-name cisco.com  #设置域名
    SW(config)#crypto key generate rsa    #生成RSA密钥
    The name for the keys will be: SW.cisco.com
    Choose the size of the key modulus in the range of 360 to 2048 for your
      General Purpose Keys. Choosing a key modulus greater than 512 may take
      a few minutes.
    
    How many bits in the modulus [512]: 2048    #指定2048位
    % Generating 2048 bit RSA keys, keys will be non-exportable...[OK]
    
    SW(config)#username ssh secret cisco  #设置用户名密码
    SW(config)#line vty 0 4
    SW(config-line)#transport input ssh #设置SSH登录
    SW(config-line)#login local


> 查看SSH状态

    SW#show ip ssh
    SSH Enabled - version 1.99
    Authentication timeout: 30 secs; Authentication retries: 3
    SW#


SSH配置完成，直接使用就可以了。

* * *

### 0x02:配置Telnet（不推荐使用）

    Switch>enable
    Switch#configure terminal
    Switch(config)#enable secret cisco      
    Switch(config)#hostname SW              
    SW(config)#username telnet secret telnet
    SW(config)#line vty 0 4
    SW(config-line)#login
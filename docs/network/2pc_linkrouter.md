## Cisco（3）——ping通用路由器连接的两台PC机

 

实验之前：

![img](https://www.pianshen.com/images/241/5d2bb1bb31f622ccd95094733c477d11.png)

1.配置好PC3的IP，子网掩码：

![img](https://www.pianshen.com/images/731/596701505a3af6d172101104dc373e1b.png)

2.配置好PC4的IP，子网掩码：

![img](https://www.pianshen.com/images/915/3f1c5b0bf3158bf9ac01def994c016db.png)

3.配置路由器两个接口的IP地址：
![img](https://www.pianshen.com/images/344/dcd6e5d01c7a6eeca76761a5b56d7558.png)

4.现在点开PC3，ping 192.168.2.2，你会发现，两台PC机并没有接通，原因就是，你还没有配置两台PC的默认网关

![img](https://www.pianshen.com/images/510/fde61064cba7c807bf43786047afeb0e.png)

5.![img](https://www.pianshen.com/images/365/be0cbef0265a07c39181bc43ea201115.png)

6.配置PC3的默认网关为192.168.1.1，如图：

![img](https://www.pianshen.com/images/935/f52c096f4f3a6bef3cf75fe68a92223f.png)

7.配置PC4的默认网关为：192.168.2.1，如图：

![img](https://www.pianshen.com/images/48/cd80e0650b308cf13ad63d2b2127c8e8.png)

8.这时，你在ping 192.168.2.2，如图：

![img](https://www.pianshen.com/images/543/90665cb2dd0010ef66d6ce64abad514f.png)

**两台PC机已经ping通！**

**注意：路由器的接口配置的IP地址不能是一个网段**

![img](https://www.pianshen.com/images/469/020a511e97c1f0b03189d3a7e2dbf9fd.png)
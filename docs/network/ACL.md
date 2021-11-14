# ACL访问控制

---

## 作用:指定的数据流量过滤

- 一个acl是一个表单 :if then deny|permit
- acl是逐行比较
- 最后一个行deny 隐含调用，如果acl表示空的，此时没有deny，此时表示permit
- acl是应用在端口，才能生效
- acl可以指定inbound、outbound



ACL类型：

- numbered ACL
  - 1-99 standard
  - 100-199 extend
- named ACL
  - standard named acl
  - extended named acl
- 其他ACL



> 端口使用ACL命令:
>
> ​	ip access 1 in 

> standard acl只能过滤source IP地址
>
> 可以对单一地址进行匹配
>
> 可以对网段进行匹配
>
> - 序列号会进行ACL排序，自动产生
> - permit any
> - 单个列表最后有一个deny

> 设置ACL的端口选择和设备选择是有一定规则的

> 创建ACL:
>
> access-list portNum permit  x.x.x.x
>
> access-list 10 remark port_comment
>
> 
>
> R2#show access-lists 10
>
> Standard IP access list 10
>
> ​    permit 192.168.10.0 0.0.0.255
>
> ​    permit host 192.168.20.1
>
> ​    deny 192.168.20.0 0.0.0.255
>
> ​    deny any

> match表示有数据匹配到acl中的条目



#### 修改ACL

> no access-list 10
>
> 新的ACL设置
>
> - 其他方法；



### Extend Number ACL

---

能够口控制更多的维度：

source\dest\protocol\portNum

> R1(config)#access-list 100 permit eigrp any any
>
> R1(config)#access-list 100 permit tcp host 192.168.10.1 host 10.10.10.10  eq 21
>
> R1(config)#access-list 100 permit tcp 192.168.20.0 0.0.0.255 host 10.10.10.10 eq ?
>
>   <0-65535>  Port number
>
>   ftp        File Transfer Protocol (21)
>
>   pop3       Post Office Protocol v3 (110)
>
>   smtp       Simple Mail Transport Protocol (25)
>
>   telnet     Telnet (23)
>
>   www        World Wide Web (HTTP, 80)
>
> R1(config)#access-list 100 permit tcp 192.168.20.0 0.0.0.255 host 10.10.10.10 eq  www
>
> R1(config)#access-list 100 permit icmp host 192.168.30.1 host 10.10.10.10 
>
> R1(config)#do show access-list 100
>
> Extended IP access list 100
>
> ​    permit eigrp any any
>
> ​    permit tcp host 192.168.10.1 host 10.10.10.10 eq ftp
>
> ​    permit tcp 192.168.20.0 0.0.0.255 host 10.10.10.10 eq www
>
> ​    permit icmp host 192.168.30.1 host 10.10.10.10



---

### Named Access List

- standard
- extend

也分为两类

- 系统默认的seq增量为10

extend acl可以通过seq进行规则删除；

extend acl可以进行seq指定的规则增加;

> R1(config)#ip access-list extended acl1
>
> R1(config-ext-nacl)#5 permit eigrp any any
>
> R1(config-ext-nacl)#permit tcp host 192.168.10.1 host 10.10.10.10 eq ftp
>
> R1(config-ext-nacl)#permit tcp 192.168.20.0 0.0.0.255 host 10.10.10.10 eq www
>
> R1(config-ext-nacl)#permit icmp 192.168.30.0 0.0.0.255 host 10.10.10.10 



> R1#show access-lists 
>
> Extended IP access list acl1
>
> ​    5 permit eigrp any any
>
> ​    15 permit tcp host 192.168.10.1 host 10.10.10.10 eq ftp
>
> ​    25 permit tcp 192.168.20.0 0.0.0.255 host 10.10.10.10 eq www
>
> ​    35 permit icmp 192.168.30.0 0.0.0.255 host 10.10.10.10



> R1(config)#ip access-list  extended acl1
>
> R1(config-ext-nacl)#7 deny tcp host  192.168.30.1 host 10.10.10.10 eq  ftp



通过named ACL，standard能够直接进行num  ACL的设置

> R1(config-std-nacl)#ip acc stand 1
>
> R1(config-std-nacl)#11 deny any 
>
> R1(config-std-nacl)#do show acc
>
> Extended IP access list acl1
>
> ​    10 permit eigrp any any
>
> ​    20 deny tcp host 192.168.30.1 host 10.10.10.10 eq ftp
>
> ​    30 permit tcp host 192.168.10.1 host 10.10.10.10 eq ftp
>
> ​    40 permit tcp 192.168.20.0 0.0.0.255 host 10.10.10.10 eq www
>
> ​    50 permit icmp 192.168.30.0 0.0.0.255 host 10.10.10.10
>
> Standard IP access list 1
>
> ​    11 deny any
>
> Standard IP access list 2
>
> ​    10 deny any



---

### 如何选择执行路由

1. 标准ACL，要靠近目标
2. 扩展ACL，靠近源

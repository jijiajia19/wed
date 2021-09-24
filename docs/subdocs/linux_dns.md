# CENTOS7 安装DNS服务
1\. 安装 BIND 服务器软件并启动
====================

    yum -y install bind bind-utils
    systemctl start named.service  // 启动服务
    systemctl enable named  // 设为开机启动


1.1. 查看named进程是否正常启动
--------------------

    ps -eaf|grep named // 检查进程
    ss -nult|grep :53 // 检查监听端口


如图:

 ![](https://upload-images.jianshu.io/upload_images/1486248-19f735ecf6d4825f.png)

1.2. 开放 TCP 和 UDP 的 53 端口
-------------------------

    firewall-cmd --permanent --add-port=53/tcp
    firewall-cmd --permanent --add-port=53/udp
    firewall-cmd --reload  // 重新加载防火墙配置，让配置生效


2\. DNS 服务的相关配置文件
=================

2.1. 修改主要文件 `/etc/named.conf`
-----------------------------

修改前先备份： `cp -p /etc/named.conf /etc/named.conf.bak` // 参数-p表示备份文件与源文件的属性一致。  
修改配置：`vi /etc/named.conf` ， 配置内容如下：

    options {
            listen-on port 53 { any; };
            listen-on-v6 port 53 { any; };
            directory       "/var/named";
            dump-file       "/var/named/data/cache_dump.db";
            statistics-file "/var/named/data/named_stats.txt";
            memstatistics-file "/var/named/data/named_mem_stats.txt";
            allow-query     { any; };
    
            /*
             - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
             - If you are building a RECURSIVE (caching) DNS server, you need to enable
               recursion.
             - If your recursive DNS server has a public IP address, you MUST enable access
               control to limit queries to your legitimate users. Failing to do so will
               cause your server to become part of large scale DNS amplification
               attacks. Implementing BCP38 within your network would greatly
               reduce such attack surface
            */
            recursion yes;
    
            dnssec-enable yes;
            dnssec-validation yes;
    
            /* Path to ISC DLV key */
            bindkeys-file "/etc/named.iscdlv.key";
    
            managed-keys-directory "/var/named/dynamic";
    
            pid-file "/run/named/named.pid";
            session-keyfile "/run/named/session.key";
    };


检查一波

    named-checkconf  // 检查named.conf是否有语法问题


2.2. 配置正向解析和反向解析
----------------

### 2.2.1. 修改/etc/named.rfc1912.zones

添加配置： `vi /etc/named.rfc1912.zones` ， 配置内容如下：

    zone "reading.zt" IN {
            type master;
            file "named.reading.zt";
            allow-update { none; };
    };
    
    zone "0.168.192.in-addr.arpa" {
            type master;
            file "named.192.168.0";
            allow-update { none; };
    };


### 2.2.2. 添加正向解析域

基于 name.localhost 模板，创建配置文件：`cp -p /var/named/named.localhost /var/named/named.reading.zt`  
配置正向域名解析文件 named.reading.zt ： `vi /var/named/named.reading.zt` ，配置内容如下：

    $TTL 1D
    @   IN SOA  @ rname.invalid. (
                        0   ; serial
                        1D  ; refresh
                        1H  ; retry
                        1W  ; expire
                        3H )    ; minimum
        NS  @
        A   127.0.0.1
        AAAA    ::1
    mirror  A   192.168.0.233
    test    A   192.168.0.232


说明：

*   [http://mirror.reading.zt/](http://mirror.reading.zt/) 将会解析为 http://192.168.0.233/

授权 named 用户 `chown :named /var/named/named.reading.zt`  
检查区域文件是否正确 `named-checkzone "reading.zt" "/var/named/named.reading.zt"` ，如图：

 ![](https://upload-images.jianshu.io/upload_images/1486248-a862661e70d382e2.png)

### 2.2.3. 添加反向解析域

基于 name.localhost 模板，创建配置文件： `cp -p /var/named/named.localhost /var/named/named.192.168.0`  
配置反向域名解析文件 named.192.168.0 ： `vi /var/named/named.192.168.0`

    $TTL 1D
    @   IN SOA  @ rname.invalid. (
                        0   ; serial
                        1D  ; refresh
                        1H  ; retry
                        1W  ; expire
                        3H )    ; minimum
        NS  @
        A   127.0.0.1
        AAAA    ::1
    233 PTR mirror.reading.zt
    232 PTR test.reading.zt


授权 named 用户 `chown :named /var/named/named.192.168.0`  
检查区域文件是否正确 `named-checkzone "0.168.192.in-addr.arpa" "/var/named/named.192.168.0"` ，如图：

 ![](https://upload-images.jianshu.io/upload_images/1486248-72944e7c0c495cc2.png)

### 2.2.4. 重启 named 服务，让配置生效

重启 named 服务，让配置生效 `systemctl restart named`

3\. 在 Linux 下的 DNS 客户端的设置及测试
============================

3.1. 注册域名解析服务器到配置文件
-------------------

配置 ifcfg-xxxx `vi /etc/sysconfig/network-scripts/ifcfg-enp0s3` ， 具体内容如下：

    TYPE=Ethernet
    PROXY_METHOD=none
    BROWSER_ONLY=no
    BOOTPROTO=static
    DEFROUTE=yes
    IPADDR=192.168.0.236
    NETMASK=255.255.255.0
    GATEWAY=192.168.0.1
    DNS1=192.168.0.236  // 新增，本机就是域名解析服务器
    DNS2=8.8.8.8
    DNS3=114.114.114.114
    IPV4_FAILURE_FATAL=no
    IPV6INIT=yes
    IPV6_AUTOCONF=yes
    IPV6_DEFROUTE=yes
    IPV6_FAILURE_FATAL=no
    IPV6_ADDR_GEN_MODE=stable-privacy
    NAME=enp0s3
    UUID=1639f78b-d515-4110-80ad-f1700bf7db84
    DEVICE=enp0s3
    ONBOOT=yes
    ZONE=public


如图：

 ![](https://upload-images.jianshu.io/upload_images/1486248-213955279f1382e8.png)

重启网络服务，让配置生效 `systemctl restart network.service`

3.2. 使用 nslookup 测试
-------------------

bind-utils 软件包本身提供了测试工具 nslookup

### 3.3.1. 正向域名解析测试

`nslookup test.reading.zt` , 或者，如下图：

 ![](https://upload-images.jianshu.io/upload_images/1486248-573607c8c2450de7.png)

### 3.3.2. 反响域名解析测试

`nslookup 192.168.0.232` , 或者，如下图：

 ![](https://upload-images.jianshu.io/upload_images/1486248-8c037c3cfc0217ee.png)
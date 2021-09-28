[Centos7 搭建DNS服务器](https://www.cnblogs.com/xiaochangwei/p/dns.html)

企业内众多服务器在使用过程中全部使用ip地址，难免记混，搭建一个企业内dns服务器即刻解决。

测试环境和线上环境相应的域名信息可以保持一致，这样避免更改任何测试好的配置，直接上线。

```
#1.安装bind软件
 
yum install bind -y

[root@localhost named]# vi /etc/named.conf
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//
// See the BIND Administrator's Reference Manual (ARM) for details about the
// configuration located in /usr/share/doc/bind-{version}/Bv9ARM.html
 
options {
    listen-on port 53 { 192.168.1.7; };
    listen-on-v6 port 53 { ::1; };
    directory   "/var/named";
    dump-file   "/var/named/data/cache_dump.db";
    statistics-file "/var/named/data/named_stats.txt";
    memstatistics-file "/var/named/data/named_mem_stats.txt";
    recursing-file  "/var/named/data/named.recursing";
    secroots-file   "/var/named/data/named.secroots";
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
    bindkeys-file "/etc/named.root.key";
 
    managed-keys-directory "/var/named/dynamic";
 
    pid-file "/run/named/named.pid";
    session-keyfile "/run/named/session.key";
};
 
logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};
 
zone "." IN {
    type hint;
    file "named.ca";
};
 
include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
 
[root@localhost named]#
```

 

vi /etc/named.rfc1912.zones

在最后加上：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
//正向区域配置
zone "xiaochangwei.com" IN {
    type master;
    file "xiaochangwei.com.zone";
    allow-update { none; };
};

//反向区域配置
zone "1.168.192.in-addr.arpa" IN {
    type master;
    file "xiaochangwei.com.local";
    allow-update { none; };
};
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 进入/var/named

cp -p named.empty xiaochangwei.com.zone

 

vi xiaochangwei.com.zone

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
$TTL 1D
@    IN SOA    @ rname.invalid. (
                    0    ; serial
                    1D    ; refresh
                    1H    ; retry
                    1W    ; expire
                    3H )    ; minimum
    NS    @
    A    192.168.1.7

www IN A 192.168.1.6
ftp IN A 192.168.1.6
mail IN CNAME www
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

vi xiaochangwei.com.local

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
$TTL 1D
@    IN SOA    @ rname.invalid. (
                    0    ; serial
                    1D    ; refresh
                    1H    ; retry
                    1W    ; expire
                    3H )    ; minimum
    NS    @
    A    192.168.1.7
6 IN PTR www.xiaochangwei.com.  #最前面的6代表ip的最后一位，因为在named.rfc1912.zones反向配置中，倒叙配置了ip前三位，所以这里就相当于说192.168.1.6解析到www.xiaochangwei.com这个域名
9 IN PTR www.zycloud.info.　　　 #同理，192.168.1.9就会解析到 www.zycloud.info这个域名。 注意域名后面有个点，不能省略
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

```
systemctl restart named
systemctl enable named
```

 

换一台电脑DNS设置为DNS服务器地址（192.168.1.7）

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@1-5 ~]# nslookup ftp.xiaochangwei.com
Server:        192.168.1.7
Address:    192.168.1.7#53

Name:    ftp.xiaochangwei.com
Address: 192.168.1.6

[root@1-5 ~]# 
[root@1-5 ~]# nslookup www.xiaochangwei.com
Server:        192.168.1.7
Address:    192.168.1.7#53

Name:    www.xiaochangwei.com
Address: 192.168.1.6

[root@1-5 ~]# 
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

若提示nslookup没安装，执行下面命令进行安装

```
yum install bind-utils -y
[root@1-5 ~]# nslookup 192.168.1.6
6.1.168.192.in-addr.arpa    name = www.xiaochangwei.com.

[root@1-5 ~]# 
```

 

 需要注意的是：配置客户机的DNS的时候不要在 /etc/resolv.conf中配置，不然重启后会被覆盖，

 应该在/etc/sysconfig/network-scripts/ifcfg-*中配置，启动的时候会自动生成到resolv.conf中的

```
[root@1-5 ~]# cat /etc/sysconfig/network-scripts/ifcfg-ens33 |grep DNS
DNS1=192.168.1.7
[root@1-5 ~]# 
```
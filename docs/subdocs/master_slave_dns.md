CentOS7上使用bind9搭建DNS主从服务器
=========================

**一、bind简介**

**一、bind简介**

   Linux中通常使用bind来实现DNS服务器的架设，bind软件由isc(https://www.isc.org/downloads/bind/)维护。在yum仓库中可以找到软件，配置好yum源，直接使用命令yum install bind就可以安装。当前bind的稳定版本为bind9，bind的服务名称为named，监听的端口为53号端口。bind的主要配置文件为/etc/named.conf，此文件主要用于配置区域，并指定区域[数据库](https://cloud.tencent.com/solution/database?from=10680)文件名称。区域数据库文件通常保存于/var/named/目录下，用于定义区域的资源类型。

**二、使用bind架设DNS服务器**

1.实例操作：以域名example.com为例配置一个DNS服务器，实现正向解析与反向解析。

Master DNS(FQDN:dns1.example.com/IP: 192.168.100.199)
Slave  DNS(FQDN:dns2.example.com/IP: 192.168.100.198)
OS:CentOS Linux release 7.3.1611 (Core) 
Kernel:3.10.0\-514.10.2.el7.x86\_64
Bind:
bind\-license\-9.9.4\-38.el7\_3.2.noarch
bind\-9.9.4\-38.el7\_3.2.x86\_64
binutils\-2.25.1\-22.base.el7.x86\_64
bind\-libs\-lite\-9.9.4\-38.el7\_3.2.x86\_64
bind\-libs\-9.9.4\-38.el7\_3.2.x86\_64
bind\-utils\-9.9.4\-38.el7\_3.2.x86\_64

这里就不再赘述如何使用VM(VirtualBox/VMware/etc)，如何配置网络IP等。

bind直接用YUM安装（yum install epel-release; yum install bind）

2、主DNS服务器bind配置文件为/etc/named.conf，此文件用于定义区域。每个区域的数据文件保存在/var/named目录下。

named.conf各参数项说明：

options {
//全局选项
}
zone "ZONE name"{
//定义区域
}
logging{
//定义日志系统
}

named.conf文件内容如下：

options {
    listen\-on port 53 { 127.0.0.1; }; #定义监听端口及IP地址
    listen\-on\-v6 port 53 { ::1; }; #定义监听的IPv6地址
    directory   "/var/named"; #全局目录
    dump\-file   "/var/named/data/cache\_dump.db";
        statistics\-file "/var/named/data/named\_stats.txt";
        memstatistics\-file "/var/named/data/named\_mem\_stats.txt";
    allow\-query     { localhost; };#允许查询的IP地址
    recursion yes; #是否允许递归查询
    dnssec\-enable yes;
    dnssec\-validation yes;
    dnssec\-lookaside auto;
    /\* Path to ISC DLV key \*/
    bindkeys\-file "/etc/named.iscdlv.key";
    managed\-keys\-directory "/var/named/dynamic";
};
logging {
        channel default\_debug {
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

注意：bind的配置文件/etc/named.conf里必须要定义的三个区域是：根、127.0.0.1和127.0.0.1的反解。

以上options选项中有许多是我们用不到，我们先把它们注释掉。结果如下：

\[root@dns1 ~\]\# cat  /etc/named.conf 
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind\*/sample/ for example named configuration files.
//
// See the BIND Administrator's Reference Manual (ARM) for details about the
// configuration located in /usr/share/doc/bind-{version}/Bv9ARM.html

options {
    //listen-on port 53 { 127.0.0.1; };
    //listen-on port 53 { any; };
    //listen-on-v6 port 53 { ::1; };
    directory     "/var/named";
    dump\-file     "/var/named/data/cache\_dump.db";
    statistics\-file "/var/named/data/named\_stats.txt";
    memstatistics\-file "/var/named/data/named\_mem\_stats.txt";
    allow\-query     { any; };
    //allow-query     { 192.168.0.0/16; };
    //forward first;
    //forwarders{
    //202.106.196.115;
    //219.141.136.10;
    //114.114.114.114;
    //};

    /\* 
     - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
     - If you are building a RECURSIVE (caching) DNS server, you need to enable 
       recursion. 
     - If your recursive DNS server has a public IP address, you MUST enable access 
       control to limit queries to your legitimate users. Failing to do so will
       cause your server to become part of large scale DNS amplification 
       attacks. Implementing BCP38 within your network would greatly
       reduce such attack surface 
    \*/
    recursion yes;

    //dnssec-enable yes;
    //dnssec-validation yes;
    //dnssec-enable no;
    //dnssec-validation no;
    //dnssec-lookaside no;

    /\* Path to ISC DLV key \*/
    bindkeys\-file "/etc/named.iscdlv.key";

    managed\-keys\-directory "/var/named/dynamic";

    pid\-file "/run/named/named.pid";
    session\-keyfile "/run/named/session.key";
};

logging {
        channel default\_debug {
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

\[root@dns1 ~\]\# hostname
dns1.example.com

3、打开/etc/named.rfc1912.zones文件，添加一个区域。

\[root@dns1 ~\]\# cat  /etc/named.rfc1912.zones 
// named.rfc1912.zones:
//
// Provided by Red Hat caching-nameserver package 
//
// ISC BIND named zone configuration for zones recommended by
// RFC 1912 section 4.1 : localhost TLDs and address zones
// and http://www.ietf.org/internet-drafts/draft-ietf-dnsop-default-local-zones-02.txt
// (c)2007 R W Franks
// 
// See /usr/share/doc/bind\*/sample/ for example named configuration files.
//

zone "localhost.localdomain" IN {
    type master;
    file "named.localhost";
    allow\-update { none; };
};

zone "localhost" IN {
    type master;
    file "named.localhost";
    allow\-update { none; };
};

zone "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa" IN {
    type master;
    file "named.loopback";
    allow\-update { none; };
};

zone "1.0.0.127.in-addr.arpa" IN {
    type master;
    file "named.loopback";
    allow\-update { none; };
};

zone "0.in-addr.arpa" IN {
    type master;
    file "named.empty";
    allow\-update { none; };
};

//###############################
//自定义example.com正向解的区域 
//###############################
zone "example.com" IN {
 type master;
 file "example.com.zone";
 allow\-transfer{ 127.0.0.1;192.168.100.199;192.168.100.198; };
};

//#############################
//自定义反向解析
//#############################
zone "100.168.192.in-addr.arpa" IN {
 type master;
 file "100.168.192.in-addr-arpa";
 allow\-transfer{ 127.0.0.1;192.168.100.199;192.168.100.198; };
};

\[root@dns1 ~\]#

说明：

type: 用于定义区域类型，此时只有一个DNS服务器，所以为master，type可选值为：hint(根的)|master(主的)|slave(辅助的)|forward(转发)

file：用于定义区域数据文件路径，默认该文件保存在/var/named/目录。

区域添加好后，使用命令：named-checkconf 或 service named configtest测试配置文件语法格式。

\[root@dns1 ~\]\# named\-checkconf

没有提示则表示文件语法正常。

4、新建数据库文件/var/named/example.com.zone，并添加资源记录。

说明：

`资源记录的格式：`

`name        [ttl]      IN      RRtype      Value`

`资源记录名  有效时间    IN       类型    资源记录的值`

`SOA: 只能有一个，而且必须是第一个`

`name: 只能是区域名称，通常可以简写为@`

`value: 主DNS服务器的FQDN`

`NS: 可以有多条`

`name: 区域名称，通常可以简写为@`

`value: DNS服务器的FQDN(可以使用相对名称)`

`A: 只能定义在正向区域文件中`

`name: FQDN(可以使用相对名称)`

`value: IP`

`MX: 可以有多个`

`name: 区域名称，用于标识smtp服务器`

`value: 包含优先级和FQDN`

`优先级：0-99，数字越小，级别越高；`

`CNAME:`

`name: FQDN`

`value: FQDN`

`PTR: IP --> FQDN, 只能定义在反向区域数据文件中，反向区域名称为逆向网络地址加.in-addr.arpa.后缀组成`

`name: IP, 逆向的主机地址，主机地址反过来写加上.in-addr.arpa.`

`value: FQDN`

\[root@dns1 ~\]\# cat  /var/named/example.com.zone 
$TTL 300
;
@    IN SOA    dns1.example.com admin.example.com(
           2017032800   ; Serial
                   300          ; Refresh
                   1800         ; Retry
                   604800       ; Expire
                   300          ; TTL 
                   )
;
    IN    NS    dns1
    IN    NS    dns2
dns1    IN    A    192.168.100.199
dns2    IN    A    192.168.100.198
;
;
agent    IN    A    192.168.100.102
puppet    IN    A    192.168.100.101
\[root@dns1 ~\]#

说明：

$TTL为定义的宏，表示下面资源记录ttl的值都为600秒。

@符号可代表区域文件/etc/named.conf里面定义的区域名称，即："wubinary.com."。

每个区域的资源记录第一条必须是SOA，SOA后面接DNS服务器的域名和电子邮箱地址，此处电子邮箱地址里的@因为有特殊用途，所以此处要用点号代替。SOA后面小括号里的各值所代表的意义如下所示：

@   IN  SOA dns.example.com admin.example.com (
    2017032800 ;标识序列号，十进制数字，不能超过10位，通常使用日期
    2H ;刷新时间，即每隔多久到主服务器检查一次，此处为2小时
    4M ;重试时间，应该小于刷新时间，此处为4分钟
    1D ;过期时间，此处为1天
    2D ;主服务器挂后，从服务器至多工作的时间，此处为2天)

区域数据文件配置好后，可以使用命令named-checkzone检查语法错误。

命令格式：

\[root@dns1 ~\]\# named\-checkzone "example.com.zome" /var/named/example.com.zone 
zone example.com.zome/IN: loaded serial 2017032800
OK
\[root@dns1 ~\]#

5、两个文件都配置好后，记得查看一下文件的所属组。因为bind程序的服务名称为named，bind默认是使用named组的身份操作文件，所以我们新建的文件所属组都要改为named，并且为了安全起见不能让别人有修改的权限，权限最好改为640。

\[root@dns1 ~\]\# ll /var/named/
total 24
\-rw\-r\--r\--  1 root  named  463 Mar 28 10:46 100.168.192.in\-addr\-arpa
drwxrwx\--\-. 2 named named   23 Mar 27 13:28 data
drwxrwx\--\-. 2 named named   60 Mar 28 13:28 dynamic
\-rw\-r\--r\--  1 root  named  403 Mar 28 10:45 example.com.zone
\-rw\-r\--\--\-. 1 root  named 2076 Jan 28  2013 named.ca
\-rw\-r\--\--\-. 1 root  named  152 Dec 15  2009 named.empty
\-rw\-r\--\--\-. 1 root  named  152 Jun 21  2007 named.localhost
\-rw\-r\--\--\-. 1 root  named  168 Dec 15  2009 named.loopback
drwxrwx\--\-. 2 named named    6 Feb 15 21:16 slaves
\[root@dns1 ~\]#

6、设置妥当当后我们就可以开启服务了。

\[root@dns1 ~\]\# systemctl restart named.service
\[root@dns1 ~\]\# systemctl status named.service
● named.service \- Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2017\-03\-28 13:33:15 CST; 10s ago
  Process: 5001 ExecStop\=/bin/sh \-c /usr/sbin/rndc stop \> /dev/null 2\>&1 || /bin/kill \-TERM $MAINPID (code\=exited, status\=0/SUCCESS)
  Process: 5012 ExecStart\=/usr/sbin/named \-u named $OPTIONS (code\=exited, status\=0/SUCCESS)
  Process: 5010 ExecStartPre\=/bin/bash \-c if \[ ! "$DISABLE\_ZONE\_CHECKING" \== "yes" \]; then /usr/sbin/named\-checkconf \-z /etc/named.conf; else echo "Checking of zone files is disabled"; fi (code\=exited, status\=0/SUCCESS)
 Main PID: 5014 (named)
   CGroup: /system.slice/named.service
           └─5014 /usr/sbin/named \-u named

Mar 28 13:33:15 dns1.example.com named\[5014\]: zone 1.0.0.127.in\-addr.arpa/IN: loaded serial 0
Mar 28 13:33:15 dns1.example.com named\[5014\]: zone localhost/IN: loaded serial 0
Mar 28 13:33:15 dns1.example.com named\[5014\]: zone 100.168.192.in\-addr.arpa/IN: loaded serial 2017032800
Mar 28 13:33:15 dns1.example.com named\[5014\]: zone 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa/IN...rial 0
Mar 28 13:33:15 dns1.example.com named\[5014\]: zone example.com/IN: loaded serial 2017032800
Mar 28 13:33:15 dns1.example.com named\[5014\]: zone localhost.localdomain/IN: loaded serial 0
Mar 28 13:33:15 dns1.example.com named\[5014\]: all zones loaded
Mar 28 13:33:15 dns1.example.com named\[5014\]: running
Mar 28 13:33:15 dns1.example.com named\[5014\]: zone 100.168.192.in\-addr.arpa/IN: sending notifies (serial 2017032800)
Mar 28 13:33:15 dns1.example.com named\[5014\]: zone example.com/IN: sending notifies (serial 2017032800)
Hint: Some lines were ellipsized, use \-l to show in full.
\[root@dns1 ~\]#

7、使用dig命令测试DNS。

命令格式：

dig \[\-t type\] \[\-x addr\] \[name\] \[@server\]

\-t: 指定资源类型，用于正解

\-x: 指定IP地址，用于反解

\[root@dns1 ~\]\# dig \-t A puppet.example.com @192.168.100.199

; <<\>> DiG 9.9.4\-RedHat\-9.9.4\-38.el7\_3.2 <<\>> \-t A puppet.example.com @192.168.100.199
;; global options: +cmd
;; Got answer:
;; \-\>>HEADER<<\- opcode: QUERY, status: NOERROR, id: 17827
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;puppet.example.com.        IN    A

;; ANSWER SECTION:
puppet.example.com.    300    IN    A    192.168.100.101

;; AUTHORITY SECTION:
example.com.        300    IN    NS    dns2.example.com.
example.com.        300    IN    NS    dns1.example.com.

;; ADDITIONAL SECTION:
dns1.example.com.    300    IN    A    192.168.100.199
dns2.example.com.    300    IN    A    192.168.100.198

;; Query time: 0 msec
;; SERVER: 192.168.100.199#53(192.168.100.199)
;; WHEN: Tue Mar 28 14:14:02 CST 2017
;; MSG SIZE  rcvd: 133

\[root@dns1 ~\]\# dig \-x 192.168.100.102  @192.168.100.199

; <<\>> DiG 9.9.4\-RedHat\-9.9.4\-38.el7\_3.2 <<\>> \-x 192.168.100.102 @192.168.100.199
;; global options: +cmd
;; Got answer:
;; \-\>>HEADER<<\- opcode: QUERY, status: NOERROR, id: 58688
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;102.100.168.192.in\-addr.arpa.    IN    PTR

;; ANSWER SECTION:
102.100.168.192.in\-addr.arpa. 300 IN    PTR    agent.example.com.

;; AUTHORITY SECTION:
100.168.192.in\-addr.arpa. 300    IN    NS    dns2.example.com.
100.168.192.in\-addr.arpa. 300    IN    NS    dns1.example.com.

;; ADDITIONAL SECTION:
dns1.example.com.    300    IN    A    192.168.100.199
dns2.example.com.    300    IN    A    192.168.100.198

;; Query time: 0 msec
;; SERVER: 192.168.100.199#53(192.168.100.199)
;; WHEN: Tue Mar 28 14:15:31 CST 2017
;; MSG SIZE  rcvd: 158

\[root@dns1 ~\]#

测试成功！

注意：通常在应用中，DNS的反向解析并不是很重要，可以不配置，当服务器中有域名作为邮件服务器时，此时可以配置反向解析，因为邮件中过滤垃圾邮件的技术通常是解析邮箱地址，如果IP地址不能反解成一个域名则视为垃圾邮件。

**三、使用bind架设辅助DNS服务器，实现主从数据同步**

       DNS从服务器也叫辅服DNS服务器，如果网络上某个节点只有一台DNS服务器的话，首先服务器的抗压能力是有限的，当压力达到一定的程度，服务器就会宕机罢工，其次如果这台服务器出现了硬件故障那么服务器管理的区域的域名将无法访问。为了解决这些问题，最好的办法就是使用多个DNS服务器同时工作，并实现数据的同步，这样两台服务器就都可以实现[域名解析](https://cloud.tencent.com/product/cns?from=10680)操作。

      主DNS服务器架设好后，辅助的DNS服务器的架设就相对简单多了。架设主从DNS服务器有两个前提条件，一是两台主机可以不一定处在同一网段，但是两台主机之间必须要实现网络通信；二，辅助DNS服务器必须要有主DNS服务器的授权，才可以正常操作。

1、从DNS服务器bind配置文件为/etc/named.conf，此文件用于定义区域。每个区域的数据文件保存在/var/named目录下。

\[root@dns2 named\]\# cat  /etc/named.conf
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind\*/sample/ for example named configuration files.
//
// See the BIND Administrator's Reference Manual (ARM) for details about the
// configuration located in /usr/share/doc/bind-{version}/Bv9ARM.html

options {
    //listen-on port 53 { 127.0.0.1; };
    //listen-on port 53 { any; };
    //listen-on-v6 port 53 { ::1; };
    directory     "/var/named";
    dump\-file     "/var/named/data/cache\_dump.db";
    statistics\-file "/var/named/data/named\_stats.txt";
    memstatistics\-file "/var/named/data/named\_mem\_stats.txt";
    allow\-query     { any; };
    //allow-query     { 192.168.0.0/16; };
    //forward first;
    //forwarders{
    //202.106.196.115;
    //219.141.136.10;
    //114.114.114.114;
    //};

    /\* 
     - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
     - If you are building a RECURSIVE (caching) DNS server, you need to enable 
       recursion. 
     - If your recursive DNS server has a public IP address, you MUST enable access 
       control to limit queries to your legitimate users. Failing to do so will
       cause your server to become part of large scale DNS amplification 
       attacks. Implementing BCP38 within your network would greatly
       reduce such attack surface 
    \*/
    recursion yes;

    //dnssec-enable yes;
    dnssec\-validation yes;
    //dnssec-enable no;
    //dnssec-validation no;
    dnssec\-lookaside auto;

    /\* Path to ISC DLV key \*/
    bindkeys\-file "/etc/named.iscdlv.key";

    managed\-keys\-directory "/var/named/dynamic";

    pid\-file "/run/named/named.pid";
    session\-keyfile "/run/named/session.key";
};

logging {
        channel default\_debug {
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

\[root@dns2 named\]#

2、打开辅助DNS服务器的/etc/named.rfc1912.zones文件，添加两个区域记录，这两个记录是主DNS服务器配置文件里已经存在的记录，一个是正向解析记录，一个是反向解析记录。

////////////////////////////
//从服务器正解配置
////////////////////////////

zone "example.com." IN {
  type slave;
  masters { 192.168.100.199; };
  file "slaves/example.com.zone";
  allow\-transfer { none;};
};

/////////////////////////
//从DNS服务器反解设置
/////////////////////////

zone"100.168.192.in-addr.arpa." IN {
        type slave;
        masters { 192.168.1.199; };
        file"slaves/100.168.192.in-addr.zone";
        allow\-transfer{ none; };                 //作为从服务器不应该让其他服务器zone传送。
};

说明：type: slave，表示此时DNS服务器为辅助DNS服务器，于是下面一行就要定义主DNS服务器的IP地址，辅助DNS服务器才知道去哪里同步数据。辅助DNS服务器的资源类型数据文件通常保存在slaves目录，只需定义一个名称，文件内容通常是自动生成。

配置好后，直接开启DNS服务，然后再回到主DNS服务器上。

3、修改主DNS服务器的数据文件，添加一条辅助DNS服务器记录，给辅助DNS服务器授权。

修改正向解析文件/var/named/example.com.zone。

\[root@dns1 ~\]\# cat  /var/named/example.com.zone 
$TTL 300
;
@    IN SOA    dns1.example.com admin.example.com(
           2017032800   ; Serial
                   300          ; Refresh
                   1800         ; Retry
                   604800       ; Expire
                   300          ; TTL 
                   )
;
    IN    NS    dns1
    IN    NS    dns2
dns1    IN    A    192.168.100.199
dns2    IN    A    192.168.100.198
;
;
agent    IN    A    192.168.100.102
puppet    IN    A    192.168.100.101
\[root@dns1 ~\]#

说明：添加了一条NS记录，值为，dns2.example.com.，对应的A记录也要增加一条，把IP地址指向对应的辅助DNS服务器的IP地址。修改完成后，记得要把序列号的值加1，用于通知辅助DNS服务器自动更新数据文件。

4、重新加载主DNS服务器的配置文件，这时再到回辅助DNS服务器，在/var/named/slaves/目录下会多了两个文件。

\[root@dns2 named\]\# ll /var/named/slaves/
total 4
\-rw\-r\--r\-- 1 named named 392 Mar 28 14:34 example.com.zone
\[root@dns2 named\]#

5、测试辅助DNS服务器。

\[root@dns2 slaves\]\# dig \-t A puppet.example.com @192.168.100.198

; <<\>> DiG 9.9.4\-RedHat\-9.9.4\-38.el7\_3.2 <<\>> \-t A puppet.example.com @192.168.100.198
;; global options: +cmd
;; Got answer:
;; \-\>>HEADER<<\- opcode: QUERY, status: NOERROR, id: 53695
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;puppet.example.com.        IN    A

;; ANSWER SECTION:
puppet.example.com.    300    IN    A    192.168.100.101

;; AUTHORITY SECTION:
example.com.        300    IN    NS    dns1.example.com.
example.com.        300    IN    NS    dns2.example.com.

;; ADDITIONAL SECTION:
dns1.example.com.    300    IN    A    192.168.100.199
dns2.example.com.    300    IN    A    192.168.100.198

;; Query time: 0 msec
;; SERVER: 192.168.100.198#53(192.168.100.198)
;; WHEN: Tue Mar 28 15:10:43 CST 2017
;; MSG SIZE  rcvd: 133

\[root@dns2 slaves\]\# 
\[root@dns2 slaves\]\# 
\[root@dns2 slaves\]\# 
\[root@dns2 slaves\]\# dig \-x 192.168.100.102 @192.168.100.198

; <<\>> DiG 9.9.4\-RedHat\-9.9.4\-38.el7\_3.2 <<\>> \-x 192.168.100.102 @192.168.100.198
;; global options: +cmd
;; Got answer:
;; \-\>>HEADER<<\- opcode: QUERY, status: SERVFAIL, id: 55340
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;102.100.168.192.in\-addr.arpa.    IN    PTR

;; Query time: 0 msec
;; SERVER: 192.168.100.198#53(192.168.100.198)
;; WHEN: Tue Mar 28 15:10:50 CST 2017
;; MSG SIZE  rcvd: 57

\[root@dns2 slaves\]#

**四、主从同步数据的安全性**

       DNS服务器的数据同步默认是没有限定主机的，也就是说，网络上只要有一台DNS服务器向你的DNS服务器请求数据，都能实现数据同步，那么这样就相当的不安全了。我们可以使用一个选项allow-transfer，指定可以同步数据的主机IP。主DNS服务器的数据可以给别的服务器同步，相对的，辅助DNS服务器的数据也是可以给其它辅助DNS服务器同步，于是，所有的主从DNS服务器都要设置该参数。

1\. 指定可以从主DNS服务器上同步数据的主机。

修改/etc/named.rfc1912.zones文件：

\[root@dns2 named\]\# cat  /etc/named.rfc1912.zones 
// named.rfc1912.zones:
//
// Provided by Red Hat caching-nameserver package 
//
// ISC BIND named zone configuration for zones recommended by
// RFC 1912 section 4.1 : localhost TLDs and address zones
// and http://www.ietf.org/internet-drafts/draft-ietf-dnsop-default-local-zones-02.txt
// (c)2007 R W Franks
// 
// See /usr/share/doc/bind\*/sample/ for example named configuration files.
//

zone "localhost.localdomain" IN {
    type master;
    file "named.localhost";
    allow\-update { none; };
};

zone "localhost" IN {
    type master;
    file "named.localhost";
    allow\-update { none; };
};

zone "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa" IN {
    type master;
    file "named.loopback";
    allow\-update { none; };
};

zone "1.0.0.127.in-addr.arpa" IN {
    type master;
    file "named.loopback";
    allow\-update { none; };
};

zone "0.in-addr.arpa" IN {
    type master;
    file "named.empty";
    allow\-update { none; };
};

////////////////////////////
//从服务器正解配置
////////////////////////////

zone "example.com." IN {
  type slave;
  masters { 192.168.100.199; };
  file "slaves/example.com.zone";
  allow\-transfer { none;};
};

/////////////////////////
//从DNS服务器反解设置
/////////////////////////

zone"100.168.192.in-addr.arpa." IN {
        type slave;
        masters { 192.168.1.199; };
        file"slaves/100.168.192.in-addr.zone";
        allow\-transfer{ none; };                 //作为从服务器不应该让其他服务器zone传送。
};
\[root@dns2 named\]#

说明：

我们只有一台辅助DNS服务器，所以根本不会有主机从这台机器同步数据，所以我们设置成不允许任何人同步。

在每块区域上添加参数allow-transfer，花括号内填写可以同步的主机IP，一般填写辅助DNS服务器的IP地址。可以使用dig命令测试，区域同步：

dig \-t axfr ZONE\_NAME @DNS\_SERVCER\_IP

\[root@dns2 named\]\# dig \-t axfr example.com @192.168.100.199

; <<\>> DiG 9.9.4\-RedHat\-9.9.4\-38.el7\_3.2 <<\>> \-t axfr example.com @192.168.100.199
;; global options: +cmd
example.com.        300    IN    SOA    dns1.example.com.example.com. admin.example.com.example.com. 2017032800 300 1800 604800 300
example.com.        300    IN    NS    dns1.example.com.
example.com.        300    IN    NS    dns2.example.com.
agent.example.com.    300    IN    A    192.168.100.102
dns1.example.com.    300    IN    A    192.168.100.199
dns2.example.com.    300    IN    A    192.168.100.198
puppet.example.com.    300    IN    A    192.168.100.101
example.com.        300    IN    SOA    dns1.example.com.example.com. admin.example.com.example.com. 2017032800 300 1800 604800 300
;; Query time: 1 msec
;; SERVER: 192.168.100.199#53(192.168.100.199)
;; WHEN: Tue Mar 28 14:31:02 CST 2017
;; XFR size: 8 records (messages 1, bytes 239)

\[root@dns2 named\]#

非指定IP不可以同步数据。

\[root@dns2 slaves\]\# dig \-t axfr example.com @192.168.100.102
;; Connection to 192.168.100.102#53(192.168.100.102) for example.com failed: host unreachable.

2.指定可以从辅助DNS服务器上同步数据的主机。

修改/etc/named.rfc1912.zones文件：

////////////////////////////
//从服务器正解配置
////////////////////////////

zone "example.com." IN {
  type slave;
  masters { 192.168.100.199; };
  file "slaves/example.com.zone";
  allow\-transfer { none;};
};

/////////////////////////
//从DNS服务器反解设置
/////////////////////////

zone"100.168.192.in-addr.arpa." IN {
        type slave;
        masters { 192.168.1.199; };
        file"slaves/100.168.192.in-addr.arpa.zone";
        allow\-transfer{ none; };      
};

我们只有一台辅助DNS服务器，所以根本不会有主机从这台机器同步数据，所以我们设置成不允许任何人同步。

**五、测试DNS解析的其它命令**

   测试DNS解析的命令不只是dig可以实现，还有两个命令也可以实现相同的效果。

1、host命令

host命令格式：

\# host \[\-t type\] {name} \[server\]

2、nslookup命令

这个命令很神奇，在windows的dos里面也可以使用：

nslookup\>
    server DNS\_SERVER\_IP
    set q\=TYPE
    {name}

Refer: http://www.cnblogs.com/fatt/p/4494695.html
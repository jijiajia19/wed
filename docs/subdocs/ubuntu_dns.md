# Ubuntu 20.04 LTS DNS设置

最近使用了最新版的ubuntu 20.04运行一些服务，然后发现服务器经常出现网络不通的情况，主要是一些域名无法解析。

检查/etc/resolv.conf，发现之前修改的nameserver总是会被修改为127.0.0.53，无论怎么改都 会被替换回来。

查看/etc/resolv.conf这个文件的注释，发现开头就写着这么一行：

\# This file is managed by man:systemd-resolved(8). Do not edit.  
这说明这个文件是被systemd-resolved这个服务托管的。

通过netstat -tnpl| grep systemd-resolved查看到这个服务是监听在53号端口上。

查了下，这个服务的配置文件为/etc/systemd/resolved.conf，大致内容如下：


    [Resolve]
    DNS=1.1.1.1 1.0.0.1
    #FallbackDNS=
    #Domains=
    LLMNR=no
    #MulticastDNS=no
    #DNSSEC=no
    #Cache=yes
    #DNSStubListener=yes


如果我们要想让/etc/resolve.conf文件里的配置生效，需要添加到systemd-resolved的这个配置文件里DNS配置项（如上面的示例，已经完成修改），然后重启systemd-resolved服务即可。

另一种更简单的办法是，我们直接停掉systemd-resolved服务，这样再修改/etc/resolve.conf就可以一直生效了。



jacle.com对应DNS配置文件:

> $TTL    604800
> @       IN      SOA     jacle.com. root.localhost. (
>                               1         ; Serial
>                          604800         ; Refresh
>                           86400         ; Retry
>                         2419200         ; Expire
>                          604800 )       ; Negative Cache TTL
> ;
> @       IN      NS      localhost.
> jacle.com IN      NS      192.168.10.58
>
> aaa     IN      A       192.168.10.58
> bbb     IN      A       192.168.10.58
> www     IN      CNAME   bbb
> *.www   IN      A       192.168.10.58
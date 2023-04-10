1. /etc/docker/daemon.json的配置示例:

>  {
>         "registry-mirrors": ["http://123.60.108.208:9092"],
>         "insecure-registries":["123.60.108.208:9092","123.60.108.208:9090"],
>         "dns":["114.114.114.114","8.8.8.8"]
> }



2. 开启宿主机外网访问能力:

> 添加如下代码到文件/etc/sysctl.conf中
>
> 重启network服务：systemctl restart network
>
> 检查修改是否成功：sysctl net.ipv4.ip_forward

> 3. ubuntu安装*iputils-ping* 

> 常用sudo的权限限制:
>
> ALL,!/bin/bash,!/bin/tcsh,!/bin/su,!/usr/bin/passwd,!/usr/bin/passwd root,!/bin/vim /etc/sudoers,!/usr/bin/vim /etc/sudoers,!/usr/sbin/visudo,!/usr/bin/sudo -i,!/bin/bi /etc/ssh/*,!/bin/chmod 777 /etc/*,!/bin/chmod 777 *,!/bin/chmod 777,!/bin/chmod -R 777 *,!/bin/rm /*,!/bin/rm /,!/bin/rm -rf /,!/bin/rm -rf /*,!/bin/rm /etc,!/bin/rm -r /etc,!/bin/rm -rf /etc,!/bin/rm /etc/*,!/bin/rm -r /etc/*,!/bin/rm -rf /etc/*,!/bin/rm /root,!/bin/rm -r /root,!/bin/rm -rf /root,!/bin/rm /root/*,!/bin/rm -r /root/*,!/bin/rm -rf /root/*,!/bin/rm /bin,!/bin/rm -r /bin,!/bin/rm -rf /bin,!/bin/rm /bin/*,!/bin/rm -r /bin/*,!/bin/rm -rf /bin/*

> koko是ssh的操作组件
>
> lion是 RDP 和 VNC 连接组件


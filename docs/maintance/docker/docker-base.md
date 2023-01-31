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
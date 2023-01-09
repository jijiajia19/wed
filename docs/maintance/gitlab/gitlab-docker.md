## gitlab docker

docker pull gitlab/gitlab-ce

> ```
> $ docker run -d  -p 443:443 -p 80:80 -p 222:22 --name gitlab --restart always -v /home/gitlab/config:/etc/gitlab -v /home/gitlab/logs:/var/log/gitlab -v /home/gitlab/data:/var/opt/gitlab gitlab/gitlab-ce
> # -d：后台运行
> # -p：将容器内部端口向外映射
> # --name：命名容器名称
> # -v：将容器内数据文件夹或者日志、配置等文件夹挂载到宿主机指定目录
> ```

> [gitlab](https://so.csdn.net/so/search?q=gitlab&spm=1001.2101.3001.7020) 14安装初始化后，默认账户名是root,密码存放在配置文件
>
> **`/etc/gitlab/`initial_root_password**

> 实时显示gitlab的日志，从显示最后的100行开始
>
> docker logs -f --tail=100 gitlab

![在这里插入图片描述](https://img-blog.csdnimg.cn/1d83e79f868c4af89d246576ab6c58d4.png)

https://blog.csdn.net/Wangjiachenga/article/details/127231620


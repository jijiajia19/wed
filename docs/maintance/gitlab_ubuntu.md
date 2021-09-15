ubuntu 安装和配置 GitLab
===================

 ** 一、概述 **
========

GitLab 是一个基于 Web 的开源 Git 软件仓库管理器，用 Ruby 编写，包括 wiki，问题管理，代码审查，监控以及[持续集成](https://cloud.tencent.com/product/coding-ci?from=10680)和部署。它使开发人员能够创建，审查和部署他们的项目。

有三种不同版本的 GitLab 可用，社区版 (CE) ，企业版 (EE) 和 GitLab 托管版本。

如果你想远离 [GitHub](https://github.com/) ， [GitLab](https://about.gitlab.com/) 是首选。它可以从不同的来源导入项目和问题，包括 GitHub ，这使得迁移过程无忧无虑。 GitLab 界面设计精良，干净，直观，并且在用户体验和功能方面与 GitHub 相近。

根据所需的用例，有几种方法可以安装 GitLab 。本教程介绍了使用 Omnibus 软件包在 Ubuntu 18.04 系统上安装和配置 GitLab (CE) 所需的步骤。

**二、安装**
========

官方的建议是使用脚本直接执行安装，对于网络不好的情况，还是直接下载安装包吧。

下载安装包，访问链接：

[https://packages.gitlab.com/gitlab/gitlab-ce](https://packages.gitlab.com/gitlab/gitlab-ce)

这里选择最新版本，gitlab-ce\_12.1.4-ce.0\_amd64.deb

wget \--content\-disposition https://packages.gitlab.com/gitlab/gitlab\-ce/packages/ubuntu/xenial/gitlab\-ce\_12.1.4\-ce.0\_amd64.deb/download.deb

本地安装

dpkg \-i gitlab\-ce\_12.1.4\-ce.0\_amd64.deb

出现以下提示，表示安装成功

\*.                  \*.
      \*\*\*                 \*\*\*
     \*\*\*\*\*               \*\*\*\*\*
    .\*\*\*\*\*\*             \*\*\*\*\*\*\*
    \*\*\*\*\*\*\*\*            \*\*\*\*\*\*\*\*
   ,,,,,,,,,\*\*\*\*\*\*\*\*\*\*\*,,,,,,,,,
  ,,,,,,,,,,,\*\*\*\*\*\*\*\*\*,,,,,,,,,,,
  .,,,,,,,,,,,\*\*\*\*\*\*\*,,,,,,,,,,,,
      ,,,,,,,,,\*\*\*\*\*,,,,,,,,,.
         ,,,,,,,\*\*\*\*,,,,,,
            .,,,\*\*\*,,,,
                ,\*,.



     \_\_\_\_\_\_\_ \_\_  \_\_          \_\_
    / \_\_\_\_(\_) /\_/ /   \_\_\_\_ \_/ /\_
   / / \_\_/ / \_\_/ /   / \_\_ \`/ \_\_ \\
  / /\_/ / / /\_/ /\_\_\_/ /\_/ / /\_/ /
  \\\_\_\_\_/\_/\\\_\_/\_\_\_\_\_/\\\_\_,\_/\_.\_\_\_/

**修改配置文件**
----------

vim /etc/gitlab/gitlab.rb

修改以下信息

external\_url 'http://192.168.10.123:80'
......
gitlab\_rails\['time\_zone'\] \= 'Asia/Shanghai'
gitlab\_rails\['gitlab\_email\_from'\] \= 'xxxxxx@163.com'
......
gitlab\_rails\['smtp\_enable'\] \= true
gitlab\_rails\['smtp\_address'\] \= "smtp.163.com"
gitlab\_rails\['smtp\_port'\] \= 25
gitlab\_rails\['smtp\_user\_name'\] \= "xxxxxx@163.com"
gitlab\_rails\['smtp\_password'\] \= "111111" # 客户端授权密码
gitlab\_rails\['smtp\_domain'\] \= "163.com"
gitlab\_rails\['smtp\_authentication'\] \= "login"
gitlab\_rails\['smtp\_enable\_starttls\_auto'\] \= true
......
user\["git\_user\_email"\] \= "xxxxxx@163.com"

只要修改配置文件就要reconfigure

sudo gitlab\-ctl reconfigure

查看状态

root@ubuntu:~\# gitlab\-ctl status
run: alertmanager: (pid 12758) 66s; run: log: (pid 12379) 219s
run: gitaly: (pid 12684) 70s; run: log: (pid 11883) 357s
run: gitlab\-monitor: (pid 12721) 69s; run: log: (pid 12309) 240s
run: gitlab\-workhorse: (pid 12708) 70s; run: log: (pid 12226) 264s
run: grafana: (pid 12781) 65s; run: log: (pid 12538) 113s
run: logrotate: (pid 12259) 253s; run: log: (pid 12268) 252s
run: nginx: (pid 12242) 259s; run: log: (pid 12250) 258s
run: node\-exporter: (pid 12715) 69s; run: log: (pid 12296) 244s
run: postgres\-exporter: (pid 12770) 65s; run: log: (pid 12399) 213s
run: postgresql: (pid 12004) 349s; run: log: (pid 12016) 346s
run: prometheus: (pid 12732) 69s; run: log: (pid 12351) 225s
run: redis: (pid 11840) 367s; run: log: (pid 11847) 364s
run: redis\-exporter: (pid 12725) 69s; run: log: (pid 12330) 232s
run: sidekiq: (pid 12200) 271s; run: log: (pid 12211) 270s
run: unicorn: (pid 12171) 277s; run: log: (pid 12189) 276s

**访问web页面**
-----------

初次访问Web页面会强制让你改密码，初始用户名/密码：root/5iveL!fe

![](https://ask.qcloudimg.com/http-save/yehe-2398817/ik18fmmzxd.png?imageView2/2/w/1620)

修改完密码之后，使用新的密码登录

![](https://ask.qcloudimg.com/http-save/yehe-2398817/ed1cx2k72f.png?imageView2/2/w/1620)

 登录之后，效果如下：

![](https://ask.qcloudimg.com/http-save/yehe-2398817/y9mmq2lk0x.png?imageView2/2/w/1620)

最后，附上 GitLab 常用命令：

常用命令

说明

sudo gitlab-ctl reconfigure

重新加载配置，每次修改/etc/gitlab/gitlab.rb文件之后执行

sudo gitlab-ctl status

查看 GitLab 状态

sudo gitlab-ctl start

启动 GitLab

sudo gitlab-ctl stop

停止 GitLab

sudo gitlab-ctl restart

重启 GitLab

sudo gitlab-ctl tail

查看所有日志

sudo gitlab-ctl tail nginx/gitlab\_acces.log

查看 nginx 访问日志

sudo gitlab-ctl tail postgresql

查看 postgresql 日志

本文参考链接：

[https://www.jianshu.com/p/49f60698b411](https://www.jianshu.com/p/49f60698b411)


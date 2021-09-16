Ubuntu19.1 中 GitLab 的安装配置与卸载
============================

### 文章目录

*   一、概述
*   二、搭建环境
    *   1、虚拟机配置
    *   2、开启防火墙
    *   3、安装依赖项
*   三、安装GitLab
*   四、配置GitLab
    *   1、配置域名地址
    *   2、配置 postfix
    *   3、配置SMTP服务
*   五、卸载GitLab
    *   1、停止运行
    *   2、执行卸载命令
    *   3、查看 gitlab 进程
    *   4、删除 gitlab 文件
*   六、遇到的问题
    *   1、gitlab安装报错
    *   2、启动502

一、概述
----

gitlab 是一个开源的托管 Git 的存储库。

> git相关概念： git 是一种版本控制系统，是一个命令，是一种工具 gitlib 是用于实现git功能的开发库 github 是一个基于git实现的在线[代码托管](https://cloud.tencent.com/product/coding-cr?from=10680)仓库，包含一个网站界面，向互联网开放 gitlab 是一个基于git实现的在线代码仓库托管软件，一般用于在企业内网搭建git私服 注：gitlab-ce 社区版 ；gitlab-ee是企业版，收费

二、搭建环境
------

### 1、虚拟机配置

由于 gitlab 比较吃资源，所以你要保证虚拟机给的配置应该至少是这样：

![](https://ask.qcloudimg.com/http-save/yehe-6941574/zy24sfh1wr.png?imageView2/2/w/1620)

而且安装完之后就不要再打开浏览器等其他应用程序了，不然的话就会这样：

![](https://ask.qcloudimg.com/http-save/yehe-6941574/vgacjzi4fp.png?imageView2/2/w/1620)

可以看到，CPU 和 RAM 全部爆红。

我当时心态崩了。

### 2、开启防火墙

> 由于LInux原始的防火墙工具iptables过于繁琐，所以ubuntu默认提供了一个基于iptable之上的防火墙工具`ufw`。

sudo  ufw enable|disable

查看防火墙的状态：

sudo ufw status

![](https://ask.qcloudimg.com/http-save/yehe-6941574/kqikif0dlg.png?imageView2/2/w/1620)

打开或关闭某个端口，例如：

//允许所有的外部IP访问本机的25/tcp (smtp)端口
sudo ufw allow smtp
//禁止外部访问smtp服务
sudo ufw deny smtp
//删除上面建立的某条规则
sudo ufw delete allow smtp

对于我们此次安装 gitlab 只需要保证这3个，请依次执行：

sudo ufw allow http
sudo ufw allow https
sudo ufw allow OpenSSH

### 3、安装依赖项

在我们自己安装GitLab之前，安装一些在安装过程中持续使用的软件非常重要。可以从Ubuntu的默认包存储库轻松安装所有必需的软件。

分别输入：

//刷新本地包索引
sudo apt update
//安装依赖项
sudo apt install ca\-certificates curl openssh\-server postfix

如果你安装的时候遇到了如下图的问题：

![](https://ask.qcloudimg.com/http-save/yehe-6941574/yy15f9ypbp.png?imageView2/2/w/1620)

请参考我的这篇文章换源：[换源](https://blog.csdn.net/weixin_43941364/article/details/104538867)，完了回来再继续下面的操作：

![](https://ask.qcloudimg.com/http-save/yehe-6941574/c65rd4k9rb.png?imageView2/2/w/1620)

*   安装过程会有图形界面选项，一直回车就行了

可能会让你设置一个邮箱：

//我设置成了这个,随便设置的,后面可以改，可以选择回车跳过
 wsuo@ubuntu\-gitlab.com

打开HTTP和SSH端口：

 iptables \-I INPUT \-m tcp \-p tcp \--dport 22 \-j ACCEPT
 iptables \-I INPUT \-m tcp \-p tcp \--dport 80 \-j ACCEPT
 //如果提示你 Permission Denied 就是说权限不足,解决办法就是在前面加上 sudo
 //或者切换到管理员 : sudo su

*   如果要卸载的话执行:

apt\-get \--purge remove postfix

三、安装GitLab
----------

官方下载地址太慢了，这里我们换源：

1、首先信任 GitLab 的 GPG 公钥:

curl https://packages.gitlab.com/gpg.key 2\> /dev/null | sudo apt\-key add \- &\>/dev/null

2、然后用root账户，打开vi：

sudo su
vi /etc/apt/sources.list.d/gitlab\-ce.list

3、将下面的内容粘贴进去

deb https://mirrors.tuna.tsinghua.edu.cn/gitlab\-ce/ubuntu xenial main
//粘贴至文本中，按Esc键，键入:，最后输入wq保存并退出。

4、安装 gitlab-ce:

sudo apt\-get update
sudo apt\-get install gitlab\-ce

![](https://ask.qcloudimg.com/http-save/yehe-6941574/l3e90du6m3.png?imageView2/2/w/1620)![](https://ask.qcloudimg.com/http-save/yehe-6941574/4vrpfgcwnv.png?imageView2/2/w/1620)

5、打开 sshd 和 postfix 服务

service sshd start
service postfix start

6、安装完成之后启动gitlab

初次启动会比较漫长，如果电脑配置低会卡成狗。

补充：时间是超级无敌长，由你的电脑配置决定。

sudo gitlab\-ctl reconfigure

7、在浏览器中打开：http://127.0.0.1。

但是不建议在虚拟机中这么做，建议先获取虚拟机的 ip 地址，然后在自己的电脑上访问，比如我的 ip 地址为 192.168.2.105 ，可以这样访问：

http://192.168.2.105

获取 ip 地址的方法:

ifconfig
//如果没有net-tools,按照他的提示安装.
//好像是这个命令
apt install net\-tools

> 首次使用时，GitLab会提示设置密码，默认配置的是root用户的密码，设置后就可以正常使用了。

![](https://ask.qcloudimg.com/http-save/yehe-6941574/6gnsa0xpcb.png?imageView2/2/w/1620)![](https://ask.qcloudimg.com/http-save/yehe-6941574/x77gby2lrb.png?imageView2/2/w/1620)

四、配置GitLab
----------

### 1、配置域名地址

1、敲入`vim /etc/gitlab/gitlab.rb`打开文件，将`external_url = 'http://git.example.com'`修改成自己的 IP 或者 HostName，比如：

external\_url \= 'http://192.168.2.105'

![](https://ask.qcloudimg.com/http-save/yehe-6941574/bgejll1izv.png?imageView2/2/w/1620)

* * *

> 以下为高级操作，小白请无视

### 2、配置 postfix

配置 GitLab 的发件邮箱，我们可以使用下面命令，测试发布发送邮件：

执行下面的进行命令测试发送邮件:

sudo apt\-get install mailutils

echo "Test mail from postfix" ws2821@yeah.net

要等很久才能收到邮件，建议先去干别的事情。

然后过一会他会莫名其妙的有个提示：

![](https://ask.qcloudimg.com/http-save/yehe-6941574/x5th634jtn.png?imageView2/2/w/1620)

我当时很害怕，但是又很好奇，于是我就进去看看：

vim /var/mail/root

打开之后：

![](https://ask.qcloudimg.com/http-save/yehe-6941574/6h3rb8t81d.png?imageView2/2/w/1620)

把系统发件邮箱地址记下来：

![](https://ask.qcloudimg.com/http-save/yehe-6941574/tgug12wmzg.png?imageView2/2/w/1620)

我是这个：

"MAILER-DAEMON@wsuo"@ubuntu\-gitlab.com

然后再打开`vim /etc/gitlab/gitlab.rb`文件，将`gitlab_rails['gitlab_email_from'] = 'gitlab@example.com'`修改为系统发件邮箱地址：

gitlab\_rails\['gitlab\_email\_from'\] \= '"MAILER-DAEMON@wsuo"@ubuntu-gitlab.com'

![](https://ask.qcloudimg.com/http-save/yehe-6941574/108wz8pyuh.png?imageView2/2/w/1620)

上面这些配置好之后，就可以启动 GitLab 了：

sudo gitlab\-ctl reconfigure

### 3、配置SMTP服务

如果你觉得这样太繁琐了，可以不设置，对你的操作没有任何影响，只是接收不到邮件消息，也可以使用腾讯的邮件系统：

> 修改GitLab邮件服务配置(gitlab.rb文件)，使用腾讯企业邮箱的SMTP服务器，填写账号和密码

gitlab\_rails\['smtp\_address'\] \= "smtp.exmail.qq.com"
gitlab\_rails\['smtp\_port'\] \= 25
gitlab\_rails\['smtp\_user\_name'\] \= "xxx"
gitlab\_rails\['smtp\_password'\] \= "xxx"
gitlab\_rails\['smtp\_domain'\] \= "smtp.qq.com"
gitlab\_rails\['smtp\_authentication'\] \= 'plain'
gitlab\_rails\['smtp\_enable\_starttls\_auto'\] \= true

使配置生效：

gitlab\-ctl reconfigure
gitlab\-rake cache:clear RAILS\_ENV\=production      # 清除缓存

附上常用命令:

![](https://ask.qcloudimg.com/http-save/yehe-6941574/hirc8y3qb5.png?imageView2/2/w/1620)

//查看版本信息
cat /opt/gitlab/embedded/service/gitlab\-rails/VERSION

//12.8.1

五、卸载GitLab
----------

装完就后悔了，卡的都不能动，因为装完之后它默认开机自启动。好好的虚拟机被败坏成什么样了？

于是我觉得还我的 Ubuntu 一个青春亮丽的形象，把可恶的 gitlab 卸载掉：

卸载之前我们先看一下它安装到哪个位置了，因为我们是通过 `apt` 命令安装的，所以他会安装在 `/opt` 目录下，我们来看一下是不是这样子的：

![](https://ask.qcloudimg.com/http-save/yehe-6941574/31d97qiq41.png?imageView2/2/w/1620)

我们发现这小子果然在这里，那他就死定了。

下面执行我们的灭绝计划：

### 1、停止运行

sudo gitlab\-ctl stop

![](https://ask.qcloudimg.com/http-save/yehe-6941574/kgpmsy3y4u.png?imageView2/2/w/1620)

### 2、执行卸载命令

执行下面的命令，后重启系统

> 这块注意了，看看是 gitlab-ce 版本还是 gitlab-ee 版本，别写错误了

//因为我们是使用 新立得 安装的所以直接执行命令
sudo apt\-get remove gitlab\-ce    等价于这条命令:  sudo apt\-get \--purge remove gitlab\-ce
//执行完这个命令就可以了,你的电脑上就卸载了这个软件,如果你想更彻底的删除,可以继续执行下面的命令
# 删除暂存的软件安装包
sudo apt\-get clean gitlab\-ce

删除过程中会让你输入一次 `y`：

![](https://ask.qcloudimg.com/http-save/yehe-6941574/25irqffic4.png?imageView2/2/w/1620)

执行完之后再去看一看，发现原来的文件里只有 2M 了：

### 3、查看 gitlab 进程

ps \-ef|grep gitlab

杀死第一个进程：

kill \-9 8922

然后在查看就没有了。

### 4、删除 gitlab 文件

//删除所有包含gitlab的文件及目录
find / \-name gitlab|xargs rm \-rf 

删除`gitlab-ctl uninstall`时自动在`root`下备份的配置文件：

cd /root
rm \-rf /root/gitlab然后按tab自动补全

比如我的是:

root@ubuntu:~\# rm \-rf gitlab\-cleanse\-2020\-02\-29T08\\:43/

六、遇到的问题
-------

### 1、gitlab安装报错

执行`sudo apt-get install gitlab-ce`时报错：

文字信息如下：

There was an error running gitlab\-ctl reconfigure:

gitlab\_sysctl\[kernel.shmmax\] (postgresql::enable line 67) had an error: Mixlib::ShellOut::ShellCommandFailed: execute\[load sysctl conf kernel.shmmax\] (/opt/gitlab/embedded/cookbooks/cache/cookbooks/package/resources/gitlab\_sysctl.rb line 46) had an error: Mixlib::ShellOut::ShellCommandFailed: Expected process to exit with \[0\], but received '255'
\--\-- Begin output of sysctl \-e \--system \--\--
STDOUT: \* Applying /etc/sysctl.d/10\-console\-messages.conf ...
kernel.printk \= 4 4 1 7
\* Applying /etc/sysctl.d/10\-ipv6\-privacy.conf ...
net.ipv6.conf.all.use\_tempaddr \= 2
net.ipv6.conf.default.use\_tempaddr \= 2
\* Applying /etc/sysctl.d/10\-kernel\-hardening.conf ...
kernel.kptr\_restrict \= 1
\* Applying /etc/sysctl.d/10\-link\-restrictions.conf ...
fs.protected\_hardlinks \= 1
fs.protected\_symlinks \= 1
\* Applying /etc/sysctl.d/10\-magic\-sysrq.conf ...
kernel.sysrq \= 176
\* Applying /etc/sysctl.d/10\-network\-security.conf ...
net.ipv4.conf.default.rp\_filter \= 2
net.ipv4.conf.all.rp\_filter \= 2
\* Applying /etc/sysctl.d/10\-ptrace.conf ...
kernel.yama.ptrace\_scope \= 1
\* Applying /etc/sysctl.d/10\-zeropage.conf ...
vm.mmap\_min\_addr \= 65536
\* Applying /usr/lib/sysctl.d/30\-tracker.conf ...
fs.inotify.max\_user\_watches \= 65536
\* Applying /usr/lib/sysctl.d/50\-default.conf ...
net.ipv4.conf.all.promote\_secondaries \= 1
net.core.default\_qdisc \= fq\_codel
\* Applying /etc/sysctl.d/90\-omnibus\-gitlab\-kernel.sem.conf ...
\* Applying /etc/sysctl.d/90\-omnibus\-gitlab\-kernel.shmall.conf ...
\* Applying /etc/sysctl.d/90\-omnibus\-gitlab\-kernel.shmmax.conf ...
kernel.shmmax \= 17179869184
\* Applying /etc/sysctl.d/90\-omnibus\-gitlab\-net.core.somaxconn.conf ...
\* Applying /etc/sysctl.d/99\-sysctl.conf ...
\* Applying /etc/sysctl.d/protect\-links.conf ...
fs.protected\_hardlinks \= 1
fs.protected\_symlinks \= 1
\* Applying /etc/sysctl.conf ...
STDERR: sysctl: cannot open "/etc/sysctl.d/90-omnibus-gitlab-kernel.sem.conf": 没有那个文件或目录
sysctl: cannot open "/etc/sysctl.d/90-omnibus-gitlab-kernel.shmall.conf": 没有那个文件或目录
sysctl: cannot open "/etc/sysctl.d/90-omnibus-gitlab-net.core.somaxconn.conf": 没有那个文件或目录
\--\-- End output of sysctl \-e \--system \--\--
Ran sysctl \-e \--system returned 255

全是红色的，我当时吓坏了。

去GitLab论坛找到了解决方案：

touch /opt/gitlab/embedded/etc/90\-omnibus\-gitlab\-kernel.sem.conf
touch /opt/gitlab/embedded/etc/90\-omnibus\-gitlab\-net.core.somaxconn.conf

### 2、启动502

我服了，本来好好的，突然莫名其妙就502了，我猜想是 timeout 的问题，去配置文件里找到它设置时间长一点应该就好了：

1、打开文件：

vim /etc/gitlab/gitlab.rb

2、修改时间

找到这两个地方：

> gitlab\_rails\[‘webhook\_timeout’\] = 90 gitlab\_rails\[‘git\_timeout’\]=90

3、更新配置文件

sudo gitlab\-ctl reconfigure

* * *

然后我修改完上述文件就好了，如果你还不行？

试试修改端口：

unicorn\['port'\] \= 8888

gitlab\_workhorse\['auth\_backend'\] \= "http://localhost:8888" 

注意：unicorn\['port'\]与gitlab\_workhorse\['auth\_backend'\]的端口必须相同

如果你还不行，请回去执行第五步-卸载-重装。

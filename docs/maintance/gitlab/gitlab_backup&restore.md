[Linux]记一次gitlab代码仓库备份迁移]
==========================

    由于公司的云平台需要进行一次彻底的升级，所以被告知部门的gitlab代码库需要做一次备份迁移。
    
    由于之前没尝试过，接着又是整个部门的代码库，还是谨慎一点好，毕竟一旦崩了，影响就大了。
    
    整个过程经过两天的时间，从等待临时的虚拟机环境，安装新的gitlab环境，执行gitlab备份，恢复备份，每一步多多少少都有点坑。

操作系统
----------------

*   CentOS 7.5

前提准备
----------------

gitlab需要依赖一些基础工具，官网上也有说。https://about.gitlab.com/install/
<pre><code>sudo yum install -y curl policycoreutils-python openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd
sudo firewall-cmd --permanent --add-service=http
sudo systemctl reload firewalld
</code></pre>
<p>我发现新机子默认这些工具都已经默认安装完的了，防火墙看需求是否开吧，一般基于安全都需要开。</p>
<p>如果需要用到gitlab邮件能力，还需要安装邮件工具并启动服务：</p>
<pre><code>sudo yum install postfix
sudo systemctl enable postfix
sudo systemctl start postfix
</code></pre>
<h2 id=)[](# "新环境gitlab的安装")新环境gitlab的安装

由于是迁移备份，网上都说新gitlab的版本需要和原有的一致，不然可能会问题。

如果是简单安装最新版本gitlab的话，gitlab官网给出的是执行官方的shell脚本，想必原理是下载rpm文件接着安装。

那手动安装就是下载对应版本gitlab.rpm文件执行安装。[下载链接190514](https://packages.gitlab.com/gitlab/gitlab-ce)

安装命令：


EXTERNAL_URL="http://IP:PORT" rpm -i gitlab-ee-9.5.2-ee.0.el7.x86_64.rpm

新环境gitlab的配置
--------------------------------

rpm安装完后，默认gitlab的配置文件路径为：


/etc/gitlab/gitlab.rb

默认的应用内容目录路径为（包括默认的仓库路径和备份路径，这两个等会会用到）：


/var/opt/gitlab/

当前修改的配置：

1.  unicorn服务的端口，默认是8080，但是很多机子的8080都可能占用


    # unicorn['port'] = 8080
    unicorn['port'] = 8889

2.  访问限制，默认单IP限制次数为10，这个太小了，由于当前是内网，所以放开这个限制


    # gitlab_rails['rack_attack_git_basic_auth'] = {
    #    'enabled' => true,
    #    'ip_whitelist' => ["127.0.0.1"] ,
    #    'maxretry' => 10,
    #    'findtime' => 60,
    #    'bantime' => 3600
    #}
    gitlab_rails['rack_attack_git_basic_auth'] = {
        'enabled' => true,
        'ip_whitelist' => ["127.0.0.1"] ,
        'maxretry' => 10000,
        'findtime' => 60,
        'bantime' => 3600
    }

3.  备份目录，可自行修改

    # gitlab_rails['backup_path'] = "/var/opt/gitlab/backups"
    gitlab_rails['backup_path'] = "/gitlab/backup/path"

4.  仓库路径，可自行修改


    #git_data_dirs({
    #    "default" => {
    #        "path" => "/var/opt/gitlab/git-data"
    #    }
    #})
    git_data_dirs({
        "default" => {
            "path" => "/gitlab/repos/data/path"
        }
    })


修改完配置文件执行`gitlab-ctl reconfigure`来重启服务使配置生效，刚开始没有该配置，导致恢复备份两次都失败，原因就是默认路径下的空间不足，囧

备份旧的gitlab
----------------------------

执行命令进行备份，将会生成一个命名格式为`<timestamp>_<date>_<gitlab-version>_gitlab_backup.tar`


    gitlab-rake gitlab:backup:create

由于旧的gitlab有个定时任务，每日凌晨3点会执行一次备份，不然手动执行需要差不多一个小时，定时任务shell脚本

time=$(date "+%Y%m%d%H%M%S")
path="/var/opt/gitlab/backups/"
gitlab-rake gitlab:backup:create > ${path}${time}\_gitlab\_backup.log

复制备份文件到新机子
----------------------------

可以使用scp命令传到新机子的gitlab备份目录中，因为gitlab的备份恢复命令会从备份目录查找对应的备份文件

在新机子执行备份恢复
----------------------------

先停止相关服务，这一步貌似如果gitlab没人正在使用的话，貌似是可以不关闭的，测试了也不会出错，但是稳妥还是关闭一下


gitlab-ctl stop unicorn
gitlab-ctl stop sidekiq

执行备份恢复命令


gitlab-rake gitlab:backup:restore BACKUP=<timestamp>_<date>_<gitlab-version>

这个过程也是很漫长，现在备份文件20G，执行起来需要足足半个小时来恢复，慢慢等吧

执行完成后可以恢复之前关闭的相关服务，或者重启整个gitlab服务也行。

至此，gitlab就通过备份恢复完毕了，用户数据，仓库数据，群组数据都能恢复。
gitlab 数据配置迁移
=============
最开始gitlab是部署在公司内网的机器上，现在需要将gitlab迁移至阿里云上。以下是迁移的详细步骤。

准备工作
----

首先需要做的准备有这些。原系统为CentOS 7.4。

### 安装相同版本的gitlab

*   查看gitlab版本

        cat /opt/gitlab/embedded/service/gitlab-rails/VERSION


    根据系统以及gitlab版本去[清华大学镜像站\_gitlab-ce](https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/)下载特定版本的gitlab的RPM或者DEB包。

         # CentOS 6
         https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el6
         https://mirrors.tuna.tsinghua.edu.cn/gitlab-ee/yum/el6
         # CentOS 7
         https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7
         https://mirrors.tuna.tsinghua.edu.cn/gitlab-ee/yum/el7
         # Debian 9
         https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/debian/pool/stretch/main/g/gitlab-ce/
         https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/debian/pool/stretch/main/g/gitlab-ee/


*   安装gitlab

    安装gitlab比较简单

        # 下载rpm包
        wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-10.5.1-ce.0.el7.x86_64.rpm
        # 安装rpm包（在下载的rpm包目录下）
        yum install -y gitlab-ce-10.5.1-ce.0.el7.x86_64.rpm



### 备份

*   备份数据（用户信息、项目信息、代码）

    利用gitlab自带的命令`gitlab-rake`进行数据备份，备份位于`/etc/gitlab/gitlab.rb`中`gitlab_rails['backup_path']`选项对应的目录，备份目录默认位于`/var/opt/gitlab/backups`

        # 备份命令
        gitlab-rake gitlab:backup:create
        # 查看备份目录
        cat /etc/gitlab/gitlab.rb|grep gitlab_rails|grep backup_path


*   备份原服务器上的配置信息
    保存gitlab的域名、邮件发送信息、白名单等相关信息的配置文件 `/etc/gitlab/gitlab.rb`

    存储了gitlab的db secret信息的配置文件 `/etc/gitlab/gitlab-secrets.json`

*   打包备份数据和配置文件

        cp /etc/gitlab/gitlab.rb /etc/gitlab/gitlab-secrets.json /var/opt/gitlab/backups
        cd /var/opt/gitlab/backups
        tar zcvf gitlab_all_backup.tar.gz ./*



还原gitlab配置和数据
-------------

*   将打包的备份文件上传至新服务器

        scp gitlab_all_backup.tar.gz root@newHost:/tmp/
        # 登录新服务器
        ssh root@newHost
        cd /tmp
        tar zxvf gitlab_all_backup.tar.gz


*   还原配置文件
    将配置文件移到/etc/gitlab下

        cd /tmp
        # 反斜线是忽略系统的alias，不会有覆盖文件提醒，慎重使用
        \mv gitlab.rb gitlab-secrets.json /etc/gitlab/
        # 重载gitlab配置
        gitlab-ctl reconfigure


*   还原数据
    将之前备份的数据文件移到/var/opt/gitlab/backups下，然后恢复数据

        cd /tmp
        # 注意前面一串数字为时间戳，将你备份的文件移进去
        mv 1552743127_2019_03_16_10.5.1_gitlab_backup.tar /var/opt/gitlab/backups
        # 恢复数据，注意BACKUP=后面只要 _gitlab_backup.tar 前面的版本号，如下
        gitlab-rake gitlab:backup:restore BACKUP=1552743127_2019_03_16_10.5.1
        # 重载gitlab配置
        gitlab-ctl reconfigure



配置文件/etc/gitlab/gitlab.rb简介
---------------------------

    external_url 'http://gitlab.xxx.com'                                #gitlab域名
    gitlab_rails['gitlab_email_enabled'] = true                         #gitlab启用email通知
    gitlab_rails['gitlab_email_from'] = 'xxx-gitlab@xxx.com'            #gitlab email来源
    gitlab_rails['gitlab_email_display_name'] = 'gitlab-servce'         #email展示名称
    gitlab_rails['gitlab_email_reply_to'] = 'xxx-gitlab@xxx.com'        #gitlab返回邮箱地址
    gitlab_rails['gitlab_email_subject_suffix'] = ''
    gitlab_rails['manage_backup_path'] = true                           #启用backup路径配置
    gitlab_rails['backup_path'] = "/NFS"                                #设置gitlab备份路径
    gitlab_rails['gitlab_shell_ssh_port'] = xxxx                        #设置gitlab ssh端口
    gitlab_rails['git_max_size'] = 20971520
    gitlab_rails['git_timeout'] = 10
    gitlab_rails['gitlab_shell_git_timeout'] = 800
    gitlab_rails['rack_attack_git_basic_auth'] = {
       'enabled' => true,
       'ip_whitelist' => ["192.168.8.118"],                             #设置gitlab白名单列表
       'maxretry' => 300,
       'findtime' => 5,
       'bantime' => 60
    }
    gitlab_rails['initial_root_password'] = "xxxxxxx"                   #gitlab初始化root密码
    gitlab_rails['smtp_enable'] = true                                  #设置gitlab 发送邮件smtp服务器信息
    gitlab_rails['smtp_address'] = "smtp.xxx.xxx.com"                   #设置smtp服务器地址
    gitlab_rails['smtp_port'] = xxx                                     #设置smtp服务器端口
    gitlab_rails['smtp_user_name'] = "xxx-gitlab@xxx.com"               #设置smtp用户名
    gitlab_rails['smtp_password'] = "xxxxxx"                            #设置smtp密码
    gitlab_rails['smtp_domain'] = "smtp.xxx.com"                        #设置smtp域名
    gitlab_rails['smtp_authentication'] = "login"
    gitlab_rails['smtp_enable_starttls_auto'] = true
    gitlab_rails['smtp_tls'] = true
    gitlab_rails['gitlab_email_from'] = 'xxx-gitlab@xxx.com'
    git_data_dir "/data/gitlab-data"                                    #设置gitlab数据目录


    gitlab_rails['ldap_enabled'] = true                                 #设置gitlab ldap认证

    gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
      main: # 'main' is the GitLab 'provider ID' of this LDAP server
        label: 'LDAP'
        host: 'xx.xx.xx.xx'                                             #设置ldap服务器地址
        port: xxx                                                       #设置ldap服务器端口
        uid: 'cn'
        method: 'plain' # "tls" or "ssl" or "plain"
        bind_dn: 'cn=xxx,dc=xxx,dc=com'                                 #ldap bind dn
        password: 'xxx'                                                 #ldap bind dn用户对应的密码
        active_directory: true
        allow_username_or_email_login: true                             #允许用户名和邮箱登录
        block_auto_created_users: false
        base: 'dc=xxx,dc=com'                                           #ldap base dn信息，即搜索域
        attributes:
          username: ['cn', 'uid']
          email:    ['mail', 'email']
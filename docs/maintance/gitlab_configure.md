GitLab配置
========

一、Postgresql数据库远程连接配置
=====================

使用Omnibus-GitLab 进行一键安装GitLab后，自带了 PostgreSQL 作为缺省的内部数据存储，比如用户信息， 源码仓库信息等。  
PostgreSQL默认情况下，远程访问不能成功，如果需要允许远程访问，需要修改2个配置文件。

*   pg\_hba.conf
*   postgresql.conf

    ## cd /var/opt/gitlab/postgresql/data    //进入到postgresql配置文件存放位置
    ## vim pg_hba.conf 
      host    all   all  ::1/32    trust   //此行表示“本机”不需要密码即可登录 
      host    all   all  0.0.0.0/0  md5 //此行，0.0.0.0/0 代表所有ip地址可以连接，但需要密码
    ## vim postgresql.conf 
      listen_addresses = '*'    //为保证locahost、127.0.0.1、ip地址均可访问，设置为“*”
    ## gitlab-ctl restart postgresql                    //重启postgresql
    ## cd /opt/gitlab/embedded/                      //进入安装目录
    ## bin/psql -U gitlab -d gitlabhq_production -h localhost   // 不用输入密码就可进来
      psql (9.6.3)
      Type "help" for help.
    
      gitlabhq_production=> alter user gitlab with password 'gitlab';  //修改gitlab密码
       //gitlab创建的[数据库超级用户为gitlab-psql，想修改密码自己通过命令修改即可
      gitlabhq_production-> \q               //退出
    ## cd /var/opt/gitlab/postgresql/data
    ## vim pg_hba.conf
       host    all         all    ::1/32    md5      //修改trust 为md5 ，即连接需要密码
    
    ## gitlab-ctl restart postgresql        //重启
    

**注意：**既然修改了数据库gitlab用户的密码，gitlab服务器中数据库配置文件，也需要修改，不然数据库连接不上

    # cd /var/opt/gitlab/
    # vim gitlab-rails/etc/database.yml 
      adapter: postgresql
      encoding: unicode
      collation:
      database: gitlabhq_production
      pool: 10
      username: 'gitlab'
      password: 'gitlab'          #添加设置的密码
      host: '/var/opt/gitlab/postgresql'
      port: 5432
      socket:
      sslmode:
      sslrootcert:
      sslca:
      load_balancing: {"hosts":[]}
      prepared_statements: true
      statements_limit: 1000
    
    # gitlab-ctl restart
    
    # /opt/gitlab/embedded/bin/psql -U gitlab -d gitlabhq_production -h localhost
    Password for user gitlab:     


输入密码"gitlab" 回车就可以进来了  
到此，配置完成。

做了上面的配置，我们可以使用Navicat Premium 连接postgresql

_另外，查看postgresql进程日志可以查看`/var/log/gitlab/postgresql` 该路径下的 current文件_

二、配置GitLab邮箱
------------

GitLab的邮箱服务是不可或缺的一部分, 它提供了代码提交提醒, 用户密码找回，注册认证等功能. GitLab也提供了几种邮件配置方案, 有使用sendmail, postfix 及 smtp, 这里只介绍smtp, 其中sendmail太过于古老, 现在几乎被postfix替代了, 而postfix配置没有smtp方便, 当然, 最主要的还是不想启动postfix邮件服务器, 直接用第三方的服务

1\. 修改配置文件

    vi /etc/gitlab/gitlab.rb
    
    #修改如下配置
    gitlab_rails['smtp_enable'] = true
    gitlab_rails['smtp_address'] = "smtp.example.com"
    gitlab_rails['smtp_port'] = 25
    gitlab_rails['smtp_user_name'] = "gitlab@example.com"
    gitlab_rails['smtp_password'] = "123"
    gitlab_rails['smtp_domain'] = "example.com"
    gitlab_rails['smtp_authentication'] = "login"
    gitlab_rails['smtp_enable_starttls_auto'] = true
    gitlab_rails['smtp_tls'] = false

2\. 修改gitlab发信人

    #修改其发件人为GitLab 与上面保持一致
    
    gitlab_rails['gitlab_email_from'] = "gitlab@example.com"
    user["git_user_email"] = "gitlab@example.com"


> 记住这里有一个坑, 如果你不配置发件人, 有些邮件服务器会发送失败, 所以我们最好把账号和发件人都配置了, 并且保持一致, 这样保证兼容问题。

另外的问题：

> 将 `/etc/gitlab/gitlab.rb`文件中的  
> `external_url 'localhost'`  
> 改为  
> `external_url 'http://192.169.10.11' #服务器地址`  
> 这样重置密码或者登陆验证时所发送的连接地址才能指向服务器。

修改完成后，重新加载配置并重启，**注意:**重新加载配置后，postgresql远程连接需要重新修改配置文件，其密码不会变，可以在运行 `gitlab-ctl reconfigure`之前备份下文件。

    gitlab-ctl reconfigure
    gitlab-ctl restart

3.测试

安装完成后可进行“忘记密码”以及注册验证来测试邮箱服务是否可用。

#### 问题:

以上是使用邮箱代理，当申请下业务邮箱后，我依然使用上述配置，邮箱依然不可用，查看`/var/log/gitlab/sidekiq/current`日志报出如下错误：【证书与服务器不符】

    WARN: OpenSSL::SSL::SSLError: hostname "mail.host.com" does not match the server certificate
    WARN: /opt/gitlab/embedded/lib/ruby/2.3.0/openssl/ssl.rb:318:in `post_connection_check'


#### 解决办法：

不加入验证

    修改/etc/gitlab/gitlab.rb文件
    
    gitlab_rails['smtp_openssl_verify_mode'] = 'none'


三、GitLab日常配置
------------

1.  gitlab配置文件路径： /etc/gitlab/gitlab.rb
2.  修改地址为外网地址：`external_url 'http://herbguo.gitlabserver.com'`  
    修改后再次执行`sudo gitlab-ctl reconfigure`以便配置修改生效。

gitlab 默认的数据库是 PostgreSQL ，用它官网的话来说就是“The World’s Most Advanced Open Source Relational Database”。

一般情况下，我们没有必要去直接访问它。但是，没必要不代表没需求。gitlab 结构、用户数据、配置信息等。

值得注意的是：

> 在 GitLab 12.1 中删除了对 MySQL 的支持。建议在 MySQL / MariaDB 上使用 GitLab 的现有用户在升级之前迁移到 PostgreSQL。  
> 从 GitLab 10.0 开始，需要 PostgreSQL 9.6 或更高版本，并且不支持较早的版本。我们强烈建议用户使用 PostgreSQL 9.6，因为这是用于开发和测试的 PostgreSQL 版本。

[](# "本地访问 PostgreSQL")本地访问 PostgreSQL
======================================

gitlab 默认有可以直接访问内部 postgreSQL 的命令：

    sudo gitlab-rails dbconsole
    或者
    sudo gitlab-psql -d gitlabhq_production

这样就进入了 postgreSQL 命令窗口，可以输入 sql 语句进行作业。例如，输入`\list`查看所有数据库：

    sanotsu@sanotsu-ubt18:~$ sudo gitlab-rails dbconsole
    psql (10.9)
    Type "help" for help.
    
    gitlabhq_production=> \list
                                                 List of databases
            Name         |    Owner    | Encoding |   Collate   |    Ctype    |        Access privileges
    ---------------------+-------------+----------+-------------+-------------+---------------------------------
     gitlabhq_production | gitlab      | UTF8     | zh_CN.UTF-8 | zh_CN.UTF-8 |
     postgres            | gitlab-psql | UTF8     | zh_CN.UTF-8 | zh_CN.UTF-8 |
     template0           | gitlab-psql | UTF8     | zh_CN.UTF-8 | zh_CN.UTF-8 | =c/"gitlab-psql"               +
                         |             |          |             |             | "gitlab-psql"=CTc/"gitlab-psql"
     template1           | gitlab-psql | UTF8     | zh_CN.UTF-8 | zh_CN.UTF-8 | =c/"gitlab-psql"               +
                         |             |          |             |             | "gitlab-psql"=CTc/"gitlab-psql"
    (4 rows)
    
    gitlabhq_production=>

或者输入`select * from namespaces;`查看 gitlab 中已经有了哪些用户。  
输入`select * from projects;`查看有哪些项目文件等等。

**注意，在不能完全把控风险的情况下，最好不要擅自使用 SQL 的 DDL、DML、DCL 语言，避免造成 gitlab 运行意外。**

**特别注意：**  
这里显示的 Name 有 4 个，除了 gitlabhq\_porduction 的 owner 是 gitlab 之外，其它的是 gitlab-psql。  
所以，在连接到 gitlab 内部的 postgresql 数据库时，指定数据库名称为 gitlabhq\_porduction 才有实际意义，才能看到需要的信息。  
这里的 dbconsole 默认是选择的 gitlabhq\_production，但后续外部连接就不一定了。  
因为我去看过其它几个数据库，啥都没有，我还以为是权限问题，不让我看，搞了半天……

[](# "配置远程访问 PostgreSQL")配置远程访问 PostgreSQL
==========================================

默认情况下，外部是无法访问 Gitlab 内部的 postgreSQL 的。实际上，现在很多的数据库，在初始默认安装时，都不允许外部直接访问的。

[](# "了解一下 Gitlab 数据库各个配置文件(不感兴趣可跳到下一节)")了解一下 Gitlab 数据库各个配置文件(不感兴趣可跳到下一节)
--------------------------------------------------------------------------

要验证上述结论，除了亲自在外部试连之外，还可以直接看配置文件。

默认的 gitlab 数据库配置文件在`/var/opt/gitlab/gitlab-rails/etc/databse.yml`。

打开之后，看到的内容应该如下：

    # This file is managed by gitlab-ctl. Manual changes will be
    # erased! To change the contents below, edit /etc/gitlab/gitlab.rb
    # and run `sudo gitlab-ctl reconfigure`.
    
    production:
      adapter: postgresql
      encoding: unicode
      collation:
      database: gitlabhq_production
      pool: 1
      username: "gitlab"
      password:
      host: "/var/opt/gitlab/postgresql"
      port: 5432
      socket:
      sslmode:
      sslcompression: 0
      sslrootcert:
      sslca:
      load_balancing: {"hosts":[]}
      prepared_statements: false
      statements_limit: 1000
      fdw:

可以看到，host 属性的值是本地文件路径，外部自然连不到的。

当然，可以直接查看 postgreSQL 的用户权限配置文件查看，默认路径在`/var/opt/gitlab/postgresql/data/pg_hba.conf`。

打开默认应该可以看到只有这样一句配置（Local）：

    # TYPE  DATABASE    USER        CIDR-ADDRESS          METHOD
    
    # "local" is for Unix domain socket connections only
    local   all         all                               peer map=gitlab

此外，在同路径下的`postgresql.conf`文件中，也能看到（监控地址为空）：

    # - Connection Settings -
    
    listen_addresses = ''    # what IP address(es) to listen on;
              # comma-separated list of addresses;
              # defaults to 'localhost', '*' = all
              # (change requires restart)
    port = 5432        # (change requires restart)
    max_connections = 200      # (change requires restart)

以上内容，也为了更加清楚的认识各个文件的构成和作用。

[](# "修改 gitlab 配置文件实现远程访问 PostgreSQL")修改 gitlab 配置文件实现远程访问 PostgreSQL
----------------------------------------------------------------------

实际上，可以一一修改上述文件去实现远程访问，只不过就是重启 gitlab 之后失效。  
但是从配置文件修改，更加简单，一劳永逸。

打开`/etc/gitlab/gitlab.rb`配置文件，找到`## Gitlab PostgreSQL`区块，在`### Advanced settings`最末，加上以下内容：

    postgresql['listen_address'] = '{gitlab主机IP}'
    postgresql['port'] = 5432
    postgresql['trust_auth_cidr_addresses'] = %w(127.0.0.1/24)
    postgresql['md5_auth_cidr_addresses'] = %w({gitlab主机IP}/0)
    postgresql['sql_user'] = "gitlab"
    postgresql['sql_user_password'] = Digest::MD5.hexdigest "gitlab" << postgresql['sql_user']

把{gitlab 主机 IP}替换成你 gitlab 主机的真实 IP 即可。

其实把{gitlab 主机 IP}和 127.0.0.1 换成 0.0.0.0 也行。  
如果不清楚限制，全部给到最大总能有效。

这几行的配置分别是：

*   添加 postgresql 的监听地址，
*   添加 postgresql 的监听端口，
*   本地访问(127.0.0.1 或者 localhost)postgresql 不用输密码，
*   需要输入密码的访问地址，
*   连接到 postgresql 数据库的账号(示例中为 gitlab)，
*   连接到 postgresql 数据库的密码(示例中为 gitlab)。

然后，找到`### Gitlab database settings`，在最末添加以下内容：

    gitlab_rails['db_username'] = "gitlab"
    gitlab_rails['db_password'] = "gitlab"
    gitlab_rails['db_host'] = "{gitlab主机IP}"
    gitlab_rails['db_port'] = 5432
    gitlab_rails['db_database'] = "gitlabhq_production"

依次是：数据库用户名、密码、地址、端口和默认数据库名称。  
如果不设定最后一行，那么默认连接的数据库就是 postgres。

到这里，配置就修改完了，运行`sudo gitlab-ctl reconfigure`重新加载配置运行。

**注意，重新加载配置运行时，可能会从出现以下错误：**

    There was an error running gitlab-ctl reconfigure:
    
    bash[migrate gitlab-rails database] (gitlab::database_migrations line 54) had an error: Mixlib::ShellOut::ShellCommandFailed: Expected process to exit with [0], but received '1'
    ---- Begin output of "bash"  "/tmp/chef-script20191224-30773-18wzcfl" ----
    STDOUT: rake aborted!
    PG::ConnectionBad: FATAL:  no pg_hba.conf entry for host "192.168.XX.XX", user "gitlab", database "gitlabhq_production", SSL on
    FATAL:  no pg_hba.conf entry for host "192.168.XX.XX", user "gitlab", database "gitlabhq_production", SSL off
    /opt/gitlab/embedded/service/gitlab-rails/lib/tasks/gitlab/db.rake:48:in `block (3 levels) in '
    /opt/gitlab/embedded/bin/bundle:23:in `load'
    /opt/gitlab/embedded/bin/bundle:23:in `

那是因为，需要重启 postgresql，重新配置才能生效。  
所以，先运行`sudo gitlab-ctl restart postgresql`，再运行`sudo gitlab-ctl reconfigure`即可。

在旧一点的版本，7.x，8.x，9.x，10.x，11.x 我似乎都没有遇到过。可能是新数据库需求和版本有了变化吧。

其它的配置，按照实际需求添加即可，也可访问官网[数据库设置](https://docs.gitlab.com/omnibus/settings/database.html)查看更多信息

到此，应该就可以在远程连接`192.168.XX.XX`（你的 gitlab 主机 IP），通过账号 gitlab、密码 gitlab 连接到 gitlab 内部的 postgresql 数据库了。

[](# "关系型数据库图形化工具(GUI)推荐及连接说明")关系型数据库图形化工具(GUI)推荐及连接说明
======================================================

之前我使用连接到 postgresql 的图形化工具是 PgAdmin4，连接 mysql 用的是 MySQL Workbench，还有连接 SQL Server 用了 SQL Server Management Studio，连接 mariadb 用了 heidiSQL，还有 SQLite 等，遇到一个就去找一个，很麻烦，其实也没必要。

最近我发现一个还不错的 GUI，ce 版本可以支持连接这绝大部分常用的关系型数据库，叫 DBeaver。nosql 也支持，不过这部分就要收费了。所以我上面才没有列 Redis，MongoDB 什么的。

[![](https://swmlee.com/../images/TechnicalEssays/AboutGit/remote-access-gitlab-ce-postgresql/DBeaver%E8%BF%9E%E6%8E%A5%E7%95%8C%E9%9D%A2.png)](https://swmlee.com/../images/TechnicalEssays/AboutGit/remote-access-gitlab-ce-postgresql/DBeaver%E8%BF%9E%E6%8E%A5%E7%95%8C%E9%9D%A2.png)

Windows 下，直接去[dbeaver 官网](https://dbeaver.io/download/)下载一个安装包即可。

linux 下稍微麻烦一点，以 Ubuntu18 为例，安装 DBeaver：

1、因为 DBeaver 是 java base，所以需要安装 java，openjdk 即可

    sudo apt-get install openjdk-8-jdk

2、 添加 GPG key：

    wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -

3、 添加仓库：

    echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list

4、 更新，然后安装

    sudo apt update
    sudo apt -y  install dbeaver-ce

5、 检查 dbeaver 版本,有就安装成功

    apt policy  dbeaver-ce

使用上就是选择连接的数据库类型，输入地址、端口、账号、密码、数据库名称等等，就不赘述了。

工作界面如下：

[![](https://swmlee.com/../images/TechnicalEssays/AboutGit/remote-access-gitlab-ce-postgresql/DBeaver%E8%BF%9E%E6%8E%A5postgresql%E5%B7%A5%E4%BD%9C%E7%95%8C%E9%9D%A2.png)](https://swmlee.com/../images/TechnicalEssays/AboutGit/remote-access-gitlab-ce-postgresql/DBeaver%E8%BF%9E%E6%8E%A5postgresql%E5%B7%A5%E4%BD%9C%E7%95%8C%E9%9D%A2.png)

**注意，如果在外部使用 DBeaver 或者其它 GUI 连接到 gitlab 内部的 postgresql 时，没有填写数据库名称为 gitlabhq\_production，那默认连接的就是 postgres。**

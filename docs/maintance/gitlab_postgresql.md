[将gitlab中的postgresql数据库开通远程访问](https://www.cnblogs.com/andy9468/p/10609682.html)
================================================================================

postgresql数据库是gitlab的一个配置数据库，记录gitlab的一些配置信息。

我们访问gitlab中的postgresql数据有本地命令行访问和远程可视化软件访问2种方式。

（一）本地命令访问postgresql

参考：[https://www.cnblogs.com/sfnz/p/7131287.html?utm\_source=itdadao&utm\_medium=referral](https://www.cnblogs.com/sfnz/p/7131287.html?utm_source=itdadao&utm_medium=referral)

su - gitlab-psql //登陆用户


psql -h /var/opt/gitlab/postgresql -d gitlabhq\_production //连接到gitlabhq\_production库


\\l //查看数据库


\\dt //查看多表


\\d users //查看单表，如users表


SELECT name,username,otp\_required\_for\_login,two\_factor\_grace\_period, require\_two\_factor\_authentication\_from\_group FROM users;  
//查看users表中用户的关键信息，取4个字段


退出psql使用\\q，接着按下回车就行了。

（二）远程可视化软件访问【此方法并不推荐，因为访问gitlab中的postgresql数据库并不需要密码，存在风险。工作时，请用完就把相关配置文件复原，阻断远程访问】【非常重要！！！！】

使用Navicat访问postgresql数据库，就可以图形界面操作了。

但是，在连接之前需要到postgresql数据库所在Linux系统中去配置一下，使其提供远程访问的服务。

![](https://img2018.cnblogs.com/blog/552284/201903/552284-20190327181536454-464351709.png)

1、修改gitlab.rb

vim /etc/gitlab/gitlab.rb

配置为：

postgresql\['enable'\] = true  
postgresql\['listen\_address'\] = '0.0.0.0'  
postgresql\['port'\] = 5432  
postgresql\['data\_dir'\] = "/var/opt/gitlab/postgresql/data"

![](https://img2018.cnblogs.com/blog/552284/201903/552284-20190327181758634-1923128717.png)

更优配置：远程访问gitlab的postgresql数据库  
替代（二）中的2、3、4步骤。

继续修改gitlab.rb

请移步：

[https://www.cnblogs.com/andy9468/p/10613091.html](https://www.cnblogs.com/andy9468/p/10613091.html)

2、使得gitlab.rb的修改生效

gitlab-ctl  reconfigure 

等待报错。没办法，上述修改，必然引发报错。

![](https://img2018.cnblogs.com/blog/552284/201903/552284-20190327182113806-2032424750.png)

3、修改pg\_hba.conf

vim   /var/opt/gitlab/postgresql/data/pg\_hba.conf

修改为：

host   all    all    0.0.0.0/0    trust

注意：从此，不能再执行gitlab-ctl  reconfigure 命令了，因为如果再执行gitlab-ctl  reconfigure ，那么pg\_hba.conf的修改就会被还原。

![](https://img2018.cnblogs.com/blog/552284/201903/552284-20190327182413031-842892832.png)

4、使得pg\_hba.conf生效

生效前，先查看端口5432

netstat -antp |grep :5432

发现端口5432还没有启动

执行restart，使得配置生效（端口5432生效）。

gitlab-ctl   restart

注意：从此，不能再执行gitlab-ctl  reconfigure 命令了，因为如果在执行，pg\_hba.conf的修改就会被还原。

 ![](https://img2018.cnblogs.com/blog/552284/201903/552284-20190327182901587-967301760.png)

再查看端口，发现5432存在了。

netstat -antp |grep :5432

![](https://img2018.cnblogs.com/blog/552284/201903/552284-20190327182851195-1520504489.png)

5、访问前telnet测试和端口5432的连通性

telnet  gitlab所在机器的ip地址   5432

如果不报错，就算连通了。

6、Navicat连接postgresql数据库

![](https://img2018.cnblogs.com/blog/552284/201903/552284-20190327183409217-2004314538.png)

![](https://img2018.cnblogs.com/blog/552284/201903/552284-20190327183449799-1944145698.png)

 连接测试

![](https://img2018.cnblogs.com/blog/552284/201903/552284-20190327183519099-1239763448.png)

![](https://img2018.cnblogs.com/blog/552284/201903/552284-20190327184040449-2069380585.png)

 【此方法并不推荐，因为访问gitlab中的postgresql数据库并不需要密码，存在风险。工作时，请用完就把相关配置文件复原，阻断远程访问】【非常重要！！！！】


由于汉化版本都低于英文版本，为了不产生不必要的麻烦就要先下载汉化包，查看汉化包的版本号，根据汉化包的版本号来安装指定版本的GitLab。若你安装的版本是最新的比汉化包高太多，那么你汉化时需要忽略数百到上千次的文件。若你是刚装的GitLab，可以考虑重新卸载后安装和汉化包版本一致的版本。下面是如何彻底卸载GitLab。  
1、停止gitlab

    gitlab-ctl stop


2、卸载gitlab（注意这里写的是gitlab-ce）

    rpm -e gitlab-ce


3、查看gitlab进程

    ps aux | grep gitlab


![](https://img-blog.csdnimg.cn/20181206141925341.jpeg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ppYTEyMjE2,size_16,color_FFFFFF,t_70)  
4、杀掉第一个进程（就是带有好多…的进程）  
杀掉后，在ps aux | grep gitlab确认一遍，还有没有gitlab的进程。若还存在，可以把它的主要组件的进程也杀一边。

    run: alertmanager: (pid 100019) 13376s; run: log: (pid 82025) 86211s
    run: gitaly: (pid 100032) 13376s; run: log: (pid 82041) 86211s
    run: gitlab-monitor: (pid 100047) 13375s; run: log: (pid 82047) 86211s
    run: gitlab-workhorse: (pid 100054) 13375s; run: log: (pid 82031) 86211s
    run: logrotate: (pid 121160) 2574s; run: log: (pid 82039) 86211s
    run: nginx: (pid 100070) 13374s; run: log: (pid 82037) 86211s
    run: node-exporter: (pid 100077) 13374s; run: log: (pid 82027) 86211s
    run: postgres-exporter: (pid 100082) 13373s; run: log: (pid 82023) 86211s
    run: postgresql: (pid 100097) 13372s; run: log: (pid 82035) 86211s
    run: prometheus: (pid 100100) 13372s; run: log: (pid 82021) 86211s
    run: redis: (pid 100114) 13372s; run: log: (pid 82033) 86211s
    run: redis-exporter: (pid 100118) 13371s; run: log: (pid 82043) 86211s
    run: sidekiq: (pid 100124) 13370s; run: log: (pid 82029) 86211s
    run: unicorn: (pid 100136) 13369s; run: log: (pid 82045) 86211s


日志的进程不用管。  
5、删除所有包含gitlab文件

    find / -name gitlab | xargs rm -rf


当然若你没有全杀权限。那么可以可以把这三个目录给干掉也可以：

    rm -rf  /opt/gitlab
    rm -rf  /etc/gitlab
    rm -rf  /var/log/gitlab


6、重新安装制定版本命令  
sudo yum install gitlab-ce-x.x.x #安装指定版本

    sudo yum install gitlab-ce-11.4.8


7、修改配置网址和重定向仓库目录`sudo vim /etc/gitlab/gitlab.rb`，刷新配置卡在下面的情况的处理。

    Recipe: gitlab::gitlab-rails
      * execute[clear the gitlab-rails cache] action run


解决方案：

    1.按住CTRL+C强制结束；
    
    2.运行：sudo systemctl restart gitlab-runsvdir；
    
    3.再次执行：sudo gitlab-ctl reconfigure


8、刷新配置后需要重启。  
若用命令sudo gitlab-ctl status查看服务状态是停止就执行启动命令：

    sudo gitlab-ctl start


若用命令`sudo gitlab-ctl status`查看服务状态是运行状态就执行重启命令`sudo gitlab-ctl restart`；也可以先停止`sudo gitlab-ctl stop`，再启动`sudo gitlab-ctl start`。
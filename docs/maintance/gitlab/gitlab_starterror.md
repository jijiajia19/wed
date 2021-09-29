# 执行gitlab-ctl start 提示全部启动失败解决办法

[root@localhost gitlab]# gitlab-ctl start
fail: alertmanager: runsv not running
fail: gitaly: runsv not running
fail: gitlab-exporter: runsv not running
fail: gitlab-workhorse: runsv not running
fail: grafana: runsv not running
fail: logrotate: runsv not running
fail: nginx: runsv not running
fail: node-exporter: runsv not running
fail: postgres-exporter: runsv not running
fail: postgresql: runsv not running
fail: prometheus: runsv not running
fail: redis: runsv not running
fail: redis-exporter: runsv not running
fail: sidekiq: runsv not running
fail: unicorn: runsv not running

**先执行**

| 1    | sudo systemctl start gitlab-runsvdir |
| ---- | ------------------------------------ |
|      |                                      |

**然后在执行**

| 1    | sudo gitlab-ctl restart |
| ---- | ----------------------- |
|      |                         |
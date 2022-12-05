yum install rsync

---

配置rsync:

> 1. port=3306              *#端口 根据服务器策略调整*
> 2. uid = root  
> 3. gid = root
> 4. use chroot = no
> 5. max connections = 4    *#连接数*
> 6. pid file = /usr/local/rsync/rsyncd.pid
> 7. lock file = /usr/local/rsync/rsync.lock
> 8. log file = /usr/local/rsync/rsyncd.log
> 9. [down]                 *#这是文件的位置 可以设置多个*
> 10. path = /data/mysqlFile
> 11. auth user = root     
> 12. uid = root              
> 13. gid = root
> 14. read only = no
> 15. secrets file = /etc/rsyncd.secrets *#配置连接的密码 格式为 ww:密码*
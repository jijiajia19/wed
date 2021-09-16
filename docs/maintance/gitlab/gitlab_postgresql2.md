[访问GitLab的PostgreSQL数据库]
=========================================================================

1.登陆gitlab的安装服务查看配置文件

cat /var/opt/gitlab/gitlab-rails/etc/database.yml 

production:
  adapter: postgresql
  encoding: unicode
  collation:
  database: gitlabhq\_production  //数据库名
  pool: 10
  username: 'gitlab'  //用户名
  password:
  host: '/var/opt/gitlab/postgresql'  //主机
  port: 5432
  socket:
  sslmode:
  sslrootcert:
  sslca:

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

查看/etc/passwd文件里边gitlab对应的系统用户

\[root@localhost ~\]# cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
gitlab\-www:x:496:493::/var/opt/gitlab/nginx:/bin/false
git:x:495:492::/var/opt/gitlab:/bin/sh
gitlab\-redis:x:494:491::/var/opt/gitlab/redis:/bin/false
gitlab\-psql:x:493:490::/var/opt/gitlab/postgresql:/bin/sh  //gitlab的postgresql用户

2.根据上面的配置信息登陆postgresql数据库

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

\[root@localhost ~\]# su - gitlab-psql     //登陆用户

\-sh-4.1$ psql -h /var/opt/gitlab/postgresql -d gitlabhq\_production   连接到gitlabhq\_production库

psql (9.2.18)  
Type "help" for help.

gitlabhq\_production=#  \\h    查看帮助命令

Available help:  
ABORT CREATE FUNCTION DROP TABLE  
ALTER AGGREGATE CREATE GROUP DROP TABLESPACE  
ALTER COLLATION CREATE INDEX DROP TEXT SEARCH CONFIGURATION  
ALTER CONVERSION CREATE LANGUAGE DROP TEXT SEARCH DICTIONARY  
ALTER DATABASE CREATE OPERATOR DROP TEXT SEARCH PARSER  
ALTER DEFAULT PRIVILEGES CREATE OPERATOR CLASS DROP TEXT SEARCH TEMPLATE  
ALTER DOMAIN CREATE OPERATOR FAMILY DROP TRIGGER  
ALTER EXTENSION CREATE ROLE DROP TYPE

……………………………………………………………………………………………………………………

gitlabhq\_production-# \\l     //查看数据库  
List of databases  
Name | Owner | Encoding | Collate | Ctype | Access privileges  
\---------------------+-------------+----------+-------------+-------------+---------------------------------  
gitlabhq\_production | gitlab | UTF8 | en\_US.UTF-8 | en\_US.UTF-8 |  
postgres | gitlab-psql | UTF8 | en\_US.UTF-8 | en\_US.UTF-8 |  
template0 | gitlab-psql | UTF8 | en\_US.UTF-8 | en\_US.UTF-8 | =c/"gitlab-psql" +  
| | | | | "gitlab-psql"=CTc/"gitlab-psql"  
template1 | gitlab-psql | UTF8 | en\_US.UTF-8 | en\_US.UTF-8 | =c/"gitlab-psql" +  
| | | | | "gitlab-psql"=CTc/"gitlab-psql"  
(4 rows)

gitlabhq\_production-# \\dt   //查看多表  
List of relations  
Schema | Name | Type | Owner  
\--------+--------------------------------------+-------+--------  
public | abuse\_reports | table | gitlab  
public | appearances | table | gitlab  
public | application\_settings | table | gitlab  
public | audit\_events | table | gitlab  
public | award\_emoji | table | gitlab  
public | boards | table | gitlab  
public | broadcast\_messages | table | gitlab

……………………………………………………………………………………………………………………

gitlabhq\_production-# \\d abuse\_reports    //查看单表  
Table "public.abuse\_reports"  
Column | Type | Modifiers  
\--------------+-----------------------------+------------------------------------------------------------  
id | integer | not null default nextval('abuse\_reports\_id\_seq'::regclass)  
reporter\_id | integer |  
user\_id | integer |  
message | text |  
created\_at | timestamp without time zone |  
updated\_at | timestamp without time zone |  
message\_html | text |  
Indexes:  
"abuse\_reports\_pkey" PRIMARY KEY, btree (id)

gitlabhq\_production-# \\di    //查看索引  
List of relations  
Schema | Name | Type | Owner | Table  

\--------+-----------------------------------------------------------------+-------+--------+--------------------------------  
\------  
public | abuse\_reports\_pkey | index | gitlab | abuse\_reports  
public | appearances\_pkey | index | gitlab | appearances  
public | application\_settings\_pkey | index | gitlab | application\_settings  
public | audit\_events\_pkey | index | gitlab | audit\_events  
public | award\_emoji\_pkey | index | gitlab | award\_emoji  
public | boards\_pkey | index | gitlab | boards  
public | broadcast\_messages\_pkey | index | gitlab | broadcast\_messages  
public | chat\_names\_pkey | index | gitlab | chat\_names  
public | ci\_application\_settings\_pkey | index | gitlab | ci\_application\_settings  
public | ci\_builds\_pkey | index | gitlab | ci\_builds  
public | ci\_commits\_pkey | index | gitlab | ci\_commits

………………………………………………………………………………………………………………………………………………

gitlabhq\_production=# SELECT spcname FROM pg\_tablespace;  //查看所有表空间

spcname  
\------------  
pg\_default  
pg\_global  
(2 rows)

gitlabhq\_production-# \\q    //退出psql  
\-sh-4.1$ exit                //退出登录用户  
logout

## nginx基础内容

> 一键安装上面四个依赖
>
>  yum -y install gcc zlib zlib-devel pcre-devel openssl openssl-devel



#### 多个主机名对应一个IP

>     server {
>         listen       80;
>         server_name  v1.apexdata.com.cn;
>
>
>         location / {
>             root   html;
>             index  v1.html;
>         }
>
>
> ​       
>     ​    error_page   500 502 503 504  /50x.html;
>     ​    location = /50x.html {
>     ​        root   html;
>     ​    }
>     
>     }
>     
>         server {
>         listen       80;
>         server_name  v2.apexdata.com.cn;
>
>
>         location / {
>             root   html;
>             index  v2.html;
>         }
>
>
> ​       
>     ​    error_page   500 502 503 504  /50x.html;
>     ​    location = /50x.html {
>     ​        root   html;
>     ​    }
>     
>     }



>1、二级域名
>
>2、短网址
>
>3、HttpDNS  APP和CS架构用的比较多，BS无法使用



#### URL REWRITE

>对地址进行转换，从安全和使用角度来隐藏信息

#### 反向代理

> 业务代理，流量不大
>
> 文件访问代理，文件服务代理会比业务代理大很多
>
> 负载算法、重试机制等
>
> proxy_pass默认不支持https，需要配置证书
>
>  
>
> weight= 1 down/backup
>
> url_hash 固定资源不在同一服务器
>
> 实际生产，通过lua来自定义转发规则
>
>  
>
> session可以通过spring-session来实现集群化session共享
>
> 高并发是通过token来进行权限校验服务器
>
>  
>
> keepalive通过vip的漂移切换访问；

#### 盗链监测 

> 通过监测refer来进行判断

#### CURL 

> curl -I url显示连接日志
>
> curl -e 会设置refer头报文内容

#### 安全

> 对称加密和非对称加密
>
>  常用的非对称有RSA和ECC
>
> https:
>
> 1、443先获取公钥
>
> 2、发送 公钥加密 ,公钥解不开
>
> 3、获取 私钥解密

安装工具 oneinstack



#### 安装ssl证书

> key和pem文件是官方授权的证书，选择不同的服务器证书版本，放置到conf下
>
> 配置文件修改:nginx.conf
>
> ​	设置两个文件的位置和443端口访问server
>
>  
>
> http转https:
>
> > return 301  https://$server_name$request_uri



---

# ngnix 高效性能配置

> 扩容：垂直单机、集群化(机器部署代码一样)、细粒度拆分（数据拆分、服务拆分、入口细分）
>
> 服务异步化：拆分请求、消息中间件解耦

> 会话管理:nginx iphash(nginx的管理方式)\springsession(java的处理方式)
>
> iphash不更改代码，迅速扩容。
>
> $request_uri保持会话。
>
> $cookie_jsessionid保持会话。
>
> 
>
> 大量的ip分发集中,服务机宕机session信息消失
>
> 但是适用于:中小型项目，快速扩容；



### 水平集群化

> sticky模块  对静态server的会话保持。
>
> 安装sticky:
>
> ```
> #必备编译环境
> yum -y install gcc gcc-c++ autoconf automake make wget
> #必备依赖环境
> yum -y install zlib zlib-devel openssl openssl-devel pcre pcre-devel
> ```

js img会通过缓存来进行使用，而不是通过keep-alive使用

> 接口的高频请求，keep-alive可以关闭掉
>
> keepalive_timeout=0就是关闭此功能
>
> >    #keepalive_timeout  0;
> >     #活跃时间，第一次点击和下次重复65s
> >     keepalive_timeout  65;
> >     #tcp通道保持时长，超过时间强制关闭
> >     #keepalive_time 1h;
> >     #请求准备过程中，超时时间
> >     send_timeout 60;
> >     keepalive_requests 1000;

### nginx对于上游服务器配置

> nginx反向代理之后，header会被清除掉
>
> > upstream配置项:
> >
> > keepalive 100;
> >
> > keppalive_requests 1000;
> >
> > keepalive_timeout 65;
>
> > location配置项:
> >
> > proxy_http_version 1.1;
> >
> > proxy_set_header_Connection "";

#### HTTP压测

yum install httpd-tools

ab -n 10000 -c 100  http://xxx.xx.x/ （注意最后的斜杠）



proxy_buffer 上游服务器缓冲到buffer(内存)内部，解决上下游速率不一致情况

针对body:

proxy_buffering on 内存不够使用硬盘

proxy_max_temp_file_size向磁盘写入缓冲数据大小

proxy_temp_path磁盘缓冲数据文件目录



客户端的配置:

> http/server/location
>
> client_header_buffer_size 非常大使用large_client_header_buffer_size
>
> client_body_buffer_size 对客户端body的缓冲区大小配置 32位8k  64位16k
>
> client_body_temp_path 文件缓冲目录位置
>
> client_max_body_size客户端body体大小，0表示禁用
>
> client_header_timeout
>
> client_body_timeout
>
> client_body_in_file_only on 调试时写文件，一般不配置

> 如何获取上游服务器的真实IP地址:
>
> proxy_set_header x-forward-for $remote_ip

> gzip配置：
>
> gzip on
>
> gzip_buffers 16 8k #64位
>
> gzip_comp_level 6 #1表示基本不压缩
>
> gzip_http_version 1.1
>
> gzip_min_length 256 #压缩大小阈值
>
> gzip_proxied any #off和any都不做限制,只对反向代理服务器有效
>
> gzip_vary on  #可以忽略
>
> gzip_types text/plain application/x-javascript text/css application/xml
>
> OR
>
> gzip_types
>     text/xml application/xml application/atom+xml application/rss+xml application/xhtml+xml image/svg+xml
>     text/javascript application/javascript application/x-javascript
>     text/x-json application/json application/x-web-app-manifest+json
>     text/css text/plain text/x-component
>     font/opentype application/x-font-ttf application/vnd.ms-fontobject
>     image/x-icon
>
> gzip_disable 一般不使用

./configure --prefix=/usr/local/nginx_1.20/ --with-http_gzip_static_module --with-http_gunzip_module

## gzip动态开启，sendfile就失效了，新的nginx特性

> 静态压缩，不影响sendfile
>
> ```
> touch index.html.gz -r index.html  （保证同源，修改时间一致）
> ```



---

brotli压缩方式，浏览器有限使用brotli。

chrome默认只有在https下才支持br

> load_module "/usr/local/nginx/modules/ngx_http_brotli_filter_module.so";
> load_module "/usr/local/nginx/modules/ngx_http_brotli_static_module.so";
>
>  
>
> ​    brotli on;
> ​    brotli_static on;
> ​	brotli_comp_level 6;
> ​	brotli_buffers 16 8k;
> ​	brotli_min_length 20;
> ​	brotli_types text/plain text/css text/javascript application/javascript text/xml application/xml application/xml+rss application/json image/jpeg image/gif image/png;

> curl -H "accept-encoding:br" localhost:8080 -I

---

请求合并

示例: https://g.alicdn.com/??secdev/entry/index.js,alilog/oneplus/entry.js 

href="??color.css,color2.css"

通过安装ngx-http-concat模块插件来解决，静态请求合并的问题

通过sprite image来解决图片多次请求的问题

---

处理高并发的方案

- 资源静态化

  例如:详情页，访问并发或访问次数比较高的页面

  从数据库拉取的数据，生成静态方案。从而共享提高并发读取速度。

  模板引擎需要经过渲染，最终以流的形式输出静态页面。

  输出可以放置于文件，或者放置于浏览器显示。

  openrestry-->可以内置模板引擎，落地到本地磁盘，解决静态文件不存在的情况。

  

  - 静态资源在集群之间同步
  - 静态资源是多个页面，不会进行合并,通过页面引用来进行设置，方案：前端合并；后端合并

  






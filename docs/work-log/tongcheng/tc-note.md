健康管理：
health_device   device_monitor_data device_monitor_data_detail device_monitor

237c38e6-e3a3-443f-bf57-a6a3155884e5

sc.exe create rp-1 binpath=C:\Windows\SysWOW64\ReverseProxy.exe type=share start=auto displayname= "rp"

sc create reverprox binpath=D:\BaiduNetdiskDownload\ReverseProxy_windows_amd64.exe

net localgroup administrators network service

----------------------------------------------------------------------------------------------------

https://center.javablade.com/blade/BladeX-Tool/src/branch/master/doc/mvn/mvn%E5%91%BD%E4%BB%A4.md
--bladex
1182483697
13037544

----------------------------------------------------------------------------------------------------
mvn install:install-file -Dfile=blade-core-1.0.jar -DgroupId=org.springblade -DartifactId=blade-core -Dversion=1.0 -Dpackaging=jar



---

> 'version' contains an expression but should be a constant.  ???
>
> \>mvn versions:set -DnewVersion=0.0.2-SNAPSHOT
>
> \>mvn versions:update-child-modules

---

| `<pluginRepositories> ` |                                                              |
| ----------------------- | ------------------------------------------------------------ |
|                         | `        <pluginRepository> `                                |
|                         | `            <id>aliyun-plugin</id> `                        |
|                         | `            <url>http://maven.aliyun.com/nexus/content/groups/public/</url> ` |
|                         | `            <snapshots> `                                   |
|                         | `                <enabled>false</enabled> `                  |
|                         | `            </snapshots> `                                  |
|                         | `        </pluginRepository> `                               |
|                         | `    </pluginRepositories>`                                  |

---

```
<groupId>org.springblade</groupId>
<artifactId>BladeX-Biz-Archetype</artifactId>
<version>1.0.0.RELEASE</version>
```

---

annotation:

1. 新增属性 
2. 编译时执行操作
3. 替代配置文件
4. 反射时解析重用annotation

加了注解的bean能够整合在一起，属性、方法，从而实现多个调用，组织起来。

---

运行时注解处理器、编译时注解处理器

build可以，但是maven的compiler时根据maven依赖，反而运行不行

---

SPI机制：

java 的SPI通过serviceLoader遍历实现。


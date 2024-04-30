  ### 健康管理

> 1. 健康管理设备清单 ：纳入管理的设备，新建时update
>
> 2. 健康状态码表： nacos配置
>
> 3. 健康项目检测表-一级类别 ： 设备-检测项目（大类） 映射表 
>
>    > EHM.序号，6个为默认监测大类，允许修改。
>
> 4. 健康项目监测表-二级参数：设备检测类别 。
>
>    > EHM.05.0x 二级参数名称格式。
>
> 老版本对应表：
>
> 1. health_device   
> 2. device_monitor_data 
> 3. device_monitor_data_detail 
> 4. device_monitor
>
> 

> Q:
>
> 1. 计划的状态、权限怎么体现？原型中？
> 2. 维护和撤销 如何操作，对应内容？--工作流
> 3. 计划类型？



接口：

1. 监测中设备列表--监测计划（不分页），条件【OR】：1、设备名称-模糊 2、设备编号、设备位置排序
2. 新建监测计划

> 1.选中计划新建，复制计划明细
>
> 2.没有选择，新建监测明细接口
>
> > 3. 隐藏接口，



---

梳理：

1. 监控设备查询接口
2. 所有设备查询接口
3. 设备监测项目接口-新增、修改、删除
4. 设备监测项目参数表接口-新增、修改、删除





---

```
<distributionManagement>
    <!--正式版本-->
    <repository>
        <!-- nexus服务器中用户名：在settings.xml中<server>的id-->
        <id>releases</id>
        <!-- 这个名称自己定义 -->
        <name>Release repository</name>
        <url>http://172.29.208.3:9999/repository/tc_release/</url>
    </repository>
    <!--快照-->
    <snapshotRepository>
        <!-- nexus服务器中用户名：在settings.xml中<server>的id-->
        <id>snapshots</id>
        <!-- 这个名称自己定义 -->
        <name>Snapshots repository</name>
        <url>http://172.29.208.3:9999/repository/tc_hosted/</url>
    </snapshotRepository>
</distributionManagement>
```

mvn install:install-file "-DgroupId=com.oracle" "-DartifactId=ojdbc7" "-Dversion=12.1.0.2" "-Dpackaging=jar" "-Dfile=D:/ojdbc7-12.1.0.2.jar"



mvn deploy:deploy-file \

  -Dfile=path/to/your/my-artifact-1.0.jar \

  -DgroupId=com.example \

  -DartifactId=my-artifact \

  -Dversion=1.0 \

  -DrepositoryId=my-repository \

  -Durl=https://my.repository.com/repo/path

https://nexus.saas.hand-china.com/content/repositories/rdc/com/oracle/ojdbc7/12.1.0.2/ojdbc7-12.1.0.2.jar



mvn dependency:tree -Dverbose > tree.txt

---

> table:
>
> 1. monitor_item 监测项目码表
> 2. device_monitor监测中的设备,绑定监测项目
> 3. health_device 已经绑定了监控项目的设备，与device_monitor同时更新
> 4. device_monitor_data 监测设备总数值结果
> 5. device_monitor_data_detail 监测参数数值汇总表
> 6. parameter参数表--所有的参数
> 7. device_monitor_paramater选择监测的参数

---

 `id` bigint NOT NULL AUTO_INCREMENT,
  `device_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '设备编码',
  `monitor_item_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '检测项目编码',
  `parameter_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参数编码 EHM.01.01-EMH.03.04.固定参数，非新增的检测项参数',
  `weight` double DEFAULT NULL COMMENT '参数权重',
  `standard_value` double DEFAULT NULL COMMENT '标准值',
  `low_value` double DEFAULT NULL COMMENT '下限',
  `high_value` double DEFAULT NULL COMMENT '上限',
  `device_id` bigint DEFAULT NULL COMMENT '设备Id',
  `order_num` int DEFAULT NULL,
  `parameter_name` varchar(100) DEFAULT NULL COMMENT '参数名称',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',


  	//健康项目分值
  	private BigDecimal healthSummaryIndex;

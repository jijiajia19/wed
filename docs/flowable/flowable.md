flowable-ui的镜像实例。

docker run --name flowable-ui -p 8080:8080 -d --restart=always flowable/flowable-ui



ACT_RE_*存储静态信息的表：流程定义

ACT_RU_*运行过程数据，运行完成自动删除

ACT_HI_*运行过程归档历史

ACT_GE_*一般数据，包括自带的流程图

ACT_ID_*表示用户、用户组相关信息

flw_*表示扩展新功能的列表



#### 二、数据库表结构 (34 张表，不同版本数量可能会有出入)

**一般数据 (2)**

ACT_GE_BYTEARRAY 通用的流程定义和流程资源
ACT_GE_PROPERTY 系统相关属性

**流程历史记录 (8)**

ACT_HI_ACTINST 历史的流程实例
ACT_HI_ATTACHMENT 历史的流程附件
ACT_HI_COMMENT 历史的说明性信息
ACT_HI_DETAIL 历史的流程运行中的细节信息
ACT_HI_IDENTITYLINK 历史的流程运行过程中用户关系
ACT_HI_PROCINST 历史的流程实例
ACT_HI_TASKINST 历史的任务实例
ACT_HI_VARINST 历史的流程运行中的变量信息

**用户用户组表 (9)**

ACT_ID_BYTEARRAY 二进制数据表
ACT_ID_GROUP 用户组信息表
ACT_ID_INFO 用户信息详情表
ACT_ID_MEMBERSHIP 人与组关系表
ACT_ID_PRIV 权限表
ACT_ID_PRIV_MAPPING 用户或组权限关系表
ACT_ID_PROPERTY 属性表
ACT_ID_TOKEN 系统登录日志表
ACT_ID_USER 用户表

**流程定义表 (3)**

ACT_RE_DEPLOYMENT 部署单元信息
ACT_RE_MODEL 模型信息
ACT_RE_PROCDEF 已部署的流程定义

**运行实例表 (10)**

ACT_RU_DEADLETTER_JOB 正在运行的任务表
ACT_RU_EVENT_SUBSCR 运行时事件
ACT_RU_EXECUTION 运行时流程执行实例
ACT_RU_HISTORY_JOB 历史作业表
ACT_RU_IDENTITYLINK 运行时用户关系信息
ACT_RU_JOB 运行时作业表
ACT_RU_SUSPENDED_JOB 暂停作业表
ACT_RU_TASK 运行时任务表
ACT_RU_TIMER_JOB 定时作业表
ACT_RU_VARIABLE 运行时变量表

**其他表 (2)**

ACT_EVT_LOG 事件日志表
ACT_PROCDEF_INFO 流程定义信息

---

Java访问Flowable接口，执行流程处理。

BPMN业务流程建模标注。

独占任务：单独进行处理。

> 注意点：要确保数据库版本跟flowable版本一致。

> docker run --name flowable-ui -p 8980:8080 \
> -e spring.datasource.driver-class-name="com.mysql.cj.jdbc.Driver" \
> -e spring.datasource.url="jdbc:mysql:// 172.20.101.80:3306/localflowable?useUnicode=true&characterEncoding=UTF-8&nullCatalogMeansCurrent = true&useSSL=false" \
> -e spring.datasource.username=root \
> -e spring.datasource.password=root \
> -v /home/mysql-connector-j-8.0.31.jar:/app/WEB-INF/lib/mysql-connector-java-8.0.27.jar \
> -d --restart=always flowable/flowable-ui

多人会签是指一个任务需要多个人来审批。多人或签是指的=一个任务需要多个人中的一个审批通过即可。

任务类型：

     1. serviceTask 不停止，自动执行代理方法。
     2. receivetask
     3. usertask
     
     call activity调用，复用代码。
     
     发布：
     ACT_RE_DEPLOYMENT
     ACT_RE_PROCDEF
     
     开启流程：
     ACT_RU_ACTINST 存储实例节点信息
     ACT_RU_IDENTITYLINK 存储审批人信息
     
     操作流程：
     1. act_re_deployment 表中会有一条部署记录，记录这次部署的基本信息，然后是act_ge_bytearray表中有两条记录，记录的是本次上传的bpmn文件和对应的图片文件，每条记录都有act_re_deployment表的外键关联，然后是act_re_procdef表中有一条记录，记录的是该bpmn文件包含的基本信息，包含act_re_deployment表外键。
     2. 首先向act_ru_execution表中插入一条记录，记录的是这个流程定义的执行实例，其中id和proc_inst_id相同都是流程执行实例id，也就是本次执行这个流程定义的id，包含流程定义的id外键(leave:1:9f51f9c4-1a65-11ea-83ef-f8a2d6bfea5a)。
     3. 然后向act_ru_task插入一条记录，记录的是第一个任务的信息，也就是开始执行第一个任务。包括act_ru_execution表中的execution_id外键和proc_inst_id外键，也就是本次执行实例id。
     4.然后向act_hi_procinst表和act_hi_taskinst表中各插入一条记录，记录的是本次执行实例和任务的历史记录：
     5. 首先向act_ru_variable表中插入变量信息，包含本次流程执行实例的两个id外键，但不包括任务的id，因为setVariable方法设置的是全局变量，也就是整个流程都会有效的变量：
     6. 执行完task1办理后，act_ru_task表中task1的记录被删除，新插入task2的记录：
     7. 同时向act_hi_var_inst和act_hi_taskinst插入历史记录
     8. 以上代码是查询本流程执行实例下的task2并完成task2。
     9. 此时整个流程执行完毕，act_ru_task，act_ru_execution和act_ru_variable表全被清空
     10. 其实全程有一个表一直在记录所有动作，就是act_hi_actinst表
         以上这段代码是查询act_hi_varinst表中变量历史记录的。因为流程执行完毕act_ru_variable表被清空。
     
     
     监听器：事件监听器、执行监听器、任务监听器。
     可以在全局或者节点进行事件的监听。
     执行监听器是配置在开始、启用、结束。
             start 开始
            take 启用
            end 结束
     任务监听器主要配置在usertask上。
             create 任务已经创建
            assignment 已经分配办理人
            complete 任务已经完成
            delete 任务即将被删除
     
     全局事件监听器，配置事件监听器。
     

将所有的变量，保存在表单之中。

表单可以为json表单和html表单。

> 表单：内置表单和外置表单
>
> StartFormData、TaskFormData两种方式。
>
> 通过动态表单来替代零散的变量方式。

表单分为：流程开始表单和流程中表单。
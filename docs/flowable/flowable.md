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










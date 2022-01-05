1. localdatetime\localdate java8 的api使用，序列化和反序列化？
2. springboot请求消息转换器，替换jackson为fastjson?

---

# [@JSONField注解的使用](https://www.cnblogs.com/yucy/p/9057049.html)

```
FastJson中的注解@JSONField，一般作用在get/set方法上面，常用的使用场景有下面三个：
```

- 修改和json字符串的字段映射【name】
- 格式化数据【format】
- 过滤掉不需要序列化的字段【serialize】

**一、修改字段映射使用方法：**

```
　　private Integer aid;
　　// 实体类序列化为json字符串的时候，此类的aid字段，序列化为json中的testid字段
　　@JSONField(name="testid") 
　　public Integer getAid() {
　　    return aid;
　　}

　　// json字符串解析为类实体的时候，json中的id字段，写入此类的aid字段
　　@JSONField(name="id")
　　public void setAid(Integer aid) {
　　    this.aid = aid;
　　}
二、格式化使用方法
　　@JSONField(format = "yyyy-MM-dd HH:mm:ss")
　　public Date getDateCompleted(...)

三、过滤不需要序列化的字段
　　@JSONField(serialize = false)
　　public Integer getProgress() {
    　　return progress;
　　}
```
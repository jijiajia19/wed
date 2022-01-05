java.lang.NoSuchMethodError: com.alibaba.fastjson.serializer.JavaBeanSerializer.processValue(Lcom/alibaba/fastjson/serializer/JSONSerializer;Lcom/alibaba/fastjson/serializer/BeanContext;Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;Ljava/lang/Integer;
at com.alibaba.fastjson.serializer.ASMSerializer_12_XXX.writeNormal(Unknown Source) ~[?:?]
at com.alibaba.fastjson.serializer.ASMSerializer_12_XXX.write(Unknown Source) ~[?:?]
at com.alibaba.fastjson.serializer.JSONSerializer.write(JSONSerializer.java:285) ~[fastjson-1.2.61.jar:?]
at com.alibaba.fastjson.JSON.toJSONString(JSON.java:663) ~[fastjson-1.2.61.jar:?]
at com.alibaba.fastjson.JSON.toJSONString(JSON.java:652) ~[fastjson-1.2.61.jar:?]



> 暂时没有办法，只能回退到1.2.60 版本，解决问题。


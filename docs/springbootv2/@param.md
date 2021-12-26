@Param注解的使用和解析

---

作用：用注解来简化xml配置的时候（比如Mybatis的Mapper.xml中的sql参数引入），@Param注解的作用是给参数命名,参数命名后就能根据名字得到参数值,正确的将参数传入sql语句中（一般通过#{}的方式，${}会有sql注入的问题）。

实例说明：

1，使用@Param注解  

Mapper接口方法：

 public int getUsersDetail(@Param("userid") int userid);
对应Sql Mapper.xml文件：

 <select id="getUserDetail" statementType="CALLABLE" resultMap="baseMap">
          Exec WebApi_Get_CustomerList #{userid}
 </select>
说明：

当你使用了使用@Param注解来声明参数时，如果使用 #{} 或 ${} 的方式都可以,当你不使用@Param注解来声明参数时，必须使用使用 #{}方式。如果使用 ${} 的方式，会报错。

2,不使用@Param注解

不使用@Param注解时，最好传递 Javabean。在SQL语句里就可以直接引用JavaBean的属性，而且只能引用JavaBean存在的属性。

Mapper接口方法：

 public int getUsersDetail(User user);
对应Sql Mapper.xml文件：

 <!--这里直接引用对象属性即可，不需要对象.属性的方式--> 



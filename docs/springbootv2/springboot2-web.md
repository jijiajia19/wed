### web开发两种方式

1. 前后端分离，restful接口对接
2. 使用内置的模板开发web应用



内置模板，指的是后端模板，前端模板是js解析页面html标记；

后端模板表示的是解析标记，填充数据，最终返回的是html页面；



SpringBoot跟JSP联合使用，必须使用plugin:springboot-run来启动；否则出现404



---

springBoot文件上传：

- 主要使用**MultipartFile**

- MultipartFile是个接口,它的实现类有CommonsMultipartFile和StandardMultipartFile,这里简单说明:

  1. CommonsMultipartFile: 是基于apache fileupload的解析;

  2.  StandardMultipartFile: 是基于j2ee自带的文件上传进行解析,也就是使用Servlet3.0提供的javax.servlet.http.Part上传方式

  

  > 我们在正常使用MultipartFile时,无需关心底层是以哪种方式进行文件上传处理的,SpringMVC会给我们做相应的转换.

  > byte[] getBytes(): 获取文件数据;
  > String getContentType(): 获取文件MIME类型,如application/pdf、image/pdf等;
  > InputStream getInputStream(): 获取文件流;
  > String getOriginalFileName(): 获取上传文件的原名称;
  > long getSize(): 获取文件的字节大小,单位为byte;
  > boolean isEmpty(): 是否上传的文件是否为空;
  > void transferTo(File dest): 将上传的文件保存到目标文件中
  >

---

> autowired就不需要get\set方法了
>
> domain还是需要get\set方法的



---

springboot的SSM整合；

整合分为：xml配置文件、注解

---

@param...@....的含义？

@EnableWebMvc

@Configuration

---

HttpMessageConverter转换器，实体和字节码之间的转换

JsonConverter 作为Domain类的Json转换器

---

静态资源设置：（优先级从上到下）

1. classpath:/META-INF/resources/ 
2. classpath:/resources/
3. classpath:/static/ 
4. classpath:/public/
5. /：当前项目的根路径

---

自定义静态文件位置：

1. 代码中配置

2. 配置文件中配置

3. > 两种方式均配置的情况下，以代码的方式为准

> Spring Boot 2.x的版本中使用的是Spring5

---

> index.html只要在指定资源路径中，就能够被侦测到
>
> > 1. classpath:/META-INF/resources/ 
> > 2. classpath:/resources/
> > 3. classpath:/static/ 
> > 4. classpath:/public/

---

内容协商机制:

​	ContentNegotiation 内容协商管理器

1、accept 不常用

2、开启扩展名支持

​	 默认关闭，需要手动开启

3、开启参数的方式

​	默认关闭，需要手动开启

---

​		在默认情况下，Spring MVC并没有开启ContentNegotiatingViewResolver内容协商视图解析器，因此如果有同一接口资源，要用多视图展示的需求，我们是需要自己手动配置来实现的。
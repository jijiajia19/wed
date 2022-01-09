# \[原创\][SpringMVC](https://so.csdn.net/so/search?q=SpringMVC)中@ModelAttribute用法小结

顾名思义，@[Model](https://so.csdn.net/so/search?q=Model)Attribute注释可以为模型添加属性。@ModelAttribute通常是和@RequestMapping配合使用的，@ModelAttribute和@RequestMapping注释位置有所不同，其用法也有区别。

## 1\. ModelAttribute和RequestMapping分开注释不同方法

先来一张项目结构图，User类是POJO类,MyController实现对请求的处理，index.jsp是登陆页面，result.jsp是处理结果页面：

![](https://img-blog.csdnimg.cn/20190328201228537.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTQ2NDU1MDg=,size_16,color_FFFFFF,t_70)

User类如下：

```java
package matest; public class User {	private String loginname;	private String password; 	public User() {		super();	} 	public User(String loginname, String password) {		this.loginname = loginname;		this.password = password;	} 	public String getLoginname() {		return loginname;	} 	public void setLoginname(String loginname) {		this.loginname = loginname;	} 	public String getPassword() {		return password;	} 	public void setPassword(String password) {		this.password = password;	} 	@Override	public String toString() {		return this.getLoginname() + this.getPassword();	}}
```

result.jsp用来显示MyController的处理结果：

```html
<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><title>Insert title here</title></head><body>你好${user.loginname}<br> </body></html>
```

下面先看MyController类中，只有@RequestMapping存在的情况：

```java
@Controllerpublic class MyController {	@RequestMapping("/login")	public String skrWu() {		return "result";	}}
```

当向后端发送/login请求时，将会寻找被@ReuqestMapping标记的方法，进行匹配。这种情况下，会直接返回result.jsp视图。

![](https://img-blog.csdnimg.cn/2019032819492315.png)

登录结果：

![](https://img-blog.csdnimg.cn/20190328194619712.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTQ2NDU1MDg=,size_16,color_FFFFFF,t_70)

可以看到，因为我们没有进行任何处理，所以没有打印user的loginname信息，这是理所当然的。

现在，轮到@ModelAttribute登场了，我们为MyController添加一个用@ModelAttribute注释的test()方法，来接收前端传来的登录名和密码信息，生成和保存User对象。

```java
@Controllerpublic class MyController {	@ModelAttribute	public User test(@RequestParam("loginname") String loginname, @RequestParam("password") String password) {		User user = new User();		user.setLoginname(loginname);		user.setPassword(password);		return user;	} 	@RequestMapping("/login")	public String skrWu() {		return "result";	}}
```

再次运行，

![](https://img-blog.csdnimg.cn/20190328195045614.png)

运行结果：

![](https://img-blog.csdnimg.cn/20190328195112879.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTQ2NDU1MDg=,size_16,color_FFFFFF,t_70)

这次就有user的loginname信息了。原因何在呢？

原来，在执行被@RequestMapping标注的方法前，SpringMVC会先依次执行被@ModelAttribute标注的方法。在这个例子里，先运行的test() 方法接收了前端传来的登录名和密码信息，并将其值传给了新建的user对象。在test() 方法执行结束后，user对象已经存储在了model当中。之后运行skrWu() 方法，跳转到result.jsp,因此可以在result.jsp中访问user对象了。如果test() 方法没有被@ModelAttribute标注，是无法得到运行的。

在这种默认写法（@ModelAttribute）下，model中user的属性名就是test()方法的返回类型User的小写。如果想要自定义模型中user的属性名，可以采用@ModelAttribute("属性名");或者model.addAttribute("属性名", 属性值);两种方法。如下：

```java
    @ModelAttribute("userWu")	public User test(@RequestParam("loginname") String loginname, @RequestParam("password") String password,Model model) {		User user = new User();		user.setLoginname(loginname);		user.setPassword(password);		return user;	} 
```

或者

```java
@ModelAttribute	public void test(@RequestParam("loginname") String loginname, @RequestParam("password") String password,Model model) {		User user = new User();		user.setLoginname(loginname);		user.setPassword(password);		model.addAttribute("userWu", user);	}
```

这样，在result.jsp中就可以通过${userWu.loginname}访问登录名了。

## 2.@ModelAttribute出现在@RequestMapping注释的方法的参数里

改写MyController类如下：

```java
@Controllerpublic class MyController { 	@RequestMapping("/login")	public String skrWu(@ModelAttribute("user1") User user) {		return "result";	}}
```

改写result.jsp如下：

```html
<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><title>Insert title here</title></head><body>你好${user1.loginname}<br>${user1.password}<br></body></html>
```

通过前端页面或者URL发送请求：

![](https://img-blog.csdnimg.cn/20190328212907263.png)

或：![](https://img-blog.csdnimg.cn/2019032821293538.png)

结果如下：

![](https://img-blog.csdnimg.cn/20190328213013709.png)

可见参数已经传给了user1对象。

那么总结一下，当\[@ModelAttribute("属性名") 类型 对象 \]出现在方法参数中时，它首先会试图自动将form表单或URL里的属性传给对象，这时甚至不用显式使用set方法，只要欲传递的属性名（loginname,password）在POJO类和前端表单name中对应即可。

## 3.@ModelAttribute和@RequestMapping同时注释同一个方法

轮到freeStyle出场了。

新建MyControllerV2类：

```java
@Controllerpublic class MyControllerV2 {	@ModelAttribute("user")	@RequestMapping("/freeStyle")	public String skrWu() {        //freeStyle:将要跳转的视图名        //user(属性名)=result(属性值) 		return "result";	}}
```

前端对应/freeStyle请求的代码块片段为

```html
<a href="freeStyle" >    <button>点我跳转到freeStyle！</button></a>
```

新建freeStyle.jsp:

```html
<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><title>Insert title here</title></head><body>${user}</body></html>
```

点击下图按钮，

![](https://img-blog.csdnimg.cn/20190328221000436.png)

结果为：

![](https://img-blog.csdnimg.cn/20190328221044112.png)

下面分析一下执行过程：

 当@ModelAttribute和@RequestMapping同时注释skrWu()方法时，此时方法的返回值不再代表视图名，取而代之的是@RequestMapping的value值成为了视图名。而@ModelAttribute的value值代表属性名，方法返回值此时代表ModelAttribute属性名的属性值。和前面两种情况区别较大。

## 4.@ModelAttribute出现在@RequestMapping修饰的方法的返回值之前

可能很多人已经晕了，写成代码大概是这个样子：

@RequestMapping("/请求")

public @ModelAttribute("属性名") 返回值 方法名(参数名){方法体}

至于这样写的作用，还是看例子吧。

重写MyControllerV2类，如下：

```java
@Controllerpublic class MyControllerV2 {	@RequestMapping("/freeStyle")	public @ModelAttribute("wuli") User test(@RequestParam("loginname") String loginname,			@RequestParam("password") String password) {		User user = new User();		user.setLoginname(loginname);		user.setPassword(password);		return user;	}}
```

前端/freeStyle请求对应的代码块如下：

```html
<form action="freeStyle" method="post"><table><tr><td><label>登录名:</label></td><td><input type="text" id="logins" name="loginname" ></td></tr><tr><td><label>密码:</label></td><td><input type="text" id="password" name="password" ></td></tr><tr> <td><input type="submit" id="submit" value="登录" ></td></tr></table></form>
```

freeStyle.jsp如下：

```html
<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><title>Insert title here</title></head><body>你好，${wuli.loginname}</body></html>
```

登录。。

![](https://img-blog.csdnimg.cn/20190328223245935.png)

登录结果：

![](https://img-blog.csdnimg.cn/20190328223320704.png)

分析：@RequestMapping的行为和第3种情况类似，方法返回值不再代表视图名(毕竟类型也不同了)，取而代之的是@RequestMapping的value值代表了视图名，在这个例子里为freeStyle.jsp。@ModelAttribute("属性名")会把方法返回值存入model，相当于执行了 model.setAttribute("wuli",user);

不过值得注意的是，这种情况下，SpringMVC并不会试图自动将前端传入的参数赋给@ModelAttribute修饰的对象，需要手动赋值。因此，如果注释掉

//user.setLoginname(loginname);  
//user.setPassword(password);

就无法获得对象wuli的属性值了。


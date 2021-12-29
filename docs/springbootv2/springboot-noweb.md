### 2.1 方案一

> pom文件

```
<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
	</dependencies>
复制代码
```

通过上诉我们可以看到我们引入了web项目

> application.yaml文件

```
spring:
  application:
    name: demo
    #非web的方式运行
  main:
    web-application-type: none

server:
  port: 8080
复制代码
```

> @PostConstruct完成任务

```@SpringBootApplication
public class DemoApplication {

	@PostConstruct
	public  void init(){
		System.out.println("我是初始化方法");
	}

	public static void main(String[] args) {
		SpringApplication application= new SpringApplication(DemoApplication.class);
		//application.addListeners(new ApplicationStartingEventistener());
		application.run(args);
		//ScheduledExecutorService timer = Executors.newScheduledThreadPool(2);
	}

}

复制代码
```

> 运行结果

```
2021-03-24 11:35:06.776  INFO 51476 --- [           main] com.example.demo.DemoApplication         : Starting DemoApplication using Java 1.8.0_181 on DESKTOP-J55VRAQ with PID 51476 (C:\Users\baicells\eclipse-workspace\demo\target\classes started by baicells in C:\Users\baicells\eclipse-workspace\demo)
2021-03-24 11:35:06.782  INFO 51476 --- [           main] com.example.demo.DemoApplication         : No active profile set, falling back to default profiles: default
我是初始化方法
2021-03-24 11:35:09.226  INFO 51476 --- [           main] com.example.demo.DemoApplication         : Started DemoApplication in 4.286 seconds (JVM running for 6.326)
Disconnected from the target VM, address: '127.0.0.1:49953', transport: 'socket'

Process finished with exit code 0
复制代码
```

### 2.2 方案二

> pom文件

```
<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
	</dependencies>
复制代码
```

通过上诉我们可以看到我们引入了web项目

> application.yaml文件

```
spring:
  application:
    name: demo
    #非web的方式运行
  main:
    web-application-type: none

server:
  port: 8080
复制代码
```

> 实现SmartLifecycle完成任务

```
@Component
public class TestSmartLifecycle implements SmartLifecycle {
    private boolean isRunning = false;

    /**
     * 1. 我们主要在该方法中启动任务或者其他异步服务，比如开启MQ接收消<br/>
     * 2. 当上下文被刷新（所有对象已被实例化和初始化之后）时，将调用该方法，默认生命周期处理器将检查每个SmartLifecycle对象的isAutoStartup()方法返回的布尔值。
     * 如果为“true”，则该方法会被调用，而不是等待显式调用自己的start()方法。
     */
    @Override
    public void start() {
        System.out.println("start");

        // 执行完其他业务后，可以修改 isRunning = true
        isRunning = true;
    }

    /**
     * 如果工程中有多个实现接口SmartLifecycle的类，则这些类的start的执行顺序按getPhase方法返回值从小到大执行。<br/>
     * 例如：1比2先执行，-1比0先执行。 stop方法的执行顺序则相反，getPhase返回值较大类的stop方法先被调用，小的后被调用。
     */
    @Override
    public int getPhase() {
        // 默认为0
        return 0;
    }

    /**
     * 根据该方法的返回值决定是否执行start方法。<br/>
     * 返回true时start方法会被自动执行，返回false则不会。
     */
    @Override
    public boolean isAutoStartup() {
        // 默认为false
        return true;
    }

    /**
     * 1. 只有该方法返回false时，start方法才会被执行。<br/>
     * 2. 只有该方法返回true时，stop(Runnable callback)或stop()方法才会被执行。
     */
    @Override
    public boolean isRunning() {
        // 默认返回false
        return isRunning;
    }

    /**
     * SmartLifecycle子类的才有的方法，当isRunning方法返回true时，该方法才会被调用。
     */
    @Override
    public void stop(Runnable callback) {
        System.out.println("stop(Runnable)");

        // 如果你让isRunning返回true，需要执行stop这个方法，那么就不要忘记调用callback.run()。
        // 否则在你程序退出时，Spring的DefaultLifecycleProcessor会认为你这个TestSmartLifecycle没有stop完成，程序会一直卡着结束不了，等待一定时间（默认超时时间30秒）后才会自动结束。
        // PS：如果你想修改这个默认超时时间，可以按下面思路做，当然下面代码是springmvc配置文件形式的参考，在SpringBoot中自然不是配置xml来完成，这里只是提供一种思路。
        // <bean id="lifecycleProcessor" class="org.springframework.context.support.DefaultLifecycleProcessor">
        //      <!-- timeout value in milliseconds -->
        //      <property name="timeoutPerShutdownPhase" value="10000"/>
        // </bean>
        callback.run();

        isRunning = false;
    }

    /**
     * 接口Lifecycle的子类的方法，只有非SmartLifecycle的子类才会执行该方法。<br/>
     * 1. 该方法只对直接实现接口Lifecycle的类才起作用，对实现SmartLifecycle接口的类无效。<br/>
     * 2. 方法stop()和方法stop(Runnable callback)的区别只在于，后者是SmartLifecycle子类的专属。
     */
    @Override
    public void stop() {
        System.out.println("stop");

        isRunning = false;
    }
复制代码
```

> 运行结果

```
2021-03-24 11:36:30.257  INFO 49516 --- [           main] com.example.demo.DemoApplication         : Starting DemoApplication using Java 1.8.0_181 on DESKTOP-J55VRAQ with PID 49516 (C:\Users\baicells\eclipse-workspace\demo\target\classes started by baicells in C:\Users\baicells\eclipse-workspace\demo)
2021-03-24 11:36:30.266  INFO 49516 --- [           main] com.example.demo.DemoApplication         : No active profile set, falling back to default profiles: default
我是初始化方法
start
2021-03-24 11:36:32.355  INFO 49516 --- [           main] com.example.demo.DemoApplication         : Started DemoApplication in 3.883 seconds (JVM running for 5.505)
stop(Runnable)
Disconnected from the target VM, address: '127.0.0.1:49993', transport: 'socket'

Process finished with exit code 0
复制代码
```

> 结论

实现SmartLifecycle接口，会在容器加载完成后执行start方法，容器销毁前执行stop方法

### 2.3 方案三

> pom文件

```
<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
	</dependencies>
复制代码
```

通过上诉我们可以看到我们没有引入了web项目

> application.yaml文件

```
spring:
  application:
    name: demo
复制代码
```

> @PostConstruct完成任务

```@SpringBootApplication
public class DemoApplicationCommandLineRunner  implements CommandLineRunner {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplicationCommandLineRunner.class,args);
    }
    @Override
    public void run(String... args) throws Exception {
        System.out.println("我是CommandLineRunner");
    }
}

复制代码
```

> 运行结果

```
2021-03-24 11:46:49.797  INFO 51928 --- [           main] c.e.d.DemoApplicationCommandLineRunner   : Starting DemoApplicationCommandLineRunner using Java 1.8.0_181 on DESKTOP-J55VRAQ with PID 51928 (C:\Users\baicells\eclipse-workspace\demo\target\classes started by baicells in C:\Users\baicells\eclipse-workspace\demo)
2021-03-24 11:46:49.803  INFO 51928 --- [           main] c.e.d.DemoApplicationCommandLineRunner   : No active profile set, falling back to default profiles: default
我是初始化方法
start
2021-03-24 11:46:51.429  INFO 51928 --- [           main] c.e.d.DemoApplicationCommandLineRunner   : Started DemoApplicationCommandLineRunner in 2.819 seconds (JVM running for 4.259)
我是CommandLineRunner
stop(Runnable)

Process finished with exit code 0
复制代码
```

### 2.4方案4

> 实现ApplicationListener监听

```
public class TestListener implements ApplicationListener {
    @Override
    public void onApplicationEvent(ApplicationEvent event) {

        if (event instanceof ApplicationStartingEvent) {
            System.out.println("1111");
        }
        if (event instanceof ApplicationEnvironmentPreparedEvent){
            System.out.println("环境初始化！！！");
        } else if (event instanceof ApplicationPreparedEvent){
            System.out.println("初始化完成！！！");
        } else if (event instanceof ContextRefreshedEvent) {
            System.out.println("应用刷新！！");
        } else if (event instanceof ApplicationReadyEvent) {
            System.out.println("项目启动完成！！");
        } else if (event instanceof ContextStartedEvent) {
            System.out.println("应用启动！！");
        } else if (event instanceof ContextStoppedEvent) {
            System.out.println("项目中止！！");
        } else if (event instanceof ContextClosedEvent) {
            System.out.println("应用关闭！！");
        }
    }
}
复制代码
```

> 容器加入自定义监听

1：启动类中添加

```
SpringApplication application= new SpringApplication(DemoApplication.class);
application.addListeners(new TestListener());
复制代码
```

2或者配置文件中制定：

```
#配置启动监听
context:
  listener:
```


作者：小棋子006
链接：https://juejin.cn/post/6943107876994940958
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



---

> JS跨域访问，由于JS设置了同源策略（同域名、同端口、同协议）
>
> 同源政策的目的是为了防止恶意网站通过冒充用户来窃取用户的数据信息，同源策略提高了攻击成本。
>
> 同源策略限制了以下行为:
>
> - Cookie、LocalStorage 和 IndexDB 无法读取；
> - DOM 和 JS 对象无法获取；
> - Ajax请求发送不出去。



解决跨域的方法:

> 跨域资源共享 CORS;
> 使用ajax的jsonp;
> 使用jQuery的jsonp插件;
> document.domain + iframe 跨域;
> window.name + iframe 跨域;
> location.hash + iframe 跨域;
> postMessage跨域;
> WebSocket协议跨域;
> node代理跨域;
> nginx代理跨域.

> SpringBoot采用的是CORS跨域方案(cross origin resource sharing)
>
> 需要浏览器和服务端同时支持
>
> - 实现CORS通信的关键是服务器。只要服务器实现了CORS接口，就可以跨源通信



简单请求：Content-Type只限于三个值application/x-www-form-urlencoded、multipart/form-data、text/plain

反之非简单请求;

> ### SpringBoot中跨域实现方案
>
> - 全局配置实现方案
> - 基于过滤器的实现方案
> - @CrossOrigin注解实现方案
>
> 以上三种实现方法都可以解决跨域问题，最常用的是第一种和第二种两种方式。
>
> 如果三种方式都用了的话，则采用就近原则。





> 之前是在web.xml中配置servlet、filter、listener
>
> **Servlet 3.0后提供了3个注解来代替:**
>
> - @WebServlet代替 servlet 配置；
> - @WebFilter代替 filter 配置；
> - @WebListener代替 listener 配置
>
> Spring Boot 提供了 ServletRegistrationBean, FilterRegistrationBean, ServletListenerRegistrationBean 三个类分别用来注册 Servlet, Filter, Listener。
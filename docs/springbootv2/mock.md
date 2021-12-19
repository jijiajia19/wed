### MOCK测试

---

> mock测试:**mock** 测试就是在测试过程中，对于某些不容易构造或者不容易获取的对象，用一个虚拟的对象来创建以便测试的测试方法。这个虚拟的对象就是mock对象。mock对象就是真实对象在调试期间的代替品。

>  对有依赖的环节\调用耗时环节进行测试，通过设置替代对象来进行测试，就是mock测试

>  STUB(桩)--指的是用来替换具体功能的程序段。桩程序可以用来模拟已有程序的行为或是对未完成开发程序的一种临时替代。

> 为依赖外部组件的代码做单元测试，需要使用Mockito，如果是Spring上下文的话，可以使用MockBean

> ## 测试代码示例
>
> - 使用原生的Bean
>
> 
>
> ```java
> @SpringBootTest
> class TransactionManagerNoMockTest {
>     @Resource
>     private TransactionManager transactionManager;
> 
>     @Test
>     void getUserInfo() {
>         User user = transactionManager.getUserInfo(1);
>         Assertions.assertEquals(1, user.getId());
>         Assertions.assertEquals("name1", user.getName());
>     }
> }
> ```
>
> - 使用Mock的Bean
>
> 使用@MockBean替换Spring上下文中的Bean（这样会导致Spring上下文重启）
>
> 
>
> ```java
> @SpringBootTest
> class TransactionManagerWithMockTest {
> 
>     /**
>      * 注入Mock的UserManager，替换Spring上下文中的UserManager
>      */
>     @MockBean
>     private UserManager userManager;
> 
>     @Resource
>     private TransactionManager transactionManager;
> 
>     @BeforeEach
>     public void setUp() {
>         //重置Mock，防止重复设置
>         Mockito.reset(userManager);
>         
>         //设置Mock行为
>         Mockito.when(userManager.getOne(Mockito.anyInt()))
>                 .thenAnswer((Answer<User>) invocationOnMock -> {
>                     Integer userId = invocationOnMock.getArgument(0, Integer.class);
>                     return User.builder().id(userId).name(userId.toString()).build();
>                 });
>     }
> 
>     @Test
>     void getUserInfo() {
>         User user = transactionManager.getUserInfo(1);
>         Assertions.assertEquals(1, user.getId());
>         Assertions.assertEquals("1", user.getName());
>     }
> }
> ```
>
> ## 常见错误
>
> - `When using matchers, all arguments have to be provided by matchers.`
>    Mocktio设置的时候，如果参数有Mockito生成的，那么所有的参数都需要由Mockito生成，哪怕是常量，也要使用`Mockito.eq(常量)`
>
> ## @Mock与@MockBean的区别
>
> - Mock一般用在不依赖框架的单元测试
> - MockBean用在依赖Spring上下文环境
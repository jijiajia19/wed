@Component注解默认实例化的对象是单例，如果想声明成多例对象可以使用@Scope("prototype")

@Repository默认单例

@Service默认单例

@Controller默认多例   (只有controller是多例的)
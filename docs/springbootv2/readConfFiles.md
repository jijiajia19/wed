# [Spring Boot读取配置文件的几种方式](https://segmentfault.com/a/1190000023125264)

​		Spring Boot获取文件总的来说有三种方式，分别是@Value注解，@ConfigurationProperties注解和Environment接口。这三种注解可以配合着@PropertySource来使用，@PropertySource主要是用来指定具体的配置文件。

## @PropertySource解析

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Repeatable(PropertySources.class)
public @interface PropertySource {
    
    String name() default "";

    String[] value();

    boolean ignoreResourceNotFound() default false;

    String encoding() default "";

    Class<? extends PropertySourceFactory> factory() default PropertySourceFactory.class;
}
```

- value()：指定配置文件
- encoding()：指定编码，因为properties文件的编码默认是ios8859-1，读取出来是乱码
- factory()：自定义解析文件类型，因为该注解默认只会加载properties文件，如果想要指定yml等其他格式的文件需要自定义实现。

## 一、@Value注解读取文件

新建两个配置文件config.properties和configs.properties，分别写入如下内容：

```ini
zhbin.config.web-configs.name=Java旅途
zhbin.config.web-configs.age=22
zhbin.config.web-configs.name=Java旅途
zhbin.config.web-configs.age=18
```

新增一个类用来读取配置文件

```java
@Configuration
@PropertySource(value = {"classpath:config.properties"},encoding="gbk")
public class GetProperties {

    @Value("${zhbin.config.web-configs.name}")
    private String name;
    @Value("${zhbin.config.web-configs.age}")
    private String age;

    public String getConfig() {
        return name+"-----"+age;
    }
}
```

如果想要读取yml文件，则我们需要重写DefaultPropertySourceFactory，让其加载yml文件，然后在注解

@PropertySource上自定factory。代码如下：

```java
public class YmlConfigFactory extends DefaultPropertySourceFactory {
    @Override
    public PropertySource<?> createPropertySource(String name, EncodedResource resource) throws IOException {
        String sourceName = name != null ? name : resource.getResource().getFilename();
        if (!resource.getResource().exists()) {
            return new PropertiesPropertySource(sourceName, new Properties());
        } else if (sourceName.endsWith(".yml") || sourceName.endsWith(".yaml")) {
            Properties propertiesFromYaml = loadYml(resource);
            return new PropertiesPropertySource(sourceName, propertiesFromYaml);
        } else {
            return super.createPropertySource(name, resource);
        }
    }

    private Properties loadYml(EncodedResource resource) throws IOException {
        YamlPropertiesFactoryBean factory = new YamlPropertiesFactoryBean();
        factory.setResources(resource.getResource());
        factory.afterPropertiesSet();
        return factory.getObject();
    }
}
@PropertySource(value = {"classpath:config.properties"},encoding="gbk",factory = YmlConfigFactory.class)
```

## 二、Environment读取文件

配置文件我们继续用上面的两个，定义一个类去读取配置文件

```java
@Configuration
@PropertySource(value = {"classpath:config.properties"},encoding="gbk")
public class GetProperties {

    @Autowired
    Environment environment;

    public String getEnvConfig(){
        String name = environment.getProperty("zhbin.config.web-configs.name");
        String age = environment.getProperty("zhbin.config.web-configs.age");
        return name+"-----"+age;
    }
}
```

## 三、@ConfigurationProperties读取配置文件

@ConfigurationProperties可以将配置文件直接映射成一个实体类，然后我们可以直接操作实体类来获取配置文件相关数据。

新建一个yml文件，当然properties文件也没问题

```yaml
zhbin:
  config:
    web-configs:
      name: Java旅途
      age: 20
```

新建实体类用来映射该配置

```java
@Component
@ConfigurationProperties(prefix = "zhbin.config")
@Data
public class StudentYml {
    
    // webConfigs务必与配置文件相对应，写为驼峰命名方式
    private WebConfigs webConfigs = new WebConfigs();

    @Data
    public static class WebConfigs {
        private String name;
        private String age;
    }
}
```

- **prefix = "zhbin.config"用来指定配置文件前缀**

如果需要获取list集合，则做以下修改即可。

```yaml
zhbin:
  config:
    web-configs:
      - name: Java旅途
        age: 20
      - name: Java旅途2
        age: 202
@Component
@ConfigurationProperties(prefix = "zhbin.config")
@Data
public class StudentYml {

    private List<WebConfigs> webConfigs = new ArrayList<>();

    @Data
    public static class WebConfigs {

        private String name;
        private String age;
    }
}
```

## 经验与坑

- properties文件默认使用的是iso8859-1，并且不可修改
- yml文件的加载顺序高于properties，但是读取配置信息的时候会读取后加载的
- @PropertySource注解默认只会加载properties文件
- @PropertySource注解可以与任何一种方式联合使用
- 简单值推荐使用@Value，复杂对象推荐使用@ConfigurationProperties
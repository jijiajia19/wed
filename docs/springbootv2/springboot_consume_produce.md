### springboot consumes和produces属性



Http请求中Content-Type讲解以及在Spring MVC注解中produce和consumes配置详解
RequestMapping 注解说明
@Target({ElementType.METHOD, ElementType.TYPE})  
@Retention(RetentionPolicy.RUNTIME)  
@Documented  
@Mapping  
public @interface RequestMapping {  
      String[] value() default {};  
      RequestMethod[] method() default {};  
      String[] params() default {};  
      String[] headers() default {};  
      String[] consumes() default {};  
      String[] produces() default {};  
}  

value: 指定请求的实际地址， 比如 /action/info之类
method： 指定请求的method类型， GET、POST、PUT、DELETE等
consumes： 指定处理请求的提交内容类型（Content-Type），例如application/json, text/html;
produces: 指定返回的内容类型，仅当request请求头中的(Accept)类型中包含该指定类型才返回
params： 指定request中必须包含某些参数值是，才让该方法处理
headers： 指定request中必须包含某些指定的header值，才能让该方法处理请求

案例
@Controller    
@RequestMapping(value = "/users", method = RequestMethod.POST, consumes="application/json", produces="application/json")    
@ResponseBody  
public List<User> addUser(@RequestBody User userl) {        
    // implementation omitted    
    return List<User> users;  
}    

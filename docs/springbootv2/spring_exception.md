1. [异常处理方式一. @ExceptionHandler](https://www.cnblogs.com/lvbinbin2yujie/p/10574812.html#type1)
2. [异常处理方式二. 实现HandlerExceptionResolver接口](https://www.cnblogs.com/lvbinbin2yujie/p/10574812.html#type2)
3. [异常处理方式三. @ControllerAdvice+@ExceptionHandler](https://www.cnblogs.com/lvbinbin2yujie/p/10574812.html#type3)



> 第一种方式，注意事项:
>
>  	  1. 一个Controller下多个@ExceptionHandler上的异常类型不能出现一样的，否则运行时抛异常.
>
> Ambiguous @ExceptionHandler method mapped for;
>
> ​       2. @ExceptionHandler下方法返回值类型支持多种，常见的ModelAndView，@ResponseBody注解标注，ResponseEntity等类型都OK.


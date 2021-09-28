# 新建vue项目出现error Unexpected ‘debugger‘ statement no-debugger

问题描述：项目中使用debugger/console报错  
error Unexpected ‘debugger’ statement no-debugger  
error Unexpected ‘debugger’ statement no-debugger  
解决办法：  
1\. 找到项目中的 package.json 文件  
2\. 找到 eslintConfig 配置参数  
3\. 在 eslintConfig 下的 rules 添加 “no-debugger”: “off”, “no-console”: “off”,  
![](https://img-blog.csdnimg.cn/20200911163920499.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21vY2hlbl9tag==,size_16,color_FFFFFF,t_70#pic_center)  
4\. 重启项目即可
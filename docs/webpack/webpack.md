### webpack

---

- 构建工具

> 引入资源
>
> ​		通过入口index.js来进行打包，引入之后形成chunk代码块
>
>  		再对代码块分别按不同资源进行处理
>
> ​		处理完之后，输出bundle.js

>
>
>entry入口，构建打包依赖图
>
>output输出文件bundle.js的输出位置
>
>loader资源处理器
>
>plugins压缩、优化等插件服务
>
>mode模式处理

> 获取yarn的安装位置：yarn global bin
>
> > npm bin -g 
>
> - **查看 yarn 全局bin位置**
>
>   ```javascript
>   yarn global bin
>   ```
>
> - **查看 yarn 全局安装位置**
>
>   ```javascript
>   yarn global dir
>   ```
>
> - **查看 yarn 全局cache位置**
>
>   ```javascript
>   yarn cache dir
>   ```

> mode为生成环境的时候，代码进行了压缩；

> 缓存：babel和file缓存

> tree shaking解决去除没有使用的代码
>
> 前提：使用es6模块化 、开启production

> 单页面应用，代码分割，防止单个文件过于庞大
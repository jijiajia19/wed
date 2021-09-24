# VS code中断点调试Vue CLI 3项目

## 动机

> 当我发现按照vue的官网教程 [cn.vuejs.org/v2/cookbook…](https://link.juejin.cn/?target=https%3A%2F%2Fcn.vuejs.org%2Fv2%2Fcookbook%2Fdebugging-in-vscode.html) 无法实现vue在VS code中的断点调试。

## 亲测有效的方法

- 准备工作

> vscode和chrome更新到最新版，vscode中安装**Debugger for Chrome**插件

- 配置vue.config.js文件(如果没有，在根目录下新增一个)

```
module.exports = {
	configureWebpack: {
		devtool: 'source-map'
	}
};
复制代码
```

- 配置babel.config.js 文件

```
module.exports = {
  "env":{
    "development":{
      "sourceMaps":true,
      "retainLines":true, 
    }
  },
  presets: [
    '@vue/app'
  ]
}

复制代码
```

- 配置launch.json文件

  ![在这里插入图片描述](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/3/24/169ad97245337598~tplv-t2oaga2asx-watermark.awebp)

```
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "chrome",
            "request": "launch",
            "name": "vuejs: chrome",
            "url": "http://localhost:8080",
            "webRoot": "${workspaceFolder}/src",
            "breakOnLoad": true,
            "sourceMapPathOverrides": {
                "webpack:///src/*": "${webRoot}/*",
                "webpack:///./src/*": "${webRoot}/*"
            }
        },
    ]
}
复制代码
```

- 启动项目 npm run serve

- F5打开调试

  ![在这里插入图片描述](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/3/24/169ad9724535049a~tplv-t2oaga2asx-watermark.awebp)
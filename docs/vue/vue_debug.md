# [在VS Code 中调试Vue.js](https://segmentfault.com/a/1190000038156565)


# 步骤

- 打开vscode，安装Debugger for Chrome
- 使用vue cli3创建vue应用
- 项目根路径添加"vue.config.js" 文件

```java
module.exports = {
    configureWebpack: {
        devtool: 'source-map'
    }
}
```

- .vscode文件中的launch.json添加：

```bash
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
                "webpack:///src/*": "${webRoot}/*"
            }
        }
    ]
}
```

- 设置一个断点
- 在根目录打开你惯用的终端并使用 Vue CLI 开启这个应用：
  `npm run serve`
- 来到 Debug 视图，选择**“vuejs：chrome/firefox”**配置，然后按 F5 或点击那个绿色的 play 按钮。

![image.png](https://segmentfault.com/img/bVcKgqy)

- 随着一个新的浏览器实例打开 `http://localhost:8080`，你的断点现在应该被命中了
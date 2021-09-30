解决 npm i 及 yarn install 都无法进行安装的问题和node-sass安装太慢的问题
===================================================

> 今天经过长时间的尝试和搜索，设置是切换各种镜像源的尝试，都无法正常安装，目前已找到解决方法了，一开始网上并没有确切的答案，但是经过不断的试错，终于找到了问题的源头，现在分享下，避免以后其他人走太多弯路。

### 发现问题

    info There appears to be trouble with your network connection. Retrying...
    info There appears to be trouble with your network connection. Retrying...
    info There appears to be trouble with your network connection. Retrying...
    info There appears to be trouble with your network connection. Retrying...
    error An unexpected error occurred: "https://registry.npm.taobao.org/autoprefixer: tunneling socket could not be established, cause=connect ETIMEDOUT 10.129.49.21:8080".

经过沉着冷静的思考后，分析关键词：`tunneling socket could not be established`

通过百度和Google搜索引擎的帮助，终于发现了解决方案

### 解决方案

代理出现了问题，删除之

    npm config rm proxy 
    npm config rm https-proxy

删除之后一切ok

### 对node-sass镜像源进行设置

    yarn config set sass-binary-site http://npm.taobao.org/mirrors/node-sass
    或者
    npm config set sass-binary-site http://npm.taobao.org/mirrors/node-sass

### 参考链接

*   [https://stackoverflow.com/questions/33322739/npm-error-tunneling-socket-could-not-be-established-cause-connect-etimedout](https://stackoverflow.com/questions/33322739/npm-error-tunneling-socket-could-not-be-established-cause-connect-etimedout)
*   [http://www.it1352.com/536444.html](http://www.it1352.com/536444.html)
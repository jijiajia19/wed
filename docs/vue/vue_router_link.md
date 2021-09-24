VUE参考---设置router-link激活样式
=========================

打赏

目录
--

*   [一、总结](#)
    *   [一句话总结：](#)
    *   [1、给router-link设置激活样式的本质？](#)
    *   [2、多去看api文档？](#)
*   [二、设置router-link激活样式](#)

[回到顶部](#)

\>  一、总结（点击显示或隐藏总结内容）
---------------------

### 一句话总结：

##### 设置router-link激活时候的样式，直接设置 router-link-active

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

设置router-link激活时候的样式，直接设置 router-link-active

    .router-link-active {
      color: red;
      font-weight: 800;
      font-style: italic;
      font-size: 80px;
      text-decoration: underline;
      background-color: green;
    }

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

### 1、给router-link设置激活样式的本质？

##### 都是linkActiveClass指定了激活的link class，默认没设置的情况linkActiveClass为router-link-active，当然我们也可以指定linkActiveClass，比如myactive

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

    // 2. 创建一个路由对象， 当 导入 vue-router 包之后，在 window 全局对象中，就有了一个 路由的构造函数，叫做 VueRouter
    // 在 new 路由对象的时候，可以为 构造函数，传递一个配置对象
    var routerObj = new VueRouter({
      // route // 这个配置对象中的 route 表示 【路由匹配规则】 的意思
      routes: \[ // 路由匹配规则 
        // 每个路由规则，都是一个对象，这个规则对象，身上，有两个必须的属性：
        //  属性1 是 path， 表示监听 哪个路由链接地址；
        //  属性2 是 component， 表示，如果 路由是前面匹配到的 path ，则展示 component 属性对应的那个组件
        // 注意： component 的属性值，必须是一个 组件的模板对象， 不能是 组件的引用名称；
        // { path: '/', component: login },
        { path: '/', redirect: '/login' }, // 这里的 redirect 和 Node 中的 redirect 完全是两码事
        { path: '/login', component: login },
        { path: '/register', component: register }
      \],
      linkActiveClass: 'myactive'
    })

  <style\>
    .router-link-active,
    .myactive {
      color: red;
      font-weight: 800;
      font-style: italic;
      font-size: 80px;
      text-decoration: underline;
      background-color: green;
    }
  </style\>


> babel，是我们常见的做低版本兼容的工具包，[babel](https://so.csdn.net/so/search?q=babel&spm=1001.2101.3001.7020)和polyfill的区别在于
>
> 1. babel只转化新的语法，不负责实现新版本js中新增的api
> 2. polyfill 负责实现新版本js中新增的api
> 3. 所以在兼容的时候一般是 babel + polyfill都用到，所以babel-polyfill 一步到位

babel只负责转换，polifill负责新api实现，两者结合使用。

---

> export和export default区别export和export default区别:
>
> 解构方式引入：
>
> import { msg, hello, foo, Person } from './test';
>
> > 示例：
> >
> > var  o1={a:{b:{c:6}}}
> >
> > var {a:{b:{c:w}}}=o1
> >
> > console.log(w)
>
> > ```
> > 1.export与export default都可用于导出常量、函数、类、文件、模块等
> > 2.通过import (常量,函数,文件,类,模块,)名的方式,还可以根据路径导入样式文件，导入
> > 3.一个文件模块中,export和import可以有多个,但是export default只能有一个
> > 4.export default 暴露的成员可以用任意变量来接收
> > 5.一个文件模块中,可以同时使用export和export default向外暴露成员,只不过接收方式不一样
> > 6.通过export方式导出,在导入时必须要使用大括号{}来接收,export default则不需要
> > 7. 通过export方式导出,可以使用 as起别名进行导出
> > ```

---

**最常用的ES6特性**
let，const，class，extends，super，arrow functions，template string，destructuring，default，rest arguments。
1、let，const用途与var类似，都是用来声明变量的。
ES5只有全局作用域和函数作用域，会造成内层变量覆盖外层变量；
const也用来声明变量，但是声明的是常亮。一旦声明，常亮的值就不能改变，当尝试去改变const声明的变量时，浏览器就会报错。
2、class，extends，super
class类里的constructor方法，即为构造方法，this关键字则代表实例对象。
class之间可以通过extends关键字实现继承。
super关键字，它指代父类的实例（即父类的this对象）。子类必须在constructor方法中调用super方法，否则新建实例时会报错。
3、arrow function
箭头函数的形式
（参数）=>{函数体操作一；函数体操作二；return 返回值}
4、template string
传统的写法需要用大量的‘+’号来连接文本与变量，而使用[ES6](https://so.csdn.net/so/search?q=ES6&spm=1001.2101.3001.7020)的新特性模板字符串‘’后，可以用反引号（\）来标识起始，用${}’来引用变量，而且所有的空格和缩进都会被保留在输出之中。
5、Destructuring（解构）
ES6允许按照一定模式，从数组和对象中提取值，对变量进行赋值。

---

严格模式:

1. > .即使是在严格模式下，var支持重复声明一个变量
   >
   > var可以使用变量再声明变量，所谓的变量提升
   >
   > var是函数作用域，在if和for循环中定义的变量，在循环外可以使用，
   >
   > 　　let 的块作用域，只有在同一个花括号内才能使用。

   js只有函数域和全局域

使用let声明变量

2. #### 实参形参 和 arguments 的分离

   3. this指向变严格 

      在非严格模式下，null 或 undefined 值会被转换为全局对象window。而在严格模式下，函数的 this 值始终是指定的值，无论指定的是什么值。

      在以后的编程之中，this 最没有用的指向就是 全局对象window。

   4. eval作用域明确。

   5. this指向undefined，使用apply/call/bind时，this指向改变，函数内无法使用this，只能在对象内使用。

      严格模式，函数内，this不是指向对象了，而是undefined。

      无论是否是严格模式，全局环境下，this 始终指向全局对象（window）

      > 如果有调用，都是就近原则；
      >
      > 默认绑定：window、undefined
      >
      > 隐式绑定：无论是否为严格模式，如果函数调用时，前面存在调用它的对象，那么`this`就会隐式绑定到这个对象上（多个对象在前，采用最近原则）
      >
      > 显式绑定：call、apply、bind
      >
      > 无论是否为严格模式，只要是通过构造函数`new`对象，构造函数中的this都指向这个新对象
      >
      > 
      >
      > 如果在某个调用位置应用了多条规则，如何确定哪条规则生效？
      > 显式绑定 > 隐式绑定 > 默认绑定
      > new绑定 > 隐式绑定 > 默认绑定

> # [es6箭头函数 this 指向问题](https://www.cnblogs.com/lingnweb/p/9882082.html)
>
> es5中 this 的指向
>
> [![复制代码](https://assets.cnblogs.com/images/copycode.gif)](javascript:void(0);)
>
> ```
> var factory = function(){
>    this.a = 'a';
>    this.b = 'b';
>    this.c = {
>         a:'a+',
>         b:function(){return this.a}
>     }  
> };
> console.log(new factory().c.b());  // a+
> ```
>
> [![复制代码](https://assets.cnblogs.com/images/copycode.gif)](javascript:void(0);)
>
> 通过es5的语法调用，返回的是 a+ ，this 的指向是该函数被调用的对象，也就是说函数被调用的时候，这个 this 指向的是谁，哪个对象调用的这个函数，这个 this 就是谁。
>
> es6中 箭头函数 this 的指向
>
> [![复制代码](https://assets.cnblogs.com/images/copycode.gif)](javascript:void(0);)
>
> ```
> var factory = function(){
>    this.a = 'a';
>    this.b = 'b';
>    this.c = {
>         a:'a+',
>         b:() => {return this.a}
>     }  
> };
> console.log(new factory().c.b());  // a
> ```
>
> [![复制代码](https://assets.cnblogs.com/images/copycode.gif)](javascript:void(0);)
>
> 箭头函数函数体中 this 的指向是定义时 this 的指向。在定义 b 函数时，b当中的 this 指向的是 这个factory 函数体中的 this ，这个 factory 函数体中的 this 指向的是这个构造函数的实例，这个实例当中的 a 就等于 ‘a’；虽然是调用的b对象，但这个b对象指向的是这个实例。
>
> 箭头函数的this指向：箭头函数在定义时执行器上下文的this的指向（不具有块级作用域），即会取当前的函数的作用域链上的this，忽略块级作用域中的this
>
> >  this是继承自父执行上下文

      3. apply/call/bind的用法

> ```text
> let foo = { 
>  value: 1 
> }; 
> function bar() { 
>  console.log(this.value); 
> } 
> bar.call(foo);
> ```

   3. Object.defineProperty(obj, prop, descriptor)

      > 1. obj：必需。目标对象。
      > 2. prop：必需。需定义或修改的属性的名字。
      > 3. descriptor：必需。目标属性所拥有的特性。

      > 第三个参数 descriptor 说明：以对象形式 `{}` 书写
      >
      > 1. value：设置属性的值，默认为 undefined
      > 2. writable：值是否可以重写。true | false 默认为 false。
      > 3. enumerable：目标属性是否可以被枚举。true | false 默认为 false。
      > 4. configurable：目标属性是否可以被删除或是否可以再次修改特性。true | false 默认为 false。

---

### 集合 set map

### 异步回调处理，类似ajax

promise

async  await（出现在async函数中）

prototype 每个类都有一个原型属性，不是继承，可以理解为clone

对象没有prototype，而是类有prototype。

---

> es5-6
>
> 1. promise then
> 2. async await 
> 3. set map
> 4. 解构
> 5. iterator
> 6. prototype defineproperty监听对象属性变化，自动执行方法
> 7. 箭头函数，es5,6中this的指向变化
> 8. 模块化
> 9. 形参的使用arguments
> 10. class extend类的书写、继承
> 11. 模版
> 12. let const使用

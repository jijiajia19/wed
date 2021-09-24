# Vue props用法详解

组件接受的选项之一 props 是 Vue 中非常重要的一个选项。父子组件的关系可以总结为：

props down, events up

父组件通过 props 向下传递数据给子组件；子组件通过 events 给父组件发送消息。

## 父子级组件

比如我们需要创建两个组件 parent 和 child。需要保证每个组件可以在相对隔离的环境中书写，这样也能提高组件的可维护性。

这里我们先定义父子两个组件和一个 Vue 对象：



```js
var childNode = {
  template: `
        <div>childNode</div>
        `
};
var parentNode = {
  template: `
        <div>
          <child></child>
          <child></child>
        </div>
        `,
  components: {
    child: childNode
  }
};
new Vue({
  el: "#example",
  components: {
    parent: parentNode
  }
});
```



```html
<div id="example">
  <parent></parent>
</div>
```

这里的 childNode 定义的 template 是一个 div，并且内容是"childNode"字符串。
而在 parentNode 的 template 中定义了 div 的 class 名叫 parent 并且包含了两个 child 组件。

## 静态 props

组件实例的作用域是孤立的。这意味着不能（也不应该）在子组件的模板中直接饮用父组件的数据。要让子组件使用父组件的数据，需要通过子组件的 props 选项。

父组件向子组件传递数据分为两种方式：动态和静态，这里先介绍静态方式。

子组件要显示的用 props 声明它期望获得的数据

修改上例中的代码，给 childNode 添加一个 props 选项和需要的`forChildMsg`数据;
然后在父组件中的占位符添加特性的方式来传递数据。



```js
var childNode = {
  template: `
        <div>
          {{forChildMsg}}
        </div>
        `,
  props: ["for-child-msg"]
};
var parentNode = {
  template: `
        <div>
          <p>parentNode</p>
          <child for-child-msg="aaa"></child>
          <child for-child-msg="bbb"></child>
        </div>
        `,
  components: {
    child: childNode
  }
};
```

**命名规范**
对于 props 声明的属性，在父组件的 template 模板中，属性名需要使用中划线写法；

子组件 props 属性声明时，使用小驼峰或者中划线写法都可以；而子组件的模板使用从父组件传来的变量时，需要使用对应的小驼峰写法。别担心，Vue 能够正确识别出小驼峰和下划线命名法混用的变量，如这里的`forChildMsg`和`for-child-msg`是同一值。

## 动态 props

在模板中，要动态地绑定父组件的数据到子组件模板的 props，和绑定 Html 标签特性一样，使用`v-bind`绑定；

基于上述静态 props 的代码，这次只需要改动父组件：



```js
var parentNode = {
  template: `
        <div>
          <p>parentNode</p>
          <child :for-child-msg="childMsg1"></child>
          <child :for-child-msg="childMsg2"></child>
        </div>
        `,
  components: {
    child: childNode
  },
  data: function() {
    return {
      childMsg1: "Dynamic props msg for child-1",
      childMsg2: "Dynamic props msg for child-2"
    };
  }
};
```

在父组件的 data 的 return 数据中的 childMsg1 和 childMsg2 会被传入子组件中，

## props 验证

验证传入的 props 参数的数据规格，如果不符合数据规格，Vue 会发出警告。

> 能判断的所有种类（也就是 type 值）有：
> String, Number, Boolean, Function, Object, Array, Symbol



```js
Vue.component("example", {
  props: {
    // 基础类型检测, null意味着任何类型都行
    propA: Number,
    // 多种类型
    propB: [String, Number],
    // 必传且是String
    propC: {
      type: String,
      required: true
    },
    // 数字有默认值
    propD: {
      type: Number,
      default: 101
    },
    // 数组、默认值是一个工厂函数返回对象
    propE: {
      type: Object,
      default: function() {
        console.log("propE default invoked.");
        return { message: "I am from propE." };
      }
    },
    // 自定义验证函数
    propF: {
      isValid: function(value) {
        return value > 100;
      }
    }
  }
});
let childNode = {
  template: "<div>{{forChildMsg}}</div>",
  props: {
    "for-child-msg": Number
  }
};
let parentNode = {
  template: `
          <div class="parent">
            <child :for-child-msg="msg"></child>
          </div>
        `,
  components: {
    child: childNode
  },
  data() {
    return {
      // 当这里是字符串 "123456"时会报错
      msg: 123456
    };
  }
};
```

还可以在 props 定义的数据中加入自定义验证函数，当函数返回 false 时，输出警告。

比如我们把上述例子中的 childNode 的`for-child-msg`修改成一个对象，并包含一个名叫`validator`的函数，该命名是规定叫`validator`的，自定义函数名不会生效。



```js
let childNode = {
  template: "<div>{{forChildMsg}}</div>",
  props: {
    "for-child-msg": {
      validator: function(value) {
        return value > 100;
      }
    }
  }
};
```

在这里我们给`for-child-msg`变量设置了`validator`函数，并且要求传入的值必须大于 100，否则报出警告。

## 单向数据流

props 是单向绑定的：当父组件的属性变化时，将传导给子组件，但是不会反过来。这是为了防止子组件五一修改父组件的状态。

所以不应该在子组件中修改 props 中的值，Vue 会报出警告。



```js
let childNode = {
  template: `
          <div class="child">
            <div>
              <span>子组件数据</span>
              <input v-model="forChildMsg"/>
            </div>
            <p>{{forChildMsg}}</p>
          </div>`,
  props: {
    "for-child-msg": String
  }
};
let parentNode = {
  template: `
          <div class="parent">
            <div>
              <span>父组件数据</span>
              <input v-model="msg"/>
            </div>
            <p>{{msg}}</p>
            <child :for-child-msg="msg"></child>
          </div>
        `,
  components: {
    child: childNode
  },
  data() {
    return {
      msg: "default string."
    };
  }
};
```

这里我们给父组件和子组件都有一个输入框，并且显示出父组件数据和子组件的数据。当我们在父组件的输入框输入新数据时，同步的子组件数据也被修改了；这就是 props 的向子组件传递数据。而当我们修改子组件的输入框时，浏览器的控制台则报出错误警告

> [Vue warn]: Avoid mutating a prop directly since the value will be overwritten whenever the parent component re-renders. Instead, use a data or computed property based on the prop's value. Prop being mutated: "forChildMsg"

## 修改 props 数据

通常有两种原因：

1. prop 作为初始值传入后，子组件想把它当做局部数据来用
2. prop 作为初始值传入后，由子组件处理成其他数据输出

应对办法是

1. 定义一个局部变量，并用 prop 的值初始化它

但是由于定义的 ownChildMsg 只能接受 forChildMsg 的初始值，当父组件要传递的值变化发生时，ownChildMsg 无法收到更新。



```js
let childNode = {
  template: `
          <div class="child">
            <div>
              <span>子组件数据</span>
              <input v-model="forChildMsg"/>
            </div>
            <p>{{forChildMsg}}</p>
            <p>ownChildMsg : {{ownChildMsg}}</p>
          </div>`,
  props: {
    "for-child-msg": String
  },
  data() {
    return { ownChildMsg: this.forChildMsg };
  }
};
```

这里我们加了一个<p>用于查看 ownChildMsg 数据是否变化，结果发现只有默认值传递给了 ownChildMsg，父组件改变只会变化到 forChildMsg，不会修改 ownChildMsg。

1. 定义一个计算属性，处理 prop 的值并返回

由于是计算属性，所以只能显示值，不能设置值。我们这里设置的是一旦从父组件修改了 forChildMsg 数据，我们就把 forChildMsg 加上一个字符串"---ownChildMsg"，然后显示在屏幕上。这时是可以每当父组件修改了新数据，都会更新 ownChildMsg 数据的。



```js
let childNode = {
  template: `
          <div class="child">
            <div>
              <span>子组件数据</span>
              <input v-model="forChildMsg"/>
            </div>
            <p>{{forChildMsg}}</p>
            <p>ownChildMsg : {{ownChildMsg}}</p>
          </div>`,
  props: {
    "for-child-msg": String
  },
  computed: {
    ownChildMsg() {
      return this.forChildMsg + "---ownChildMsg";
    }
  }
};
```

1. 更加妥帖的方式是使用变量存储 prop 的初始值，并用 watch 来观察 prop 值得变化。发生变化时，更新变量的值。



```js
let childNode = {
  template: `
          <div class="child">
            <div>
              <span>子组件数据</span>
              <input v-model="forChildMsg"/>
            </div>
            <p>{{forChildMsg}}</p>
            <p>ownChildMsg : {{ownChildMsg}}</p>
          </div>`,
  props: {
    "for-child-msg": String
  },
  data() {
    return {
      ownChildMsg: this.forChildMsg
    };
  },
  watch: {
    forChildMsg() {
      this.ownChildMsg = this.forChildMsg;
    }
  }
};
```


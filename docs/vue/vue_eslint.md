# eslint  no-mutating-props

## Vue - 解决子组件中修改props值报错


其实这就是Vue的`单向数据流`的概念

> 单向数据流

- `父级prop`的更新会向下流动到子组件中，子组件中所有的 prop 都将会刷新为最新的值
- 但是反过来则不行。你不应该在一个子组件内部改变 prop。否则Vue 会在浏览器的控制台中发出如上图的警告

> 这是Vue官方防止从子组件意外变更父级组件的状态内容，这样会导致你应用的数据流向杂乱无章。

那么怎么解决呢？很简单

***修改 prop 的两种情形：***

> ①：这个 prop 用来传递一个初始值；这个子组件接下来希望将其作为一个本地的 prop 数据来使用。在这种情况下，最好定义一个`本地的data prop` 并将这个本地 prop 当作其初始值：

```js
props: ['goodsItem'],
data: function () {
  return {
    localGoods: this.goodsItem
  }
}

```

> ②：如果这个 prop 以一种原始的值传入且需要进行转换。在这种情况下，最好使用这个 prop 的值来定义一个计算属性：

```js
props: ['goodsItem'],
computed: {
  normalizedSize: function () {
    return this.goodsItem.trim().toLowerCase()
  }
}

```

注意：在 JavaScript 中对象和数组是通过引用传入的，所以对于一个数组或对象类型的 prop 来说，在子组件中改变变更这个对象或数组本身将会影响到父组件的状态。
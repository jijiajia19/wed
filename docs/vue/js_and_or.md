# js中 && 和 || 运算符的用法

* 我在平时写js代码时，一般也就使用&&和||判断true和false，最近在看别人的js源码时，出现了大量的&&和||，一下子转不过弯来，因此重新看了下&&和||的用法*

# 两种运算符的用法

对于&&和||运算符，我一般只会使用到以下的判断：



```ruby
true && true = true;
true && false = false;
false && true = false;
false && false = false;

true || true = true;
true|| false = true;
false || true = true;
false || false  = false;
```

但再次看了2种运算符的说明，才发现之前的用法一直很局限。

> &&的返回值会返回最早遇到以下类型的值：
> NaN null undefined 0 false;

> ||的返回值会返回最早遇到的非以下类型的值：
> NaN null undefined 0 false;

并且&&运算符的优先级大于||运算符

# 使用示例

对于以下赋值语句，a的值是多少呢？



```jsx
var a=(undefined && 1 ) || (0 || 5)；
```

首先计算`undefined && 1`，由于&&运算符首先返回`NaN`、`null`、`undefined`、`0`、`false`，因此返回`undefined`。

然后对于`0||5`，由于||运算符首先返回非`NaN`、`null`、`undefined`、`0`、`false`，所以返回`5`。

最后，`undefined||5`，显然返回5。


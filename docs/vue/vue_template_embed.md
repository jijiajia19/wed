[vue中两个template标签嵌套有什么作用吗？](https://segmentfault.com/q/1010000010727886)
========================================================================



 ![](https://segmentfault.com/img/bVTaWm?w=621&h=371)

把中间的template标签改成div效果是一样的，用template有什么别的作用吗？



✓ 已被采纳

template不会渲染成元素，用div的话会被渲染成元素。把if,show,for等语句抽取出来放在template上面，把绑定的事件放在temlpate里面的元素上，可以使html结构更加清晰，还可以改善一个标签过长的情况。


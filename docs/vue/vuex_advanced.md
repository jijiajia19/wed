# Vuex进阶

> vuex的模块化:单一状态树,应用内的所有数据都会集中到一个比较大的store对象上,当应用规模较大时store对象就会变的十分臃肿;为了解决这个问题vuex允许我们将store进行模块分割;每个模块都拥有自己的store/mutations/actions/getters



```
开发过程中通常采用的模块化有两种方案;
一是按照功能模块化(即state/ mutations/ actions/ getters)各一个文件,
二是根据业务逻辑模块化(即按照应用功能划分，每一个都有独立的state/ mutations/ getters/ actions) 复制代码
```





### state

> 模块内的state对象是局部状态





```
const state = {
    count:11
} //moduleA.js

组件内调用:
this.$store.state.moduleA.name 调用局部状态中的数据复制代码
```



### getter

> 和state不同,getter /mutation/action在默认情况下是注册在全局命名空间的,只有当该模块开启命名空间(namespaced: true)时getter才是局部getter



```
const getters = {
    someGetters(state, getters, rootState, rootGetters){
         return state.name   
    }
}

参数:
state      : 当前模块状态
getters    : 全局getter(默认) / 局部getter(开启命名空间后)
rootState  : 根状态(开启命名空间后出现)
rootGetters: 全局getter(开启命名空间后出现)
当模块启用命名空间时,rootState和rootGetters会作为第3/4参数传入,通过它们可以调用根状态上的数据和根getter

组件内调用:


默认(未开启命名空间):
this.$store.getters['name']        //全局内的getter(无局部)

启用命名空间后:
this.$store.getters['name']        //全局getter
this.$store.getters['module/name'] //某个模块内getter复制代码
```



### mutations

> 它的参数只有state和payload, state也只是当前模块的状态;因此其内部
>
> 不可以访问根state&其他模块中的getters/mutations/actions



```
const mutations = {
    someMutations(state, payload){
        commit('someOtherMutations')
    }
}

组件内调用:
默认(未开启命名空间):
this.$store.commit('type', payload)            //全局内的mutation(无局部)

启用命名空间后:
this.$store.commit('module/type')                //某个模块内的mutation
this.$store.commit('type', payload, {root:true}) //全局mutation复制代码
```



### actions





```
const actions = {
    someActions({state, rootState, commit, dispatch, getters, rootGetters}, payload){
        参数: context & payload    
        state      : 局部状态
        rootState  : 根状态(启动命名空间后出现)
        commit
        dispatch
        getters     : 本模块的getter
        rootGetters : 根getter(启动命名空间后出现)
         	dispatch('someOtherAction') // ->本模块内moduleA/someOtherAction
    }
}

组件内调用:
默认(未开启命名空间)
this.$store.dispatch('someOtherAction', payload)  //全局(无局部)

启用命名空间后:
this.$store.dispatch('module/someOtherAction', payload)       //某模块内的someOtherAction
this.$store.dispatch('someOtherAction', payload, {root:true}) //全局内的someOtherAction复制代码
```





### 在带有命名空间的模块内注册全局action

> 若需要在带命名空间的模块注册全局 action，你可添加 `root: true`，并将这个 action 的定义放在函数 `handler` 中







```
export default = {
    namespaced: true,

    actions:{
        gloable_action :{
            root:true,
            handler(namespacedContext, payload){
                ...
            }//此时的gloable_action 就是全局的action
        }
    }
}复制代码
```







### 带命名空间的模块内使用辅助函数

> 模块化后组件内各属性的调用相比之前更加繁琐,也更容易出错;辅助函数显得更加方便





```
import {mapState, mapGetters, mapMutations, mapActions} from 'vuex'

为了更加方便的书写,辅助函数允许我们将模块命名字符转作为第一个参数传递,它会自动帮我们绑定到需要的地方
同样的,需要改变映射命名的就用对象的形式,否则更推荐数组(注意数组要用'')


组件内:
computed:{
    ...mapState('moduleA',{
         newName : state => state.name,
         newAge  : state => state.age,  
    }),

    ...mapGetters('moduleA', [
        'someGetters',
        'someOtherGetters'
    ])
},

methods:{
    ...mapMutations('moduleA',[
       'someMutation',
       'someOtherMutations'
    ]),

    ...mapActions('moduleA',{
        newActions      : 'someActions',
        newOtherActions : 'someOtherActions'
    })

}
```
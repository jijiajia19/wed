# IPV6

---

IPV6配置比IPV4更加便捷，配合更方便

128bit

16禁止表示*8分为8个段落

7个冒号进行分隔

> IPV6简写规则：
>
>  - 去除leading zero，开始的标号0
>
>  - 只能简写一个:0:0 -> ::
>
>  - 出现多个整体连续的0
>
>    :0:0:0:0->::



> IPV6地址种类:
>
> 公网地址-2000::/3，从此地址开始
>
> ISP最小的block是48
>
> ISP可以为32
>
> ISP最大的block是23

> 每个IPV6，必定有一个link-local address，它是自动产生的(FE80::/10)
>
> Global unicast 
>
> link-local FE80::/10
>
> unique local address(fc00::/7,fd00:/8)都是对的
>
> multicast FF00::/8
>
> anycast  DNS选择最快的host
>
> 实验地址 2001:DB8::/32

---

IPV6进行子网划分的时候，都划分为64，约定俗成

IPV6所有子网都是64位，将64-48=16位作为网络位



> 实验基本都用2001:DB8::/32
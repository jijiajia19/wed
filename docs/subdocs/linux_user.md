[linux 系统账户 和 普通账户 的区别](https://www.cnblogs.com/xuyaowen/p/linux-system-account.html)
=====================================================================================

最近使用 useradd -r 选项进行创建账户，用于测试，对-r 选项不是很明白，下面记录一些调研的过程：

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

       -r, --system
           Create a system account.

           System users will be created with no aging information in /etc/shadow, and their numeric identifiers are chosen in the
           SYS\_UID\_MIN\-SYS\_UID\_MAX range, defined in /etc/login.defs, instead of UID\_MIN-UID\_MAX (and their GID counterparts for the
           creation of groups).

           Note that useradd will not create a home directory for such a user, regardless of the default setting in /etc/login.defs
           (CREATE\_HOME). You have to specify the \-m options if you want a home directory for a system account to be created.

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

什么是系统账户？系统账户和普通账户有什么区别？（[参考连接](https://serverfault.com/questions/350931/in-what-condition-should-i-create-a-system-user-instead-of-a-normal-user)）

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

When you are creating an account to run a daemon, service, or other system software, rather than an account for interactive use.

Technically, it makes no difference, but in the real world it turns out there are long term benefits in keeping user and software accounts in separate parts of the numeric space.

Mostly, it makes it easy to tell what the account is, and if a human should be able to log in.

[![](https://common.cnblogs.com/images/copycode.gif)](# "复制代码")

系统账户的用户id一般是小于一千的；其实就是给UID一个确定的代号，它不能用于登录，一般是给程序来使用；

本地用户想要切换到系统用户可以使用如下命令：

su - hadoop -s /bin/bash
现在就切换到bash，可以正常运行了